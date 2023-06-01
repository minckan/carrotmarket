//
//  ProductViewModel.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/03/23.
//

import UIKit

struct ProductViewModel {
    let product : Product
    
    var priceText : String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formattedPrice = formatter.string(from: NSNumber(value: product.price)) ?? ""
        
       return formattedPrice + "원"
    }
    
    var relatedProductLabel: String {
        return product.user.username + "님의 판매상품"
    }
    
    var updatedLabel : String {
        let latestUpdatedPeriod = 3
        if let updatedAt = product.updatedAt {
            
        }
        return "끝올 \(latestUpdatedPeriod)일전"
    }
    
    var likesAndViews : String {
        return "관심 \(product.likes)﹒조회 \(product.views)"
    }
    
    var temperatureValue: Float {
        return Float(product.user.userTemperature / 100)
    }
    
    var negotiableValue: NSAttributedString {
        if product.isNegotiable {
            return NSMutableAttributedString(string: "가격 제안 불가", attributes: [.font: UIFont.boldSystemFont(ofSize: 12), .foregroundColor: UIColor.lightGray])
        } else {
            return NSMutableAttributedString(string: "가격 제안 가능", attributes: [.font: UIFont.boldSystemFont(ofSize: 12), .foregroundColor: UIColor.carrotOrange500])
        }
    }
    
    var likeImage : UIImage {
        var image = UIImage()
        
        if product.didLike {
            image = UIImage(named: "like_filled")?.withTintColor(.red, renderingMode: .alwaysOriginal) ?? UIImage()
        } else {
            image = UIImage(named: "like_unselected") ?? UIImage()
        }
        
        return image
    }
}
