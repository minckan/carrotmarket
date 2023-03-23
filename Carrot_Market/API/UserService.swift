//
//  UserService.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/03/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

struct AuthCredential {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct UserService {
    static let shared = UserService()
    
    
    func fetchUser(uid: String, completion: @escaping(User)->Void) {
        REF_USER.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String:AnyObject] else {return}
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    
    func registerUser(credential: AuthCredential, completion: @escaping(Error?, DatabaseReference) -> Void) {
        let email = credential.email
        let password = credential.password
        let fullname = credential.fullname
        let username = credential.username
        
        guard let imageData = credential.profileImage.jpegData(compressionQuality: 0.3) else {return}
        
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGE.child(filename)
        
        storageRef.putData(imageData) { meta, err in
            storageRef.downloadURL { url, error in
                guard let profileImageUrl = url?.absoluteString else {return}
                
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    if let error = error {
                        print("DEBUG: Error is \(error.localizedDescription)")
                        return
                    }
                    
                    guard let uid = result?.user.uid else {return}
                    
                    let values = ["email": email, "username": username, "fullname": fullname, "profileImageUrl": profileImageUrl]
                    
                    REF_USER.child(uid).updateChildValues(values, withCompletionBlock: completion)
                }
            }
        }
    }
    
    func logUserIn(withEmail email: String, password: String, completion: @escaping(AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
}
