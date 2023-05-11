//
//  ProductDetailHeader.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/03/30.
//

import UIKit

protocol ProductDetailHeaderDelegate:AnyObject {
    func handleDismiss()
}

class ProductDetailHeader : UIView {
    // MARK: - Properties
    weak var delegate:ProductDetailHeaderDelegate?
    
    lazy var backButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "back")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), for: .normal)
        
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Selectors
    @objc func handleBackButton() {
        delegate?.handleDismiss()
    }
    // MARK: - API
    
    // MARK: - Helpers
    func configureUI() {

        addSubview(backButton)
        backButton.centerY(inView: self)
        backButton.anchor(left: leftAnchor, paddingLeft: 10)
    }
}


