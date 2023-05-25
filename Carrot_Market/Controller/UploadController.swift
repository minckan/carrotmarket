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
    
    private var productImages = [UIView]()
    
    private let shareCheckbox = Checkbox(withLabel: "나눔", id: "SHARE")
    private let negoCheckbox = Checkbox(withLabel: "가격 제안 받기", id: "NEGO")
    
    private let descriptionPlaceHolderString = "게시글 내용을 작성해주세요.(가품 및 판매 금지 물품은 게시가 제한될 수 있어요.)"
    
    private enum Const {
        static let itemSize = CGSize(width: 90, height: 80)
        static let itemSpacing = 15.0
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
        collectionView.register(UpdateImageCell.self, forCellWithReuseIdentifier: UpdateImageCell.identifier)
        return collectionView
    }()

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
    
    private lazy var productNameContainer: UITextField = {
        let tf = UITextField()
        tf.placeholder = "제목"
        tf.font = UIFont.systemFont(ofSize: 16)
        return tf
    }()
    
    private lazy var unitLabel = UILabel()
    
    private lazy var productPriceContainer: UIView = {
        
        let view = UIView()
        
        unitLabel.text = "￦"
        unitLabel.font = UIFont.systemFont(ofSize: 16)
        unitLabel.textColor = .lightGray
        
        let tf = UITextField()
        tf.placeholder = "가격(선택사항)"
        tf.font = UIFont.systemFont(ofSize: 16)

        tf.addTarget(self, action: #selector(handleEditingPrice), for: .editingChanged)
        tf.keyboardType = .numberPad
        
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
    
    private let productPriceTextField: UITextField = {
        let textfield = Utilities().textField(withPlaceHolder: "상품 가격")
        return textfield
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
        
        
//        guard let productImage = productImage else {return}
//        print("handle upload!")
//        guard let name = ""
//        guard let price = productPriceTextField.text else {return}
//        guard let description = productDescriptionTextField.text else {return}
//
//        let product = ProductInformation(name: name, price: Int(price) ?? 0, description: description, productImage: productImage)
//
//        ProductService.shared.registerProduct(productInfo: product) {
//            print("Registration of product Success!")
//            self.dismiss(animated: true)
//        }
    }
    
    @objc func handleDismissal() {
        self.dismiss(animated: true)
    }
    
    @objc func handleAddProductImage() {
        present(imagePicker, animated: true)
    }
    
    @objc func handleEditingPrice(_ textField: UITextField) {
        negoCheckbox.enabled = textField.hasText
        if textField.hasText {unitLabel.textColor = .black}
        else {unitLabel.textColor = .lightGray}
    }
    
    // MARK: - API
    
    // MARK: - Helpers

    func configureNavBar() {
        view.backgroundColor = .white
        navigationItem.title = "상품 등록하기"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back")?.withTintColor(.black, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(handleDismissal))
        let uploadButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(handleUpload))
        uploadButton.tintColor = .carrotOrange500
        navigationItem.rightBarButtonItem = uploadButton
    }
    func configureUI() {
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        shareCheckbox.delegate = self
        negoCheckbox.delegate = self
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        productImages.append(addImageButton)
        
        
        view.addSubview(imageCollectionView)
        imageCollectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20, width: view.frame.width, height: 90)
        
        view.addSubview(productNameContainer)
        productNameContainer.anchor(top: imageCollectionView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 20, paddingRight: 20)
        
        view.addSubview(productPriceContainer)
        productPriceContainer.anchor(top: productNameContainer.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20, width: view.frame.width, height: 20)
        
        view.addSubview(negoCheckbox)
        negoCheckbox.anchor(top: productPriceContainer.bottomAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 20)
        negoCheckbox.enabled = false
        
        view.addSubview(productDescriptionTextField)
        productDescriptionTextField.anchor(top: negoCheckbox.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 18, paddingRight: 20)

    }
    
    
    func scrollToLast() {
        // 데이터 변경 후 UI 업데이트
        imageCollectionView.reloadData()
        addImageButton.setTitle("\(productImages.count - 1)/10", for: .normal)
        
        // 마지막 IndexPath 계산
        let lastSection = imageCollectionView.numberOfSections - 1
        let lastItem = imageCollectionView.numberOfItems(inSection: lastSection) - 1
        let lastIndexPath = IndexPath(item: lastItem, section: lastSection)

        // 마지막 셀로 스크롤하여 포커스 설정
        imageCollectionView.scrollToItem(at: lastIndexPath, at: .right, animated: true)
    }
    

    
    
}

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

extension UploadController : CheckboxDelegate {
    func handleCheckbox(withId id: String, enabled: Bool) {
        if id == "SHARE" {
            print("DEBUG: share checked \(enabled)")
        } else if id == "NEGO" {
            print("DEBUG: nego checked \(enabled)")
        }
    }
    
}

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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Const.itemSize
    }
}

extension UploadController: UpdateImageCellDelegate {
    func handleDeleteImage(at index: Int) {
        productImages.remove(at: index)
        scrollToLast()
    }
}
