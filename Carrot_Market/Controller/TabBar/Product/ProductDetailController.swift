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
    
    private var product: Product
    let commonNav = CommonNavigation()
    
    private lazy var productImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true // 이미지 뷰 바깥 부분은 자르기
        iv.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
        return iv
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        commonNav.delegate = self
        commonNav.mainColor = .white
        
      
        configureUI()
        configureNavBar()
        


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

    
    // MARK: - API
    
    // MARK: - Helpers
    func configureUI() {

        view.backgroundColor = .carrotOrange400
        
        productImageView.sd_setImage(with: product.productImageUrl)
        view.addSubview(productImageView)
        productImageView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)

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
