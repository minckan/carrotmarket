//
//  Product.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/03/21.
//

import Foundation

struct Product {
    let user: User
    let id: String
    var productImagUrl: URL?
    let name: String
    let price: Int
    let likes: Int
    
    init(user: User, id: String, dictionary: [String: AnyObject]) {
        self.user = user
        self.id = id
        self.name = dictionary["name"] as? String ?? ""
        self.price = dictionary["price"] as? Int ?? 0
        self.likes = dictionary["likes"] as? Int ?? 0
        
        if let productImageString = dictionary["productImageUrl"] as? String {
            guard let url = URL(string: productImageString) else {return}
            
            self.productImagUrl = url
        }
        
    }
}
