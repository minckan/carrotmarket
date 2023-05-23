//
//  UploadController.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/03/21.
//

import UIKit

private let descriptionPlaceHolderString = "상품을 자세히 설명해주세요"

class UploadController: UIViewController {
    // MARK: - Properties
    
    private let imagePicker = UIImagePickerController()
    private var productImage : UIImage?
    
    private var imageAmt = 0
    
    
    private lazy var addImageButton: UIButton = {
        let button = UIButton()
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
        
        let leftStack = UIStackView(arrangedSubviews: [label, tf])
        
        let cb = Checkbox()
        let rightStack = UIStackView(arrangedSubviews: [cb])
        
        view.addSubview(leftStack)
        view.addSubview(cb)
        
        return view
    }()
    
    private let productPriceTextField: UITextField = {
        let textfield = Utilities().textField(withPlaceHolder: "상품 가격")
        return textfield
    }()
    
    private lazy var productDescriptionContainer: UIView = {
        let view = Utilities().inputContainerViewWithMultiline(title: "Description", textField: productDescriptionTextField)
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
    
    // MARK: - API
    
    // MARK: - Helpers
    func configureUI() {
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        view.backgroundColor = .white
        navigationItem.title = "상품 등록하기"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back")?.withTintColor(.black, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(handleDismissal))
        let uploadButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(handleUpload))
        uploadButton.tintColor = .carrotOrange500
        navigationItem.rightBarButtonItem = uploadButton
        
        
        view.addSubview(addImageButton)
        addImageButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 20,width: 80, height: 80)
        
        
        
        let stack = UIStackView(arrangedSubviews: [productNameContainer, productPriceContainer, productDescriptionContainer])
        stack.axis = .vertical
        stack.spacing = 10
        productDescriptionContainer.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        stack.anchor(top: addImageButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 22, paddingLeft: 20, paddingRight: 20)
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
