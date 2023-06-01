//
//  UserProductCell.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/05/18.
//

import UIKit

class UserProductCell : UICollectionViewCell {
    static let identifier = "UserProductCell"
    
    var product : Product? {
        didSet {
            configure()
        }
    }
    
    private let productThumbnail : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        return iv
    }()
    
    private let productNameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    private let productPriceLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        return label
    }()
    
    // MARK: - Lifecycles
    override init(frame: CGRect) {
        super.init(frame: frame)
     
        contentView.backgroundColor = .white
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func configure() {
        guard let product = product else {return}
        productThumbnail.sd_setImage(with: product.productImageUrls[0])
        productNameLabel.text = product.name
        
        let viewModel = ProductViewModel(product: product)
        productPriceLabel.text = viewModel.priceText
        
    
        contentView.addSubview(productThumbnail)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(productPriceLabel)
        
        let imageHeigt = Int(contentView.frame.height * 0.7)

        productThumbnail.snp.makeConstraints { make in
            make.left.right.top.equalTo(contentView)
            make.bottom.equalTo(productNameLabel.snp.top)
            make.height.equalTo(imageHeigt)
        }
        productNameLabel.snp.makeConstraints { make in
            make.left.right.equalTo(contentView)
            make.bottom.equalTo(productPriceLabel.snp.top).offset(10)
        }
        
        productPriceLabel.snp.makeConstraints { make in
            make.left.bottom.equalTo(contentView)
        }
        
    }
}
