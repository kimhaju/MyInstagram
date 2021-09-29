//
//  AuthService.swift
//  MyInstagram
//
//  Created by haju Kim on 2021/09/29.
//

import UIKit
import Firebase

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    static func registerUser(withCredential credentials: AuthCredentials){
        print("회원가입 유저 연결 확인: \(credentials)")
    }
}
