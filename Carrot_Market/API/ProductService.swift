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
    let productImage : [UIImage]
    let category: ProductCategory
    let isFreeShareItem: Bool?
    let acceptableNegotiation: Bool?
    let tradingPosition : Position?
}

struct ProductService {
    static let shared = ProductService()
    

    
    func registerProduct(productInfo info: ProductInformation, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        var imageUrls : [String] = []
        
        let semaphore = DispatchSemaphore(value: 1)
        let dispatchQueue = DispatchQueue(label: "imageUploadQueue")
        
        
        let name = info.name
        let price = info.price
        let description = info.description
        let isShare = info.isFreeShareItem
        let isNegotiable = info.acceptableNegotiation
        let category = info.category
        
        let tradingPosition = info.tradingPosition
        
        for image in info.productImage {
            dispatchQueue.async {
                semaphore.wait()
                
                let filename = NSUUID().uuidString
                let storageRef = STORAGE_PRODUCT_IMAGE.child(filename)
                if let imageData = image.jpegData(compressionQuality: 0.3) {
                    
                    let uploadTask = storageRef.putData(imageData) { meta, err in
                        
                        if let error = err {
                            printDebug("이미지 업로드 에러: \(error.localizedDescription)")
                            return
                        }
                        storageRef.downloadURL { url, err in
                            if let error = err {
                                printDebug("다운로드 URL 가져오기 에러: \(error.localizedDescription)")
                                return
                            }
                            if let productImageURL = url?.absoluteString {
                                imageUrls.append(productImageURL)
                                
                            }
                            semaphore.signal()
                        }
                    }
                    
                    uploadTask.observe(.progress) { snapshot in
                        printDebug("uploading...")
                    }
                }
            }
        }
        
        dispatchQueue.async(flags: .barrier) {
            semaphore.wait()
            
            let values = ["uid": uid, "createAt": Int(NSDate().timeIntervalSince1970), "name": name, "price": price, "description": description, "productImages": imageUrls, "isShare": isShare ?? false, "isNegotiable": isNegotiable ?? false, "category" : category.rawValue, "latitude": tradingPosition?.lat ?? 0.0, "longitude": tradingPosition?.lon ?? 0.0] as [String : Any]
            
            
            REF_PRODUCTS.childByAutoId().updateChildValues(values) { err, ref in
                guard let productId = ref.key else {return}
                REF_USER_PRODUCTS.child(uid).updateChildValues([productId: 1], withCompletionBlock: completion)
            }
            
            semaphore.signal()
        }
        
    }
    
    func fetchProducts(completion: @escaping([Product])->Void) {
        var products = [Product]()
        
        REF_PRODUCTS.observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
            guard let uid = dictionary["uid"] as? String else {return}
            let productId = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                let product = Product(user: user, id: productId, dictionary: dictionary)
                products.append(product)
                completion(products)
            }
        }
    }
    
    func fetchProduct(withProductId productId: String, completion: @escaping(Product)->Void) {
        REF_PRODUCTS.child(productId).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            guard let uid = dictionary["uid"] as? String else {return}
            
            UserService.shared.fetchUser(uid: uid) { user in
                let product = Product(user: user, id: productId, dictionary: dictionary)
                completion(product)
            }
        }
    }
    
    func fetchProduct(forUser user: User, completion: @escaping([Product])->Void) {
        var products = [Product]()
        REF_USER_PRODUCTS.child(user.uid).observe(.childAdded) { snapshot in
            let productId = snapshot.key
            self.fetchProduct(withProductId: productId) { product in
                products.append(product)
                completion(products)
            }
        }
    }
    
    func likeProduct(forProduct product: Product, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let likes = product.didLike ? product.likes - 1 : product.likes + 1
        
        REF_PRODUCTS.child(product.id).child("likes").setValue(likes)
        
        if product.didLike {
            REF_USER_LIKES.child(uid).child(product.id).removeValue(completionBlock: completion)
        } else {
            REF_USER_LIKES.child(uid).updateChildValues([product.id: 1], withCompletionBlock: completion)
        }
    }
    
    func checkDidLiked(forProduct product: Product, completion: @escaping(Bool)->Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        REF_USER_LIKES.child(uid).child(product.id).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
    
}
