//
//  ProductController.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/03/21.
//

import UIKit

private let reuseIdentifier = "ProductCell"

class ProductController: UICollectionViewController {

    // MARK: - Properties
    
    var products = [Product]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let commonNav = CommonNavigation()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchProduct()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
        commonNav.delegate = self
        configureNavBar()
    }

    
    // MARK: - Selectors

    // MARK: - API
    func fetchProduct() {
        ProductService.shared.fetchProduct { products in
            self.products = products
        }
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
    }
    
    func configureNavBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.rightBarButtonItems = [commonNav.notificationButton, commonNav.menuButton, commonNav.searchButton]
    }
}

// MARK: - CollectionView Delegate / DataSource

extension ProductController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProductCell
        
        cell.product = products[indexPath.row]

        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = ProductDetailController()
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProductController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}


extension ProductController: CommonNavigationDelegate {
    var controller: UIViewController {
        return self
    }
}
