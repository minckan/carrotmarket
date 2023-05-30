//
//  ProductController.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/03/21.
//

import UIKit
import Hero



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
        configureNavBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    


    // MARK: - Selectors
    @objc func handleRefresh() {
        fetchProduct()
    }
    

    // MARK: - API
    func fetchProduct() {
        collectionView.refreshControl?.beginRefreshing()
        ProductService.shared.fetchProduct { products in
            self.products = products
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        collectionView.backgroundColor = .white
        
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    func configureNavBar() {
        commonNav.delegate = self
        navigationItem.rightBarButtonItems = [commonNav.notificationButton, commonNav.menuButton, commonNav.searchButton]
    }
}

// MARK: - CollectionView Delegate / DataSource

extension ProductController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
        
        cell.product = products[indexPath.row]
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = ProductDetailController(product: products[indexPath.row])
        let nav = DynamicStatusBarNavigation(rootViewController: controller)

        nav.modalPresentationStyle = .fullScreen
        nav.hero.isEnabled = true
        nav.hero.modalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .pull(direction: .right))
    
        
        
        present(nav, animated: true)
       
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
