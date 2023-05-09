//
//  CategoryController.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/03/24.
//

import UIKit

class CategoryController: UIViewController {
    
    
    // MARK: - Properties
    let commonNav = CommonNavigation()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavBar()
    }
    
    // MARK: - Selectors
    
    // MARK: - API
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "중고거래 카테고리"
    }
    func configureNavBar() {
        commonNav.delegate = self
        navigationItem.leftBarButtonItems = [commonNav.backButton]
    }
}

extension CategoryController : CommonNavigationDelegate {
    var controller: UIViewController {
        return self
    }
}
