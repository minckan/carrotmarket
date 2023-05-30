//
//  ImageCarouselView.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/05/30.
//

import UIKit

class ImageCarouselView : UIView {
    // MARK: - Properties
    private enum Const {
        static let itemSize = CGSize(width: UIScreen.main.bounds.width, height: 300)
        static var collectionViewContentInset: UIEdgeInsets {
            UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
      let layout = UICollectionViewFlowLayout()
      layout.scrollDirection = .horizontal
      layout.itemSize = Const.itemSize
      layout.minimumLineSpacing = 0
      layout.minimumInteritemSpacing = 0
      return layout
    }()
    
    private lazy var collectionView : UICollectionView = {
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewFlowLayout)
        view.contentInset = Const.collectionViewContentInset
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = true
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.isPagingEnabled = true
        view.contentInsetAdjustmentBehavior = .never
        view.decelerationRate = .fast
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var images : [URL]
    
    
    // MARK: - Lifecycles
    override init(frame: CGRect) {
        self.images = []
        
        super.init(frame: frame)
    }
    
    convenience init(images: [URL]) {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300))
        self.images = images
        
        collectionView.register(ImageCarouselCell.self, forCellWithReuseIdentifier: ImageCarouselCell.identifier)
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension ImageCarouselView : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCarouselCell.identifier, for: indexPath) as! ImageCarouselCell
        
        cell.url = images[indexPath.row]
        
        return cell
    }
    
    
}
