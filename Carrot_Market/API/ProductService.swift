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
    let isFreeShareItem: Bool?
    let acceptableNegotiation: Bool?
}

struct ProductService {
    static let shared = ProductService()
    

    
    func registerProduct(productInfo info: ProductInformation, completion: @escaping()->Void) {
        

        guard let uid = Auth.auth().currentUser?.uid else {return}
        // Dispatch Group 생성
        let group = DispatchGroup()
        var imageUrls : [String] = []
        
        let semaphore = DispatchSemaphore(value: 1)
        let dispatchQueue = DispatchQueue(label: "imageUploadQueue")
        
        
        let name = info.name
        let price = info.price
        let description = info.description
        let isShare = info.isFreeShareItem
        let isNegotiable = info.acceptableNegotiation
        var representImageUrl:String?
        
        
        for image in info.productImage {
//            group.enter() // Dispatch group에 진입
            
            dispatchQueue.async {
                semaphore.wait()
                
                let filename = NSUUID().uuidString
                let storageRef = STORAGE_PRODUCT_IMAGE.child(filename)
                if let imageData = image.jpegData(compressionQuality: 0.3) {
                    
                    let uploadTask = storageRef.putData(imageData) { meta, err in
                        
                        if let error = err {
                            print("이미지 업로드 에러: \(error.localizedDescription)")
                            //                            group.leave() // Dispatch Group에서 빠져나옴
                            return
                        }
                        storageRef.downloadURL { url, err in
                            if let error = err {
                                print("다운로드 URL 가져오기 에러: \(error.localizedDescription)")
                                return
                            }
                            if let productImageURL = url?.absoluteString {
                                imageUrls.append(productImageURL)
                                
                            }
                            
                            //                            group.leave()
                            semaphore.signal()
                        }
                    }
                    
                    uploadTask.observe(.progress) { snapshot in
                        print("DEBUG: uploading...")
                    }
                }
            }
        }
        
        dispatchQueue.async(flags: .barrier) {
            semaphore.wait()
            
            let values = ["uid": uid, "timestamp": Int(NSDate().timeIntervalSince1970), "name": name, "price": price, "description": description, "productImages": imageUrls, "isShare": isShare ?? false, "isNegotiable": isNegotiable ?? false, "representImageUrl": representImageUrl ?? ""] as [String : Any]
            
            let ref = REF_PRODUCTS.childByAutoId()
            
            ref.updateChildValues(values) { err, ref in
                guard let productId = ref.key else {return}
                
                completion()
            }
            
            semaphore.signal()
        }
        
//        group.notify(queue: .main) {
//
//        }

    }
    
    func fetchProduct(completion: @escaping([Product])->Void) {
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
}
