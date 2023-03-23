//
//  Constant.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/03/23.
//

import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

let DB_REF = Database.database().reference()
let REF_USER = DB_REF.child("users")

let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGE = STORAGE_REF.child("profile_image")
let STORAGE_PRODUCT_IMAGE = STORAGE_REF.child("product_image")

let REF_PRODUCTS = DB_REF.child("products")

