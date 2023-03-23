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
    
    private lazy var headerSearchButton: UIBarButtonItem = {
        let button = UIButton()
        let barItem = UIBarButtonItem(customView: button)
        button.setImage(UIImage(named: "search"), for: .normal)
        return barItem
    }()
    
    private lazy var headerMenuButton: UIBarButtonItem = {
        let button = UIButton()
        let barItem = UIBarButtonItem(customView: button)
        button.setImage(UIImage(named: "menu"), for: .normal)
        return barItem
    }()
    
    private lazy var headerNotificationButton: UIBarButtonItem = {
        let button = UIButton()
        let barItem = UIBarButtonItem(customView: button)
        button.setImage(UIImage(named: "setting"), for: .normal)
        return barItem
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchProduct()
       
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
        configureNavBar()
    }
    
    func configureNavBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.rightBarButtonItems = [headerNotificationButton, headerMenuButton, headerSearchButton]
        
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
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProductController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}
