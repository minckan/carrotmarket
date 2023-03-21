//
//  ProductCell.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/03/21.
//

import UIKit

class ProductCell: UICollectionViewCell {
    // MARK: - Properties
    var product: Product? {
        didSet {
            
        }
    }
    
    private lazy var productImageView : UIImageView = {
       let iv = UIImageView()
        iv.backgroundColor = .carrotOrange400
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 90, height: 90)
        iv.layer.cornerRadius = 10
        
        return iv
    }()
    
    private let productNameLabel : UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "IPhone 14"
        return label
    }()
    
    private let productPriceLabel : UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "$" + "1500"
        return label
    }()
    

    
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
        stack.anchor(top: topAnchor, left: productImageView.rightAnchor, paddingTop: 26,  paddingLeft: 10)
        
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = UIColor.lightBorder.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width: self.frame.size.width, height: borderWidth)
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
        let likesButton = AttributedStrings().LeftImageButton(withImage: UIImage(named: "heart")!, count: 0)
        addSubview(likesButton)
        
        likesButton.anchor(bottom: bottomAnchor, right: rightAnchor, paddingBottom: 20, paddingRight: 20)
    
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    // MARK: - API
    
    // MARK: - Helpers
    
}
