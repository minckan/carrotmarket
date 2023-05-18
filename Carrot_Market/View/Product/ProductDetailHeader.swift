//
//  ProductDetailHeader.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/03/30.
//

import UIKit
import SDWebImage


class ProductDetailHeader : UICollectionReusableView {
    // MARK: - Properties

    var product: Product? {
        didSet {
            configure()
        }
    }
    
    private lazy var productImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true // 이미지 뷰 바깥 부분은 자르기
        iv.heightAnchor.constraint(equalToConstant: 400).isActive = true

        return iv
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        addSubview(productImageView)
        productImageView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
        
        
        
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selectors

    // MARK: - API
    
    // MARK: - Helpers
    func configure() {
        guard let product = product else {return}
        productImageView.sd_setImage(with: product.productImageUrl)
    }
}


