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
    var likes: Int
    let contents : String
    let isShare: Bool
    let isNegotiable: Bool
    var createdAt: Date!
    var updatedAt: Date?
    var category: ProductCategory
    var tradingPosition: Position?
    var views = 0
    var didLike: Bool
    var updateCount = 0
    
    init(user: User, id: String, dictionary: [String: Any]) {
        self.user = user
        self.id = id
        self.name = dictionary["name"] as? String ?? ""
        self.price = dictionary["price"] as? Int ?? 0
        self.likes = dictionary["likes"] as? Int ?? 0
        self.isShare = dictionary["isShare"] as? Bool ?? false
        self.isNegotiable = dictionary["isNegotiable"] as? Bool ?? false
        self.category = dictionary["category"] as? ProductCategory ?? ProductCategory.etc
        self.contents = dictionary["description"] as? String ?? ""
        self.tradingPosition = dictionary["tradingPosition"] as? Position
        self.didLike = dictionary["didLike"] as? Bool ?? false
        
        if let productImageStrings = dictionary["productImages"] as? [String] {
            for urlString in productImageStrings {
                guard let url = URL(string:urlString) else {return}
                productImageUrls.append(url)
            }
        }
        
        if let createdAt = dictionary["createdAt"] as? Double {
            self.createdAt = Date(timeIntervalSince1970: createdAt)
        }
    }
}


enum ProductCategory: String, CaseIterable {
    case digitalDevice = "디지털기기"
    case appliances = "생활가전"
    case funiture = "가구/인테리어"
    case livingKitchen = "생활/주방"
    case babyProduct = "유아동"
    case babyBooks = "유아도서"
    case femaleClothe = "여성의류"
    case femaleStuff = "여성잡화"
    case maleClotheStuff = "남성패션/잡화"
    case bauety = "뷰티/미용"
    case sports = "스포츠/레저"
    case hobby = "취미/게임/음반"
    case books = "도서"
    case tickets = "티켓/교환권"
    case processedFood = "가공식품"
    case animalStuff = "반려동물용품"
    case plants = "식물"
    case etc = "기타 중고물품"
    case buying = "삽니다"
}
