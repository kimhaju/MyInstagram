//
//  CommentService.swift
//  MyInstagram
//
//  Created by haju Kim on 2021/10/12.
//

import Firebase

struct CommentService {
    
    static func uploadComment(comment: String, postID: String, user: User, completion: @escaping(FirestoreCompletion)) {
        
        
        let data : [String: Any] = ["uid": user.uid,
                                    "comment": comment,
                                    "timestamp" : Timestamp(date: Date()),
                                    "username": user.username,
                                    "profileImageURL": user.profileImageURL]
        Collection_Posts.document(postID).collection("comments").addDocument(data: data, completion: completion)
    }
    
    static func fetchComments(forPost postID: String, completion: @escaping([Comment]) -> Void) {
        
        var comments = [Comment]()
        
        let query = Collection_Posts.document(postID).collection("comments").order(by: "timestamp", descending: true)
        
        query.addSnapshotListener { (snapshot, error) in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let data = change.document.data()
                    let comment = Comment(dictionary: data)
                    comments.append(comment)
                }
            })
            
            completion(comments)
        }
    }
}
