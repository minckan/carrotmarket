//
//  AttributedStrings.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/03/21.
//

import UIKit

class AttributedStrings {
    func LeftImageButton(withImage image: UIImage) -> UIButton {
        let button = UIButton()

        button.setImage(image, for: .normal)
                
//        let title = NSAttributedString(string: String(count), attributes: [.font: UIFont.systemFont(ofSize: 14)])
//
        // 텍스트 설정

//        button.setAttributedTitle(title, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        

        // 텍스트와 이미지 간격 설정
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

        // 버튼의 크기와 위치 설정
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        
        return button
    }
    
    func attributitedButton(_ firstpart: String, _ secondpart: String) -> UIButton {
        let button = UIButton(type: .system)
        let attributedString = NSMutableAttributedString(string: firstpart, attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.carrotOrange500])
        
        attributedString.append(NSAttributedString(string: " \(secondpart)", attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.carrotOrange500]))
        
        button.setAttributedTitle(attributedString, for: .normal)
        
        return button
        
    }
}

