//
//  NotificationService.swift
//  MyInstagram
//
//  Created by haju Kim on 2021/10/21.
//

import Firebase

struct NotificationService {
    
    static func uploadNotification(toUid uid: String, type: NotificationType, post: Post? = nil) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard uid != currentUid else { return }
        
        let docRef = Collection_Notifications.document(uid).collection("user-notification").document()
        
        var data: [String: Any] = ["timestamp" : Timestamp(date: Date()),
                                   "uid": currentUid,
                                   "type" : type.rawValue,
                                   "id": docRef.documentID
        ]
        
        if let post = post {
            data["postId"] = post.postId
            data["postImageURL"] = post.imageURL
        }
        docRef.setData(data)
    }
    
    static func fetchNotifications() {
        
    }
}
