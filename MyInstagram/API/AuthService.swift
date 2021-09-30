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

//->파이어 스토어에 저장할 코드 생성 
struct AuthService {
    static func registerUser(withCredential credentials: AuthCredentials, completion: @escaping(Error?) -> Void){
        
        imageUploader.uploadImage(image: credentials.profileImage) { imageURL in
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
                
                if let error = error {
                    print("회원가입에 실패했습니다. \(error.localizedDescription)")
                    return
                }
                guard let uid = result?.user.uid else {return}
                
                let data: [String: Any] = ["email": credentials.email,
                                           "fullname": credentials.fullname,
                                           "profileImageURL" : imageURL,
                                           "uid": uid,
                                           "username" : credentials.username
                ]
                Firestore.firestore().collection("users").document(uid).setData(data, completion: completion)
            }
        }
       
    }
}
