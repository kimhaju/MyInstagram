//
//  Post.swift
//  MyInstagram
//
//  Created by haju Kim on 2021/10/09.
//

import Firebase

struct Post {
    let caption: String
    let likes: Int
    let imageURL: String
    let ownerUid: String
    let timestamp: Timestamp
    let postId: String
    let ownerImageURL: String
    let ownerUsername: String
    
    init(postId: String, dictionary: [String: Any]) {
        self.postId = postId
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.imageURL = dictionary["imageURL"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.ownerUid = dictionary["ownerUid"] as? String ?? ""
        self.ownerImageURL = dictionary["ownerImageURL"] as? String ?? ""
        self.ownerUsername = dictionary["ownerUsername"] as? String ?? ""
    
    }
}
