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
}
