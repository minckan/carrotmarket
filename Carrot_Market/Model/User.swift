//
//  User.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/03/23.
//

import Foundation
import FirebaseAuth

struct User {
    let fullname: String
    let username: String
    let email: String
    var profileImageUrl: URL?
    let uid: String
    var position: Position?
    var userTemperature = 36.5
    
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    
    init(uid: String, dictionary: [String: AnyObject]) {
        self.uid = uid
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        
        if let profileImageUrlString = dictionary["profileImageUrl"] as? String {
            guard let url = URL(string: profileImageUrlString) else {return}
            self.profileImageUrl = url
        }
        
        if let position = dictionary["position"] as? Position {
            self.position = position
        }
    }
}
