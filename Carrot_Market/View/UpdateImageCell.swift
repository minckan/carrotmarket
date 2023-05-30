//
//  UpdateImageCell.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/05/25.
//

import UIKit

protocol UpdateImageCellDelegate: AnyObject {
    func handleDeleteImage(at index: Int)
}

private let REPRESENT_LABEL_TAG_ID = 50000
private let DELETE_BUTTON_TAG_ID = 10000

class UpdateImageCell: UICollectionViewCell {
    static let identifier = "UpdateImageCell"
    
    // MARK: - Properties
    weak var delegate : UpdateImageCellDelegate?
    
    var view : UIView? {
        didSet {
            configureView()
        }
    }
    
    var index : Int? {
        didSet {
            configureUI()
            print("DEBUG: new index is set as \(index)")
        }
    }

    private let deleteBtn : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "x")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), for: .normal)
        button.setDimensions(width: 20, height: 20)
        button.layer.cornerRadius = 20 / 2
        button.backgroundColor = .black
        button.imageView?.setDimensions(width: 15, height: 15)
        
        return button
    }()
    
    // MARK: - Lifecycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Selectors
    @objc func handleDelete() {
        guard let index = index else {return}
        delegate?.handleDeleteImage(at: index)
    }
    
    // MARK: - Helpers
    private func configureView() {
        guard let view = view else {return}
        addSubview(view)
        view.snp.makeConstraints { make in
            make.left.top.bottom.equalTo(self)
            make.width.equalTo(80)
        }
    }
    
    private func configureUI() {
        guard let index = index else {return}
        
        if let subview = subviews.first(where: {$0.tag == REPRESENT_LABEL_TAG_ID}) {
            subview.removeFromSuperview()
        }
        if index == 1 {setRepresentPhotoLabel()}
        if index > 0 {setDeleteButton()}
        else {
            if let subview = subviews.first(where: {$0.tag == DELETE_BUTTON_TAG_ID}) {
                subview.removeFromSuperview()
            }
        }
    }
    
    func setDeleteButton() {
        addSubview(deleteBtn)
        deleteBtn.snp.makeConstraints { make in
            make.right.equalTo(self).offset(0)
            make.top.equalTo(self).offset(-10)
        }
        deleteBtn.addTarget(self, action:#selector(handleDelete) , for: .touchUpInside)
        deleteBtn.tag = DELETE_BUTTON_TAG_ID
    }
    

    func setRepresentPhotoLabel() {
        let label = UILabel()
        label.text = "대표사진"
        addSubview(label)
        label.snp.makeConstraints { make in
            make.left.bottom.equalTo(self)
            make.width.equalTo(80)
            make.height.equalTo(25)
        }
        label.backgroundColor = .black
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        
        label.layer.cornerRadius = 8
        label.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        label.layer.masksToBounds = true
        label.tag = REPRESENT_LABEL_TAG_ID
    }
}
