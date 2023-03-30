//
//  ProductDetailHeader.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/03/30.
//

import UIKit

class ProductDetailHeader : UIView {
    // MARK: - Properties
    let commonNav = CommonNavigation()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Selectors
    
    // MARK: - API
    
    // MARK: - Helpers
    func configureUI() {
        backgroundColor = UIColor.systemPink
    }
}


