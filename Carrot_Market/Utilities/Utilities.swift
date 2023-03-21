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
        tf.setLeftPaddingPoints(20)
        tf.setRightPaddingPoints(20)
        
        return tf
    }
}
