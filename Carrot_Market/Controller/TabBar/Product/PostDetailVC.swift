//
//  PostDetailVC.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/05/18.
//

import UIKit

class PostDetailVC : UIViewController{
    
    private lazy var detailCV : UICollectionView = {
        let layout = createLayout()
        layout.configuration.interSectionSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .carrotOrange400
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setDelegate() {
        detailCV.delegate = self
        detailCV.dataSource = self
    }
    
    private func setCollectionView() {
        detailCV.register(<#T##cellClass: AnyClass?##AnyClass?#>, forCellWithReuseIdentifier: <#T##String#>)
    }
    
}


extension PostDetailVC {
    internal func createLayout() ->UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionNumber, env in
            if sectionNumber == 0 {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(UIScreen.main.bounds.width), heightDimension: .absolute(UIScreen.main.bounds.width))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.visibleItemsInvalidationHandler = { items, contentOffset, environment in
                    let currentPage = Int(max(0, round(contentOffset.x / environment.container.contentSize.width)))
                    
                
                }
                
                return section
            } else {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(315))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(315))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                let section = NSCollectionLayoutSection(group: group)
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(85))
                let header =
                NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: PostDetailUserHeader.className, alignment: .topLeading)
                section.boundarySupplementaryItems = [header]
                section.orthogonalScrollingBehavior = .none
                return section
            }
        }
    }
}
