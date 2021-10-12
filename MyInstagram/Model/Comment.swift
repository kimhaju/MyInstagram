//
//  Comments.swift
//  MyInstagram
//
//  Created by haju Kim on 2021/10/12.
//

import Firebase

struct Comment {
    let uid: String
    let username: String
    let profileImageURL: String
    let timestamp: Timestamp
    let commentText: String
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.commentText = dictionary["comment"] as? String ?? ""
        
    }
    
}
