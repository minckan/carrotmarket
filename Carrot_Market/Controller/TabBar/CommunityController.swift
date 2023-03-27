//
//  CommunityController.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/03/21.
//

import UIKit

class CommunityController: UIViewController {


    // MARK: - Properties
    let commonNav = CommonNavigation()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        congigureNavBar()
    }
    
    // MARK: - Selectors
    
    // MARK: - API
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "동네생활"
    }
    
    func congigureNavBar() {
        commonNav.delegate = self
        navigationItem.rightBarButtonItems = [commonNav.notificationButton, commonNav.profileButton, commonNav.searchButton]
    }
}

extension CommunityController: CommonNavigationDelegate {
    var controller: UIViewController {
       return self
    }
}
