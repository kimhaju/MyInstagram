//
//  PostService.swift
//  MyInstagram
//
//  Created by haju Kim on 2021/10/08.
//

import UIKit
import Firebase

struct PostService {
    
    static func uploadPost(caption: String, image: UIImage, completion: @escaping(FirestoreCompletion)) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        imageUploader.uploadImage(image: image) { imageURL in
            let data = ["caption" : caption,
                        "timestamp": Timestamp(date: Date()),
                        "likes" : 0,
                        "imageURL": imageURL,
                        "ownerUid": uid] as [String : Any]
            
            Collection_Posts.addDocument(data: data, completion: completion)
        }
    }
    
}
