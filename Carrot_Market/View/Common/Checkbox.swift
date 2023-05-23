//
//  Checkbox.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/05/23.
//

import UIKit

class Checkbox : UIButton {
    // MARK: - Properties
    
    // MARK: - Lifecycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func configureUI() {
        layer.cornerRadius = 3
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightBorder.cgColor
        snp.makeConstraints { make in
            make.height.equalTo(10)
            make.width.equalTo(10)
        }
        
        setImage(UIImage(named: "check"), for: .normal)
        imageView?.tintColor = .white
    }
}
