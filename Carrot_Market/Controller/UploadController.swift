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
    private var productImage : UIImage?
    
    private var imageAmt = 0
    
    private let shareCheckbox = Checkbox(withLabel: "나눔")
    private let negoCheckbox = Checkbox(withLabel: "가격 제안 받기")
    
    private let descriptionPlaceHolderString = "게시글 내용을 작성해주세요.(가품 및 판매 금지 물품은 게시가 제한될 수 있어요.)"
    
    
    private lazy var addImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightBorder.cgColor
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor.rgb(red: 239, green: 246, blue: 250)
        button.setImage(UIImage(named: "icon_camera")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleAddProductImage), for: .touchUpInside)
        button.setTitle("\(imageAmt)/10", for: .normal)
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
    
    
    private lazy var productPriceContainer: UIView = {
        
        let view = UIView()
        
        let label = UILabel()
        label.text = "￦"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        
        let tf = UITextField()
        tf.placeholder = "가격(선택사항)"
        tf.font = UIFont.systemFont(ofSize: 16)

        tf.addTarget(self, action: #selector(handleEditingPrice), for: .editingChanged)
        tf.keyboardType = .numberPad
        
        let leftStack = UIStackView(arrangedSubviews: [label, tf])
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
        
        view.addSubview(addImageButton)
        addImageButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 20,width: 80, height: 80)
        
        view.addSubview(productNameContainer)
        productNameContainer.anchor(top: addImageButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 20, paddingRight: 20)
        
        view.addSubview(productPriceContainer)
        productPriceContainer.anchor(top: productNameContainer.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20, width: view.frame.width, height: 20)
        
        view.addSubview(negoCheckbox)
        negoCheckbox.anchor(top: productPriceContainer.bottomAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 20)
        negoCheckbox.enabled = false
        
        view.addSubview(productDescriptionTextField)
        productDescriptionTextField.anchor(top: negoCheckbox.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 18, paddingRight: 20)

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
        self.productImage = productImage
        
        addImageButton.imageView?.contentMode = .scaleAspectFit
        addImageButton.imageView?.clipsToBounds = true
        addImageButton.layer.masksToBounds = true
        addImageButton.layer.borderWidth = 0
        
        self.addImageButton.setImage(productImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        dismiss(animated: true)
    }
}

extension UploadController : UITextFieldDelegate {
    
}
