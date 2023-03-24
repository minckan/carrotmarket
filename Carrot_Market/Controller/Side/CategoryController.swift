//
//  CategoryController.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/03/24.
//

import UIKit

class CategoryController: UIViewController {
    
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    
    // MARK: - API
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "중고거래 카테고리"
    }
}
