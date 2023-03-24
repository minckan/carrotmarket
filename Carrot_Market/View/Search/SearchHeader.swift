//
//  SearchHeader.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/03/24.
//

import UIKit

class SearchHeader: UICollectionReusableView {
    // MARK: - Properties
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .carrotOrange500
        
        return view
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
        addSubview(containerView)
        containerView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 108)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    @objc func handleDismissal() {
        
    }
    // MARK: - Helpers
    func configure() {
        
    }
}
