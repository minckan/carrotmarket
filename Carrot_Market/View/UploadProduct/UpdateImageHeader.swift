//
//  UpdateImageHeader.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/05/30.
//

import UIKit

protocol UpdateImageHeaderDelegate: AnyObject {
    func handleImagePicker()
}

class UpdateImageHeader : UICollectionReusableView {
    // MARK: - Properties
    static let identifier = "UpdateImageHeader"
    weak var delegate: UpdateImageHeaderDelegate?
    var imageCount: Int? {
        didSet {
            setCount()
        }
    }
    
    private lazy var addImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightBorder.cgColor
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor.rgb(red: 239, green: 246, blue: 250)
        button.setImage(UIImage(named: "icon_camera")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleAddProductImage), for: .touchUpInside)
        button.setTitle("0/10", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.setTitleColor(.black, for: .normal)
        button.alignTextBelow()
        
        return button
    }()
    
    // MARK: - Lifecycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(addImageButton)
        addImageButton.snp.makeConstraints { make in
            make.left.bottom.equalTo(self)
            make.height.width.equalTo(80)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    @objc func handleAddProductImage() {
        delegate?.handleImagePicker()
    }
    
    // MARK: - Helpers
    func setCount() {
        guard let count  = imageCount else {return}
        addImageButton.setTitle("\(count)/10", for: .normal)
    }
    
}
