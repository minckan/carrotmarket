//
//  Checkbox.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/05/23.
//

import UIKit

protocol CheckboxDelegate: AnyObject {

}

class Checkbox : UIView {
    // MARK: - Properties
    weak var delegate : CheckboxDelegate?
    
    private var isChecked = false
    var enabled : Bool? = nil {
        didSet {
            toggleDisable()
        }
    }
    
    private let checkbox : UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightBorder.cgColor
        button.backgroundColor = .white
        button.setImage(UIImage(named: "check")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), for: .normal)
        return button
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    // MARK: - Lifecycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        configureUI(labelText: nil)
    }
    
    convenience init(withLabel labelText : String) {
        self.init(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        commonInit()
        configureUI(labelText: labelText)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func commonInit() {
//        print("DEBUG: common init is called. \(checkbox)")
        checkbox.addTarget(self, action: #selector(handleCheckbox), for: .touchUpInside)
    }
    func configureUI(labelText: String?) {
        addSubview(checkbox)
        checkbox.snp.makeConstraints { make in
            make.left.equalTo(self)
            make.top.equalTo(self)
        }
        
        if let labelText = labelText {
            label.text = labelText
            addSubview(label)
            label.snp.makeConstraints { make in
                make.left.equalTo(checkbox.snp.right).offset(10)
                make.centerY.equalTo(checkbox)
            }
            label.sizeToFit()
            self.snp.makeConstraints { make in
                make.width.equalTo(label.frame.width + 30)
                make.height.equalTo(20)
            }
        }
    }
    
    func toggleDisable() {
        print("DEBUG: toggle disbale called. enabled is \(enabled)")
        guard let enabled = enabled else {return}
        if enabled == false {
            checkbox.backgroundColor = .lightGray
            checkbox.tintColor = .darkGray
            label.textColor = .systemGray3
        } else {
            checkbox.backgroundColor = .white
            checkbox.tintColor = .white
            label.textColor = .black
        }
        
        checkbox.isEnabled = enabled
    }
    
    // MARK: - Selectors
    @objc func handleCheckbox() {
        print("DEBUG: \(isChecked)")
        if !isChecked {
            checkbox.backgroundColor = .carrotOrange500
        } else {
            checkbox.backgroundColor = .white
        }
        
        isChecked.toggle()
    }
}
