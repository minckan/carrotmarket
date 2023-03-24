//
//  SearchCell.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/03/24.
//

import UIKit

class SearchCell : UICollectionViewCell {
    // MARK: - Properties
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
