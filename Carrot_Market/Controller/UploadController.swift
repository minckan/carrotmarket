//
//  UploadController.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/03/21.
//

import UIKit

class UploadController: UIViewController {
    // MARK: - Properties
    
    private lazy var addImageButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightBorder.cgColor
        button.layer.cornerRadius = 8
        button.setImage(UIImage(named: "image")?.withTintColor(.darkGray, renderingMode: .alwaysOriginal), for: .normal)
        return button
    }()
    
    private lazy var productNameContainer: UIView = {
        let view = Utilities().inputContainerView(title: "Name", textField: productNameTextField)
        return view
    }()
    
    private let productNameTextField: UITextField = {
        let textfield = Utilities().textField(withPlaceHolder: "상품 이름")
        return textfield
    }()
    
    private lazy var productPriceContainer: UIView = {
        let view = Utilities().inputContainerView(title: "Price", textField: productPriceTextField)
        return view
    }()
    
    private let productPriceTextField: UITextField = {
        let textfield = Utilities().textField(withPlaceHolder: "상품 가격")
        return textfield
    }()
    
    private lazy var productDescriptionContainer: UIView = {
        let view = Utilities().inputContainerView(title: "Description", textField: productDescriptionTextField)
        return view
    }()
    
    private let productDescriptionTextField: UITextField = {
        let textfield = Utilities().textField(withPlaceHolder: "상품을 자세히 설명해주세요")
        return textfield
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    @objc func handleUpload() {
        
    }
    
    @objc func handleDismissal() {
        self.dismiss(animated: true)
    }
    
    // MARK: - API
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "상품 등록하기"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back")?.withTintColor(.black, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(handleDismissal))
        let uploadButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(handleUpload))
        uploadButton.tintColor = .carrotOrange500
        navigationItem.rightBarButtonItem = uploadButton
        
        
        view.addSubview(addImageButton)
        addImageButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20, height: 200)
        
        let stack = UIStackView(arrangedSubviews: [productNameContainer, productPriceContainer, productDescriptionContainer])
        stack.axis = .vertical
        stack.spacing = 10
        
        view.addSubview(stack)
        stack.anchor(top: addImageButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 22, paddingLeft: 20, paddingRight: 20)
    }
    

    
    
}
