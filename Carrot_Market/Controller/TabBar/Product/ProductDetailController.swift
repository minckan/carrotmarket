//
//  ProductDetailController.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/03/28.
//

import UIKit
import SDWebImage
import Hero

private let reuseHeaderIdentifier = "ProductDetailHeader"

class ProductDetailController : UIViewController {
    // MARK: - Properties
    let scrollView : UIScrollView! = UIScrollView()
    let contentView : UIView! = UIView()
    
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        commonNav.delegate = self
        commonNav.mainColor = .white
      
        configureUI()
        configureNavBar()
        configureScrollView()
        


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // TODO: 네비게이션 바 컬러 변경하기
//        navigationController?.navigationBar.isHidden = true
        
        
    }
    

    
    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        scrollView.addSubview(contentView)
        
        
        // ScrollView
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
        
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        let contentViewHeight = contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        contentViewHeight.priority = .defaultLow
        contentViewHeight.isActive = true

        
        
        
        productImageView.sd_setImage(with: product.productImageUrl)
        contentView.addSubview(productImageView)
        productImageView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
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
        userInfoStack.anchor(top: productImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, height: 80)
        
        let divider = UIView()
        divider.backgroundColor = .systemGroupedBackground
        contentView.addSubview(divider)
        divider.anchor(left: view.leftAnchor, bottom: userInfoStack.bottomAnchor, right: view.rightAnchor, paddingLeft: 15, paddingRight: 15, height: 1.0)
        
        contentView.addSubview(statusChangeButton)
        statusChangeButton.anchor(top: userInfoStack.bottomAnchor, left: view.leftAnchor, paddingTop: 30, paddingLeft: 15)
        
        contentView.addSubview(productNameLabel)
        
        let productInfoStack = UIStackView(arrangedSubviews: [productCategoryLabel, productUpdatedCntLabel])
        contentView.addSubview(productInfoStack)
    
    }
    
    
    func configureNavBar() {
        navigationItem.leftBarButtonItems = [commonNav.backButton]
        
//        let headerView = ProductDetailHeader()
//        headerView.delegate = self
//        view.addSubview(headerView) // 커스텀 헤더를 뷰 계층 구조에 추가합니다.
//        headerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, width: view.frame.width, height: 50)

        
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
