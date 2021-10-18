//
//  PostService.swift
//  MyInstagram
//
//  Created by haju Kim on 2021/10/08.
//

import UIKit
import Firebase

struct PostService {
    
    static func uploadPost(caption: String, image: UIImage, user: User, completion: @escaping(FirestoreCompletion)) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        imageUploader.uploadImage(image: image) { imageURL in
            let data = ["caption" : caption,
                        "timestamp": Timestamp(date: Date()),
                        "likes" : 0,
                        "imageURL": imageURL,
                        "ownerUid": uid,
                        "ownerImageURL": user.profileImageURL,
                        "ownerUsername": user.username] as [String : Any]
            
            Collection_Posts.addDocument(data: data, completion: completion)
        }
    }
    
    static func fetchPosts(completion: @escaping([Post]) -> Void) {
        Collection_Posts.order(by: "timestamp", descending: true).getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            
            let posts = documents.map({ Post(postId: $0.documentID, dictionary: $0.data()) })
            completion(posts)
        }
    }
    
    static func fetchPosts(forUser uid: String, completion: @escaping([Post]) -> Void) {
        let query = Collection_Posts.whereField("ownerUid", isEqualTo: uid)
        
        query.getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            
            var posts = documents.map({ Post(postId: $0.documentID, dictionary: $0.data())})
            
            posts.sort { (post1, post2) -> Bool in
                return post1.timestamp.seconds > post2.timestamp.seconds
            }
            
            completion(posts)
        }
    }
    
    static func likePost(post: Post, completion: @escaping(FirestoreCompletion)){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Collection_Posts.document(post.postId).collection("post-likes").document(uid).setData([:]) { _ in
            
            Collection_Posts.document(post.postId).updateData(["likes": post.likes + 1])
            
            Collection_Users.document(uid).collection("user-likes").document(post.postId).setData([:], completion: completion)
        }
    }
    
    static func unlikePost() {
        
    }
}
