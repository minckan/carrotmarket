//
//  UploadController.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/03/21.
//

import UIKit


class UploadController: UIViewController {
    // MARK: - Properties
    
    private let imagePicker = UIImagePickerController()
//    private var productImage : UIImage?
    
    private var productImages = [UIImageView]()
    
    private let shareCheckbox = Checkbox(type: .share)
    private var negoCheckbox = Checkbox(type: .nego)
    
    private let descriptionPlaceHolderString = "게시글 내용을 작성해주세요.(가품 및 판매 금지 물품은 게시가 제한될 수 있어요.)"
    
    private enum Const {
        static let itemSize = CGSize(width: 90, height: 80)
        static let itemSpacing = 10.0
    }
    
    
    private let imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = Const.itemSize
        layout.minimumLineSpacing = Const.itemSpacing
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = true

        
        return collectionView
    }()

    private lazy var productNameContainer: UITextField = {
        let tf = UITextField()
        tf.placeholder = "제목"
        tf.font = UIFont.systemFont(ofSize: 16)
        return tf
    }()
    
    private lazy var unitLabel = UILabel()
    
    private let productPriceTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "가격(선택사항)"
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.addTarget(self, action: #selector(handleEditingPrice), for: .editingChanged)
        tf.keyboardType = .numberPad
        return tf
    }()
    
    private lazy var productPriceContainer: UIView = {
        
        let view = UIView()
        
        unitLabel.text = "￦"
        unitLabel.font = UIFont.systemFont(ofSize: 16)
        unitLabel.textColor = .lightGray
        
        let tf = productPriceTextField
        

        let leftStack = UIStackView(arrangedSubviews: [unitLabel, tf])
        leftStack.spacing = 10

        let rightStack = UIStackView(arrangedSubviews: [shareCheckbox])
        view.addSubview(leftStack)
        leftStack.snp.makeConstraints { make in
            make.left.top.equalTo(view)
        }
        view.addSubview(rightStack)
        rightStack.snp.makeConstraints { make in
            make.top.right.equalTo(view)
        }

        return view
    }()

    private lazy var productDescriptionTextField: UITextView = {
        let textView = Utilities().textFieldWithMultiline(withPlaceholder: descriptionPlaceHolderString)
        textView.delegate = self
        return textView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureUI()
    }
    
    // MARK: - Selectors
    @objc func handleUpload() {
        print("handle upload!")
        guard let name = productNameContainer.text else {return}
        guard let price = productPriceTextField.text else {return}
        guard let description = productDescriptionTextField.text else {return}
        
        let images = productImages.map { iv in
            return iv.image!
        }

        let product = ProductInformation(name: name, price: Int(price) ?? 0, description: description, productImage: images, category: ProductCategory.etc, isFreeShareItem: shareCheckbox.enabled, acceptableNegotiation: negoCheckbox.enabled, tradingPosition: nil)

        uploadProduct(withProduct: product)
    }
    
    @objc func handleDismissal() {
        self.dismiss(animated: true)
    }
    
    @objc func handleEditingPrice(_ textField: UITextField) {
        negoCheckbox.enabled = textField.hasText
        if textField.hasText {unitLabel.textColor = .black}
        else {unitLabel.textColor = .lightGray}
    }
    
    // MARK: - API
    func uploadProduct(withProduct product: ProductInformation) {
        ProductService.shared.registerProduct(productInfo: product) {_,_ in
            print("Registration of product Success!")
            self.dismiss(animated: true)
        }
    }
    
    // MARK: - Helpers

    func configureNavBar() {
        view.backgroundColor = .white
        navigationItem.title = "내 물건 팔기"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "x")?.withTintColor(.black, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(handleDismissal))
        let uploadButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(handleUpload))
        uploadButton.tintColor = .carrotOrange500
        navigationItem.rightBarButtonItem = uploadButton
    }
    func configureUI() {
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        shareCheckbox.delegate = self
        negoCheckbox.delegate = self
        
        imageCollectionView.dragInteractionEnabled = true
        imageCollectionView.isUserInteractionEnabled = true
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.dragDelegate = self
        imageCollectionView.dropDelegate = self
        
        
        imageCollectionView.register(UpdateImageCell.self, forCellWithReuseIdentifier: UpdateImageCell.identifier)
        imageCollectionView.register(UpdateImageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: UpdateImageHeader.identifier)
        
        view.addSubview(imageCollectionView)
        imageCollectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20, width: view.frame.width, height: 90)
        
        createDivider(superview: view, view: imageCollectionView, paddingTop: 24.0)

        view.addSubview(productNameContainer)
        productNameContainer.anchor(top: imageCollectionView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 20, paddingRight: 20)
        
        createDivider(superview: view, view: productNameContainer, paddingTop: 15.0)
        
        view.addSubview(productPriceContainer)
        productPriceContainer.anchor(top: productNameContainer.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 20, paddingRight: 20, width: view.frame.width, height: 30)

        
        createDivider(superview: view, view: productPriceContainer, paddingTop: 10)
        
        view.addSubview(negoCheckbox)
        negoCheckbox.anchor(top: productPriceContainer.bottomAnchor, left: view.leftAnchor, paddingTop: 30, paddingLeft: 20)
        negoCheckbox.enabled = false
        
        view.addSubview(productDescriptionTextField)
        productDescriptionTextField.anchor(top: negoCheckbox.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 18, paddingRight: 20)

    }
    
    
    func scrollToLast() {
        // 데이터 변경 후 UI 업데이트
        imageCollectionView.reloadData()
//        addImageButton.setTitle("\(productImages.count - 1)/10", for: .normal)
        
        
        // 마지막 IndexPath 계산
        let lastSection = imageCollectionView.numberOfSections - 1
        let lastItem = imageCollectionView.numberOfItems(inSection: lastSection) - 1
        let lastIndexPath = IndexPath(item: lastItem, section: lastSection)

        // 마지막 셀로 스크롤하여 포커스 설정
        imageCollectionView.scrollToItem(at: lastIndexPath, at: .right, animated: true)
    }
    

    
    
}


// MARK: - UITextViewDelegate
extension UploadController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == descriptionPlaceHolderString {
            textView.text = nil
            textView.textColor = .darkGray
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = descriptionPlaceHolderString
            textView.textColor = .lightGray
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension UploadController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let productImage = info[.editedImage] as? UIImage else {return}
        // TODO: 이미지가 중복되면 리턴
        
        if productImages.count < 10 {
            let iv = UIImageView(image: productImage)
            iv.layer.cornerRadius = 8
            iv.layer.masksToBounds = true
            
            self.productImages.append(iv)
            scrollToLast()
        }
        
        dismiss(animated: true)
    }
}

// MARK: - CheckboxDelegate
extension UploadController : CheckboxDelegate {
    func handleCheckbox(withId id: String, enabled: Bool) {
        if id == "SHARE" {
            productPriceTextField.isEnabled = !enabled
            if enabled {
                negoCheckbox.changeContents(type: .event)
                negoCheckbox.enabled = true
                productPriceTextField.text = nil
                unitLabel.textColor = .lightGray
            } else {
                negoCheckbox.changeContents(type: .nego)
                negoCheckbox.enabled = false
            }
        } else if id == "NEGO" {
            print("DEBUG: nego checked \(enabled)")
        } else if id == "SHARE_EVENT" {
            print("DEBUG: event checked \(enabled)")
        }
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
extension UploadController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: UpdateImageCell.identifier, for: indexPath) as! UpdateImageCell
        cell.delegate = self
        cell.view = productImages[indexPath.row]
        cell.index = indexPath.row
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UpdateImageHeader.identifier, for: indexPath) as! UpdateImageHeader
        
        header.delegate = self
        
        header.imageCount = productImages.count
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: Const.itemSize.width + Const.itemSpacing, height: Const.itemSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Const.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

// MARK: - UpdateImageCellDelegate
extension UploadController: UpdateImageCellDelegate {
    func handleDeleteImage(at index: Int) {
        productImages.remove(at: index)
        scrollToLast()
    }
}

// MARK: -  UICollectionViewDragDelegate, UICollectionViewDropDelegate
extension UploadController : UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    

    
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        guard let cell = collectionView.cellForItem(at: indexPath) as? UICollectionViewCell else {
            return nil
        }
        let previewParameters = UIDragPreviewParameters()
        previewParameters.visiblePath = UIBezierPath(rect: cell.bounds)
        if #available(iOS 14.0, *) {
            previewParameters.shadowPath = UIBezierPath(rect: .zero)
        }
        return previewParameters
    }

    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        let imageView = productImages[indexPath.row] as! UIImageView

        let image = imageView.image // UIImageView에서 이미지 추출
        if let image = image {
            let itemProvider = NSItemProvider(object: image)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = image
        
            
            return [dragItem]
            
        } else {
            return [] // 드래그할 이미지가 없는 경우 빈 배열 반환
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {  
        if session.localDragSession != nil {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }

        return UICollectionViewDropProposal(operation: .cancel, intent: .unspecified)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else {return}
        
        coordinator.items.forEach { dropItem in
            guard let sourceIndexPath = dropItem.sourceIndexPath else {return}
            let dragIv = self.productImages[sourceIndexPath.row]
            
            imageCollectionView.performBatchUpdates({
                imageCollectionView.deleteItems(at: [sourceIndexPath])
                imageCollectionView.insertItems(at: [destinationIndexPath])
                
                self.productImages.remove(at: sourceIndexPath.row)
                self.productImages.insert(dragIv, at: destinationIndexPath.row)
                
            }) { _ in
                coordinator.drop(dropItem.dragItem, toItemAt: destinationIndexPath)
            }
        }
        
        // 드롭할때 라벨을 새로 그리기 위해 호출
        for (index, _) in self.productImages.enumerated() {
            let indexPath : IndexPath = [0, index]
            if let cell = collectionView.cellForItem(at: indexPath) as? UpdateImageCell {
                cell.index = index
            }
            
        }
    }
}

extension UploadController: UpdateImageHeaderDelegate {
    func handleImagePicker() {
        present(imagePicker, animated: true)
    }
}
