//
//  ProductCell.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/03/21.
//

import UIKit
import SDWebImage
import Hero

class ProductCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "ProductCell"
    
    var product: Product? {
        didSet {
            configure()
        }
    }
    
    private lazy var productImageView : UIImageView = {
       let iv = UIImageView()
        iv.backgroundColor = .carrotOrange400
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 90, height: 90)
        iv.layer.cornerRadius = 10
        
        return iv
    }()
    
    private let productNameLabel : UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let productPriceLabel : UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let likesButton = AttributedStrings().LeftImageButton(withImage: UIImage(named: "heart")!)

    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        
        addSubview(productImageView)
        productImageView.anchor(left: leftAnchor, paddingLeft: 20)
        productImageView.centerY(inView: self)
        
        let stack = UIStackView(arrangedSubviews: [productNameLabel, productPriceLabel])
        stack.axis = .vertical
        stack.spacing = 10
        addSubview(stack)
        stack.anchor(top: topAnchor, left: productImageView.rightAnchor, right: rightAnchor, paddingTop: 26,  paddingLeft: 10, paddingRight: 10)
        
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = UIColor.lightBorder.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width: self.frame.size.width, height: borderWidth)
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
        addSubview(likesButton)
        likesButton.anchor(bottom: bottomAnchor, right: rightAnchor, paddingBottom: 20, paddingRight: 20)
    
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    // MARK: - API
    
    // MARK: - Helpers
    func configure() {
        guard let product = product else {return}
        let viewModel = ProductViewModel(product: product)
       
        productNameLabel.text = product.name
        productPriceLabel.text = viewModel.priceText
        
        let productImage = product.productImageUrls[0]
        productImageView.sd_setImage(with: productImage)
        productImageView.hero.id =  product.id
        
        let title = NSAttributedString(string: String(product.likes), attributes: [.font: UIFont.systemFont(ofSize: 14)])
        likesButton.setAttributedTitle(title, for: .normal)
    }
    
}
