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

private let reuseHeaderIdentifier = "ProductDetailHeader"

class ProductDetailController : UIViewController {
    // MARK: - Properties
    let scrollView : UIScrollView! = UIScrollView()
    let contentView : UIView! = UIView()
    
    

    let imageScrollView : UIScrollView = {
       let sv = UIScrollView()
        sv.isPagingEnabled = true
        return sv
    }()
    
    let pageControll = UIPageControl()
    
    private var product: Product
    let commonNav = CommonNavigation()
    
    
    private lazy var productImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true // 이미지 뷰 바깥 부분은 자르기
        iv.heightAnchor.constraint(equalToConstant: 400).isActive = true

        
        
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
        button.setDimensions(width: 100, height: 40)
        
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
//        label.text = "가구/인테리아"
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
        이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아요
        이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아요
        이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아요
        이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아요
        이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아요
        이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아요
        이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아요
        이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아요
        이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아요
        이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아요
        이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아요
        이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아요
        이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아요
        이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아요
        이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아요
        이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아요
        이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아요
        이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아요
        이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아요
        이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아요
        이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아요
        이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아요
        이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아요
        이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아요
        이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아요
        이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아요
        이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아요
        이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아요
        이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아요
        이케아 빌리책장 너무좋아요 진짜 너무 좋아요 좋아요
        """
        label.numberOfLines = 0
        label.sizeToFit()
        label.lineBreakMode = .byWordWrapping
        
        
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        commonNav.delegate = self
        commonNav.type = .white
        
        scrollView.delegate = self

      
        configureUI()
        configureNavBar()
        configureScrollView()
        


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // TODO: 네비게이션 바 컬러 변경하기
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
    
    // MARK: - Selectors
    @objc func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: "상태변경", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "판매중", style: .default, handler: {(ACTION:UIAlertAction) in
            self.statusChangeButton.setTitle("판매중", for: .normal)
        }))
        actionSheet.addAction(UIAlertAction(title: "예약중", style: .default, handler: {(ACTION:UIAlertAction) in
            self.statusChangeButton.setTitle("예약중", for: .normal)
        }))
        actionSheet.addAction(UIAlertAction(title: "거래완료", style: .default, handler: {(ACTION:UIAlertAction) in
            self.statusChangeButton.setTitle("거래완료", for: .normal)
        }))
        
        
        
        //취소 버튼 - 스타일(cancel)
        actionSheet.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        

    }
    
    // MARK: - API
    
    // MARK: - Helpers
    func configureScrollView() {

    }
    func configureUI() {

        view.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 66)
        
        scrollView.addSubview(contentView)
        contentView.anchor(top: scrollView.contentLayoutGuide.topAnchor, left: scrollView.contentLayoutGuide.leftAnchor, bottom: scrollView.contentLayoutGuide.bottomAnchor, right: scrollView.contentLayoutGuide.rightAnchor, paddingBottom: -100)
        
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        

        productImageView.sd_setImage(with: product.productImageUrl)

        contentView.addSubview(productImageView)
        productImageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: -100)
        
        
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
        userInfoStack.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        userInfoStack.isLayoutMarginsRelativeArrangement = true
        
        
        
        contentView.addSubview(userInfoStack)
        userInfoStack.backgroundColor = .white
        userInfoStack.anchor(top: productImageView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, height: 80)
        
        let divider = UIView()
        divider.backgroundColor = .systemGroupedBackground
        contentView.addSubview(divider)
        divider.anchor(left: contentView.leftAnchor, bottom: userInfoStack.bottomAnchor, right: contentView.rightAnchor, paddingLeft: 15, paddingRight: 15, height: 1.0)
        
        contentView.addSubview(statusChangeButton)
        statusChangeButton.anchor(top: userInfoStack.bottomAnchor, left: contentView.leftAnchor, paddingTop: 30, paddingLeft: 15)
        
        contentView.addSubview(productNameLabel)
        productNameLabel.anchor(top: statusChangeButton.bottomAnchor, left: contentView.leftAnchor, paddingTop: 20, paddingLeft: 15)
        
        let productInfoStack = UIStackView(arrangedSubviews: [productCategoryLabel, productUpdatedCntLabel])
        contentView.addSubview(productInfoStack)
        productInfoStack.anchor(top: productNameLabel.bottomAnchor, left: contentView.leftAnchor, paddingTop: 8, paddingLeft: 15)
        
        contentView.addSubview(captionLabel)
        captionLabel.anchor(top: productInfoStack.bottomAnchor, left: contentView.leftAnchor, paddingTop: 15, paddingLeft: 15)
        
        captionLabel.frame =  CGRect(x: 0, y: 0, width: scrollView.frame.width, height: 0)
        captionLabel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        // Footer
        let footer = ProductDetailFooter()
        view.addSubview(footer)
        footer.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, height: 100)
        
        print(captionLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize))
        
        guard let height = captionLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height as? CGFloat else { return }
        
        let contentViewHeight = contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, constant: height)
        contentViewHeight.priority = .defaultLow
        contentViewHeight.isActive = true
        
        
   
    }
    
    
    func configureNavBar() {
        navigationItem.leftBarButtonItems = [commonNav.backButton]
        
    }
    private func setPageControlSelectedPage(currentPage:Int) {
          pageControll.currentPage = currentPage
      }
   
}

extension ProductDetailController : ProductDetailHeaderDelegate {
    func handleDismiss() {
        self.dismiss(animated: true)
    }
}


extension ProductDetailController: CommonNavigationDelegate {
    var controller: UIViewController {
        return self
    }
}

extension ProductDetailController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY >= 250 {
            commonNav.type = .black
        } else {
            commonNav.type = .white
        }
    }
}
