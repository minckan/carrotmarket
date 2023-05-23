//
//  ProductDetailController.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/03/28.
//

import UIKit
import SDWebImage
import Hero
import SnapKit
import LinkPresentation
import MapKit

private let reuseHeaderIdentifier = "ProductDetailHeader"
private let reuseIdentifier = "UserProductCell"

class ProductDetailController : UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    // MARK: - Properties
    private var product: Product
    private var previousStatusBarHidden = false
    let locationManager = CLLocationManager()
    let pageControll = UIPageControl()
    let commonNav = CommonNavigation()
    
    let scrollView : UIScrollView! = UIScrollView()
    let contentView : UIStackView! = UIStackView(arrangedSubviews: [])
    private var metaData: LPLinkMetadata = LPLinkMetadata() {
        didSet {
            DispatchQueue.main.async {
                self.shareURLWithMetadata(metadata: self.metaData)
            }
        }
    }
    let collectionView = UserProductListView()
    let footer = ProductDetailFooter()
    
    
    private let imageContainer = UIView()
    private lazy var productImageView : UIImageView = {
        let iv =  UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true // 이미지 뷰 바깥 부분은 자르기
        return iv
    }()
    
    private let userProfileImg: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.layer.masksToBounds = true
        iv.setDimensions(width: 40, height: 40)
        iv.layer.cornerRadius = 40 / 2
    
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "노마드"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let userLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "상현2동"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let userTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gradeGreen
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "40.4°C"
        return label
    }()
    
    private let userTemperBar: UIProgressView = {
        let pv = UIProgressView()
        pv.tintColor = .gradeGreen
        pv.setProgress(0.5, animated: false)
        
        return pv
    }()
    
    private let statusChangeButton: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray5.cgColor
        
        button.setTitle("판매중", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.titleLabel?.font = .boldSystemFont(ofSize: 12)
        button.contentHorizontalAlignment = .center
        
        button.semanticContentAttribute = .forceRightToLeft //<- 중요
                
        button.imageEdgeInsets = .init(top: 0, left: 15, bottom: 0, right: 15) //<- 중요
        button.setImage(UIImage(named: "down_arrow_24pt")?.withRenderingMode(.alwaysOriginal).withTintColor(.lightGray), for: .normal)
        
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        
        return button
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.text = "이케아 빌리책장 1 unit"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let productCategoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        
        let text = "가구/인테리어"
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.underlineStyle, value: 1, range: NSRange(location: 0, length: text.count))
        label.attributedText = attributedString
        
        return label
    }()
    private let productUpdatedCntLabel: UILabel = {
        let label = UILabel()
        label.text = "끝올 3일전"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    private let productContentLabel: UILabel = {
        let label = UILabel()
        label.text = "끝올 3일전"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    private let captionLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        
        label.text = """
        이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아여 이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아여 이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아여 이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아여 이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아여 이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아여
        """
        label.numberOfLines = 0
        label.sizeToFit()
        label.lineBreakMode = .byCharWrapping
        
        
        return label
    }()
    
    private let locationTitleLabel : UILabel = {
        let label = UILabel()
        label.text = "거래 희망 장소"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let locationButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("신미주 아파트", for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.contentHorizontalAlignment = .center
        button.semanticContentAttribute = .forceRightToLeft
        button.imageEdgeInsets = .init(top: 0, left: 15, bottom: 0, right: 15)
        button.setImage(UIImage(named: "arrow_right"), for: .normal)
        return button
    }()
    
    
    private let mapView: MKMapView = {
       let mv = MKMapView()
       
        return mv
    }()
    
    private let interestAndInquiryLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.text = "관심 1﹒조회 46"
        
        return label
    }()
    

    private let relatedProductLabel : UILabel = {
        let label = UILabel()
        label.text = "멋쟁이님의 판매 상품"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    let relatedProductButton:UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .center
        button.setImage(UIImage(named: "arrow_right"), for: .normal)
        return button
    }()
    
    
    
   
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        commonNav.delegate = self
        commonNav.buttonHandelerDelegate = self
        commonNav.type = .white
        
        scrollView.delegate = self


        configureUI()
        configureNavBar()


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }


    
    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if commonNav.isDarkContentBackground {
            return .lightContent
        } else {
            return .darkContent
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    // MARK: - Selectors
    @objc func showActionSheet() {
        let actions = [UIAlertAction(title: "판매중", style: .default, handler: {(ACTION:UIAlertAction) in
            self.statusChangeButton.setTitle("판매중", for: .normal)
        }), UIAlertAction(title: "예약중", style: .default, handler: {(ACTION:UIAlertAction) in
            self.statusChangeButton.setTitle("예약중", for: .normal)
        }), UIAlertAction(title: "거래완료", style: .default, handler: {(ACTION:UIAlertAction) in
            self.statusChangeButton.setTitle("거래완료", for: .normal)
        }), UIAlertAction(title: "닫기", style: .cancel, handler: nil)]
    
        let actionSheet = createActionSheet(title: nil, message: "상태변경", actions: actions)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - API
    
    // MARK: - Helpers
    func configureUI() {

        view.backgroundColor = .white
        view.addSubview(scrollView)
        view.addSubview(footer)
        scrollView.contentInsetAdjustmentBehavior = .never
   
        
        imageContainer.backgroundColor = .darkGray
        
        productImageView.sd_setImage(with: product.productImageUrl)
        

        scrollView.addSubview(imageContainer)
        scrollView.addSubview(contentView)
        
        contentView.distribution = .fill
        contentView.spacing = 16
        contentView.axis = .vertical
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(imageContainer.snp.bottom)
            make.left.right.equalTo(view).inset(15)
            make.bottom.equalTo(scrollView).inset(10)
        }
        
        scrollView.addSubview(productImageView)
       
        footer.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, height: 100)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.left.right.equalTo(view)
            make.bottom.equalTo(footer.snp.top)
        }

        imageContainer.snp.makeConstraints { make in
            make.top.equalTo(scrollView)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(imageContainer.snp.width).multipliedBy(0.7)
        }
                
        productImageView.snp.makeConstraints { make in
            make.left.right.equalTo(imageContainer)
            make.top.equalTo(view).priority(.high)
            make.height.greaterThanOrEqualTo(imageContainer.snp.height).priority(.required)
            make.bottom.equalTo(imageContainer.snp.bottom)
        }

        
        let userNameStack = UIStackView(arrangedSubviews: [usernameLabel, userLocationLabel])
        userNameStack.axis = .vertical
        userNameStack.spacing = 5
        
        let userInfoLeftStack = UIStackView(arrangedSubviews: [userProfileImg, userNameStack])
        userInfoLeftStack.axis = .horizontal
        userInfoLeftStack.spacing = 10
        userInfoLeftStack.alignment = .center
        
        let userInfoRightStack = UIStackView(arrangedSubviews: [userTemperatureLabel, userTemperBar])
        userInfoRightStack.axis = .vertical
        userInfoRightStack.spacing = 5
        
        
        let userInfoStack = UIStackView(arrangedSubviews: [userInfoLeftStack, userInfoRightStack])
        userInfoStack.axis = .horizontal
        userInfoStack.distribution = .equalSpacing
        userInfoStack.alignment = .center
        
        contentView.addArrangedSubview(userInfoStack)
        userInfoStack.backgroundColor = .white
        userInfoStack.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.height.equalTo(80)
        }

        let divider = UIView()
        divider.backgroundColor = .systemGroupedBackground
        contentView.addArrangedSubview(divider)
        divider.snp.makeConstraints { make in
            make.left.equalTo(contentView)
            make.bottom.equalTo(userInfoStack)
            make.right.equalTo(contentView)
            make.height.equalTo(1.0)
        }
        
        contentView.addArrangedSubview(statusChangeButton)
        statusChangeButton.snp.makeConstraints { make in
            make.left.equalTo(contentView)
            make.top.equalTo(userInfoStack.snp.bottom).offset(30)
            make.width.equalTo(120)
        }
        statusChangeButton.setDimensions(width: 100, height: 38)
        contentView.addArrangedSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { make in
            make.top.equalTo(statusChangeButton.snp.bottom).offset(20)
        }
        
        let productInfoStack = UIStackView(arrangedSubviews: [productCategoryLabel, productUpdatedCntLabel])
        contentView.addArrangedSubview(productInfoStack)
        productInfoStack.snp.makeConstraints { make in
            make.top.equalTo(productNameLabel.snp.bottom).offset(8)
        }
        
        contentView.addArrangedSubview(captionLabel)
        captionLabel.snp.makeConstraints { make in
            make.top.equalTo(productInfoStack.snp.bottom).offset(15)
        }
        
        captionLabel.frame =  CGRect(x: 0, y: 0, width: scrollView.frame.width, height: 0)
        captionLabel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        

        let locationStack = UIStackView(arrangedSubviews: [locationTitleLabel, UIView(), locationButton])
        locationStack.alignment = .fill
        locationStack.distribution = .fill
        
        let spacerView = locationStack.arrangedSubviews[1]
        spacerView.setContentHuggingPriority(.required, for: .horizontal)
        spacerView.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        contentView.addArrangedSubview(locationStack)
        locationStack.snp.makeConstraints { make in
            make.top.equalTo(captionLabel.snp.bottom).offset(20)
        }

        
        contentView.addArrangedSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.equalTo(locationStack.snp.bottom).offset(20)
            make.height.equalTo(200)
        }
        
       
        contentView.addArrangedSubview(interestAndInquiryLabel)
        interestAndInquiryLabel.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(20)
        }
        let relatedProductStack = UIStackView(arrangedSubviews: [relatedProductLabel, UIView(), relatedProductButton])
        relatedProductStack.alignment = .fill
        relatedProductStack.distribution = .fill
        
        contentView.addArrangedSubview(relatedProductStack)
        relatedProductStack.snp.makeConstraints { make in
            make.top.equalTo(interestAndInquiryLabel.snp.bottom).offset(20)
        }
        
        contentView.addArrangedSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(relatedProductStack.snp.bottom).offset(5)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(contentView)
            make.width.equalTo(contentView.snp.width)
            make.height.equalTo(400)
        }
      
    }
    
    func configureCollectionView() {

    }
    
    func configureMap() {
        mapView.delegate = self
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
    }
    
    func configureNavBar() {
        navigationItem.leftBarButtonItems = [commonNav.backButton, commonNav.homeButton]
        navigationItem.rightBarButtonItems = [commonNav.actionSheetButton, commonNav.uploadButton]
    }
    private func setPageControlSelectedPage(currentPage:Int) {
          pageControll.currentPage = currentPage
      }
    
    func shareURLWithMetadata(metadata: LPLinkMetadata) {
        let metadataItemSource = LinkPresentationItemSource(metadata: metadata)
        
        let activityVC = UIActivityViewController(activityItems: [metadataItemSource], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view

        
        
        // 공유하기 기능 중 제외할 기능이 있을때 사용
//        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        self.present(activityVC, animated: true)
    }
   
}


extension ProductDetailController: CommonNavigationDelegate {
    var controller: UIViewController {
        return self
    }
}

extension ProductDetailController: CommonNavigationButtonHandlerDelegate {
    func handleActionSheet() {
        let actions = [UIAlertAction(title: "신고", style: .default, handler: {(ACTION:UIAlertAction) in
            //
        }), UIAlertAction(title: "이 사용자의 글 보지 않기", style: .default, handler: {(ACTION:UIAlertAction) in
            //
        }), UIAlertAction(title: "취소", style: .cancel, handler: nil)]
    
        let actionSheet = createActionSheet(title: nil, message: nil, actions: actions)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func handleShareButton() {
        self.metaData = getMetadataForSharingManually(title: "당근마켓에서 이 글을 확인해보세요!", url: nil, fileName: nil, fileType: nil)
        shareURLWithMetadata(metadata: metaData)
    }
    

}

extension ProductDetailController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
    
        if offsetY >= 200 {
            commonNav.type = .black
        } else {
            commonNav.type = .white
        }
        if previousStatusBarHidden != shouldHideStatusBar {
            
            UIView.animate(withDuration: 0.2, animations: {
                self.setNeedsStatusBarAppearanceUpdate()
            })
            
            previousStatusBarHidden = shouldHideStatusBar
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return shouldHideStatusBar
    }
    
    private var shouldHideStatusBar : Bool {
        let frame = contentView.convert(contentView.bounds, to: nil)
        return frame.minY < view.safeAreaInsets.top
    }
}

