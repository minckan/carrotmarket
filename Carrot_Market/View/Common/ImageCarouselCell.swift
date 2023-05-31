//
//  ImageCarouselCell.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/05/30.
//

import UIKit
import SDWebImage

class ImageCarouselCell : UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "ImageCarouselCell"
    
    let imageView = UIImageView()


    var url : URL? {
        didSet {
            configure()
        }
    }

    // MARK: - Lifecycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .brown
        
        contentView.backgroundColor = .gradeGreen

       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func configure() {
        guard let url = url else {return}
        
        contentView.snp.makeConstraints { make in
            make.edges.width.height.equalToSuperview()
        }
        
        imageView.sd_setImage(with: url)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        addSubview(imageView)
        
     
        imageView.snp.makeConstraints { make in
            make.edges.width.height.equalToSuperview()
        }
    }
}
