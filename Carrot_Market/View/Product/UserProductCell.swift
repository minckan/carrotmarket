//
//  UserProductCell.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/05/18.
//

import UIKit

class UserProductCell : UICollectionViewCell {
    // MARK: - Lifecycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
