//
//  SearchController.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/03/24.
//

import UIKit

private let headerIdentifier = "SearchHeader"
private let reuseIdentifier = "SearchCell"




class SearchController : UICollectionViewController {
    // MARK: - Properties
    
    let commonNav = CommonNavigation()

    private let searchBar : UISearchBar = {
        let searchbar = UISearchBar()
        searchbar.placeholder = "상현동 근처에서 검색?"
        return searchbar
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavBar()
    }
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors

    // MARK: - API
    
    // MARK: - Helpers
    func configureUI() {
        
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(SearchHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func configureNavBar() {
        searchBar.delegate = self
        commonNav.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: commonNav.backButton)
        navigationItem.titleView = searchBar
    }
}

// MARK: - CollectionView Delegate / DataSource

extension SearchController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchCell
        return cell
    }
}

extension SearchController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! SearchHeader
        
        return header
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
}

//

extension SearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("DEBUG: \(searchText)")
    }
}

extension SearchController: CommonNavigationDelegate {
    var controller: UIViewController {
        return self
    }
}
