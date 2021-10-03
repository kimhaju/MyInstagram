//
//  Constants.swift
//  MyInstagram
//
//  Created by haju Kim on 2021/09/30.
//

import Firebase

let Collection_Users = Firestore.firestore().collection("users")
let Collection_Followers = Firestore.firestore().collection("followers")
let Collection_Following = Firestore.firestore().collection("following")
