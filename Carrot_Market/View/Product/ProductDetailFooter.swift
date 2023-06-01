//
//  ProductDetailFooter.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/05/12.
//

import UIKit

class ProductDetailFooter : UIView {
    // MARK: - Properties
    let view = UIView()
    
    private var product:Product?
    
    private let button : UIButton = {
        let button = UIButton()
        button.backgroundColor = .carrotOrange500
        button.setTitle("채팅하기", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 6
        button.setDimensions(width: 90, height: 35)
        
        return button
    }()
    
    let border : UIView = {
        let border = UIView()
        border.backgroundColor = .systemGray6
        border.setDimensions(width: 1, height: 35)
        return border
    }()

    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like_unselected"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleLikeButton), for: .touchUpInside)
        return button
    }()
    
    private let productPriceLabel : UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let statusLabel : UILabel = {
       let label = UILabel()
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(_ product: Product) {
        self.init(frame: .zero)
        self.product = product
        configureUI()
        fetchIfUserLikedProduct()
    }
    
    // MARK: - Selectors
    @objc func handleLikeButton() {
        guard var product = product else {return}
        ProductService.shared.likeProduct(forProduct: product) { err, ref in
            product.didLike.toggle()
            
            let likes = product.didLike ? product.likes - 1 : product.likes + 1
            product.likes = likes
            
        }
    }
    
    // MARK: - Helpers
    func fetchIfUserLikedProduct() {
        guard var product = product else {return}
        ProductService.shared.checkDidLiked(forProduct: product) { didLike in
            guard didLike == true else {return}
            product.didLike = true
        }
    }
    func configureUI() {
        backgroundColor = .white

        addTopBorder(with: .systemGray6, andWidth: 1)
        
        
        addSubview(view)
        view.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 15)
        
        view.addSubview(likeButton)
        likeButton.anchor(left: view.leftAnchor)
        likeButton.centerY(inView: view)
        
        view.addSubview(border)
        border.centerY(inView: view, leftAnchor: likeButton.rightAnchor, paddingLeft: 15)
        
        let stack = UIStackView(arrangedSubviews: [productPriceLabel, statusLabel])
        stack.translatesAutoresizingMaskIntoConstraints = true
        stack.heightAnchor.constraint(equalToConstant: 35).isActive = true
        stack.axis = .vertical
        view.addSubview(stack)
        stack.centerY(inView: view, leftAnchor: border.rightAnchor, paddingLeft: 15)
        
        view.addSubview(button)
        button.centerY(inView: view)
        button.anchor(right: view.rightAnchor)
        
  
        guard let product = product else {return}
        
        let viewModel = ProductViewModel(product: product)
        statusLabel.attributedText = viewModel.negotiableValue
        productPriceLabel.text = viewModel.priceText
        likeButton.setImage(viewModel.likeImage, for: .normal)
        
      
    }
    
    func addTopBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: borderWidth)
        addSubview(border)
    }
}
