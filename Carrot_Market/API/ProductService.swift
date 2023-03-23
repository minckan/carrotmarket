//
//  ProductService.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/03/23.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth


struct ProductInformation {
    let name : String
    let price : Int
    let description : String
    let productImage : UIImage
}

struct ProductService {
    static let shared = ProductService()
    func registerProduct(productInfo info: ProductInformation, completion: @escaping()->Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let name = info.name
        let price = info.price
        let description = info.description
        
        guard let imageData = info.productImage.jpegData(compressionQuality: 0.3) else {return}
                
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_PRODUCT_IMAGE.child(filename)
        
        storageRef.putData(imageData) { meta, err in
            storageRef.downloadURL { url, err in
                if let error = err {
                    print("Error occured because of \(error.localizedDescription)")
                    return
                }
                guard let productImageURL = url?.absoluteString else {return}
                
                let values = ["uid": uid, "timestamp": Int(NSDate().timeIntervalSince1970), "name": name, "price": price, "description": description, "productImage": productImageURL]
                
                let ref = REF_PRODUCTS.childByAutoId()
                
                ref.updateChildValues(values) { err, ref in
                    guard let productId = ref.key else {return}
                    
                    completion()
                }
                
            }
        }
    }
}
