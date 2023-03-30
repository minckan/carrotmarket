//
//  ProductDetailController.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/03/28.
//

import UIKit
import SDWebImage

private let reuseHeaderIdentifier = "ProductDetailHeader"

class ProductDetailController : UIViewController {
    // MARK: - Properties
    let commonNav = CommonNavigation()
    
    private lazy var imageViewTest : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "product_sample") // 기본 이미지 설정

        iv.setDimensions(width: 100, height: 100)
        iv.backgroundColor = .red
            
        return iv
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavBar()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // TODO: 네비게이션 바 컬러 변경하기
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Selectors
    
    // MARK: - API
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(imageViewTest)
        imageViewTest.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0)

    }
    func configureNavBar() {
        commonNav.delegate = self
        
        let headerView = ProductDetailHeader()
//        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 44) // 헤더 뷰의 위치 및 크기 설정
        view.addSubview(headerView) // 커스텀 헤더를 뷰 계층 구조에 추가합니다.
        headerView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, width: view.frame.width, height: 100)
        
    }
}

extension ProductDetailController: CommonNavigationDelegate {
    var controller: UIViewController {
       return self
    }
}

