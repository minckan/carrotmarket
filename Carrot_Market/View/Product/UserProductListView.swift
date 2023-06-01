//
//  UserProducts.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/05/22.
//

import UIKit

protocol UserProductListViewDelegate : AnyObject{
    func handleItemSelect(product: Product)
}

class UserProductListView : UIView {
    // MARK: - Properties
    let collectionView: UICollectionView
    var products : [Product] = []
    
    weak var delegate : UserProductListViewDelegate?
    
    private enum Const {
        static let Cellwidth = (UIScreen.main.bounds.width - 30) / 2
        static let itemSize = CGSize(width: Const.Cellwidth, height: Const.Cellwidth)
        static let itemSpacing = 15.0
    }
    
    // MARK: - Lifecycles
    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Const.itemSpacing
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
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
        
        collectionView.snp.makeConstraints { make in
            make.width.equalTo(self.snp.width)
            make.height.equalTo(self.snp.height)
        }
        
        collectionView.backgroundColor = .white
        
    }
    private func registerCells() {
        collectionView.register(UserProductCell.self, forCellWithReuseIdentifier: UserProductCell.identifier)
        
    }
    
    private func configure() {
        // 로딩 돌리다가 끄기?
        printDebug("user product is \(products)")
    }
    
    private func roundNumber(_ number:CGFloat) -> Int {
        let numberFormatter = NumberFormatter() //NumberFormatter 객체 생성
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.roundingMode = .ceiling
        
        guard let result = Int(numberFormatter.string(for: number) ?? "1") else { return 1 }
        
        return result
        
    }
}

extension UserProductListView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProductCell.identifier, for: indexPath) as! UserProductCell
        cell.product = products[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Const.Cellwidth, height: Const.Cellwidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.handleItemSelect(product: products[indexPath.row])
    }
}


