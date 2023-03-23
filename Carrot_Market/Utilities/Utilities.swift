//
//  Utilities.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/03/21.
//

import UIKit

class Utilities {
    func inputContainerView(title: String, textField: UITextField) ->UIView {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let label = UILabel()
        label.text = title
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .darkGray
       
        let stack = UIStackView(arrangedSubviews: [label, textField])
        stack.axis = .vertical
        stack.spacing = 20
        
        
        view.addSubview(label)
        label.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 10)
        view.addSubview(textField)
        textField.anchor(top: label.bottomAnchor, left: view.leftAnchor,right: view.rightAnchor, paddingTop: 5)
        
        return view
    }
    
    func inputContainerViewWithMultiline(title: String, textField: UITextView) -> UIView {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let label = UILabel()
        label.text = title
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .darkGray
       
        let stack = UIStackView(arrangedSubviews: [label, textField])
        stack.axis = .vertical
        stack.spacing = 20
        
        
        view.addSubview(label)
        label.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 10)
        view.addSubview(textField)
        textField.anchor(top: label.bottomAnchor, left: view.leftAnchor,right: view.rightAnchor, paddingTop: 5)
        
        return view
    }
    
    func inputContainerViewWithImage(withImage image: UIImage, textField: UITextField) -> UIView {
        let view = UIView()
        let iv = UIImageView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        iv.image = image
        view.addSubview(iv)
        iv.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 8, paddingBottom: 8)
        iv.setDimensions(width: 24, height: 24)
        
        view.addSubview(textField)
        textField.anchor(left: iv.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, paddingBottom: 8)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        view.addSubview(dividerView)
        dividerView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, height: 0.75)
        
        return view
    }
    
    func textField(withPlaceHolder placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.textColor = .darkGray
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 6
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.lightBorder.cgColor
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tf.setLeftPaddingPoints(6)
        tf.setRightPaddingPoints(6)
        
        return tf
    }
    
    func textFieldWithMultiline(withPlaceholder placeholder: String) -> UITextView {
        let tv = UITextView()
        tv.text = placeholder
        tv.textColor = .lightGray
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.layer.masksToBounds = true
        tv.layer.cornerRadius = 6
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.lightBorder.cgColor
        tv.heightAnchor.constraint(equalToConstant: 130).isActive = true
        tv.isEditable = true
        tv.setPadding(top: 12, left: 6, bottom: 12, right: 6)
        return tv
    }
}
