//
//  ProductDetailController2.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/05/18.
//

import UIKit

private let reuseIdentifier = "UserProductCell"
private let reuseHeaderIdentifier = "ProductDetailHeader"

class ProductDetailController2 : UIViewController {
    
    // MARK: - Properties
    private var product: Product
    
    let nav = CommonNavigation()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        registerUI()
        configureNavBar()
        configureUI()
    }
    
    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func registerUI() {
        nav.delegate = self
        nav.type = .white
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(ProductDetailHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier)
        collectionView.register(UserProductCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func configureNavBar() {
        navigationItem.leftBarButtonItems = [nav.backButton, nav.homeButton]
        navigationItem.rightBarButtonItems = [nav.actionSheetButton, nav.uploadButton]
    }
    
    func configureUI() {
        let footer = ProductDetailFooter()
        view.addSubview(footer)
        footer.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, height: 100)
        
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: footer.topAnchor, right: view.rightAnchor)
        
    }
    
}

extension ProductDetailController2: CommonNavigationDelegate {
    var controller: UIViewController {
        return self
    }
}

extension ProductDetailController2 : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserProductCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseHeaderIdentifier, for: indexPath) as! ProductDetailHeader
        
        print("DEBUG: \(header.frame.height)")
        
        header.product = product
        
        
        return header
    }
    
}

extension ProductDetailController2 : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        
        
        return CGSize(width: view.frame.width, height: 500)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2, height: 100)
    }
}


