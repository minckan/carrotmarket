//
//  UserProducts.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/05/22.
//

import UIKit

private let reuseIdentifier = "UserProductCell"

class UserProductListView : UIView {
    // MARK: - Properties
    private let collectionView: UICollectionView
    
    // MARK: - Lifecycles
    override init(frame: CGRect) {
        print("DEBUG: set collectionview called")
        let layout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        super.init(frame: frame)
        setupCollectionView()
        registerCells()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func setupCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        addSubview(collectionView)
        collectionView.frame = bounds
    }
    private func registerCells() {
        print("DEBUG: registerCells")
        collectionView.register(UserProductCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
    }
}

extension UserProductListView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("DEBUG: cellForItemAt called")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserProductCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = frame.size.width / 3
            return CGSize(width: width - 4, height: width - 4)
        }
}


