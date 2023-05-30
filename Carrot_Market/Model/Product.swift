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
    var productImageUrls: [URL] = []
    let name: String
    let price: Int
    let likes: Int
    let isShare: Bool
    let isNegotiable: Bool
    
    init(user: User, id: String, dictionary: [String: AnyObject]) {
        self.user = user
        self.id = id
        self.name = dictionary["name"] as? String ?? ""
        self.price = dictionary["price"] as? Int ?? 0
        self.likes = dictionary["likes"] as? Int ?? 0
        self.isShare = dictionary["isShare"] as? Bool ?? false
        self.isNegotiable = dictionary["isNegotiable"] as? Bool ?? false
        
        if let productImageStrings = dictionary["productImages"] as? [String] {
            for urlString in productImageStrings {
                guard let url = URL(string:urlString) else {return}
                productImageUrls.append(url)
            }

        }
        
    }
}
