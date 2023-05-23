//
//  CommunityController.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/03/21.
//

import UIKit

private let reuseIdentifier = "UserProductCell"

class CommunityController: UICollectionViewController {


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

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UserProductCell.self, forCellWithReuseIdentifier: reuseIdentifier)
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

extension CommunityController : UICollectionViewDelegateFlowLayout{
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserProductCell
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
