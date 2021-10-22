//
//  NotificationService.swift
//  MyInstagram
//
//  Created by haju Kim on 2021/10/21.
//

import Firebase

struct NotificationService {
    
    static func uploadNotification(toUid uid: String,
                                   profileImageURL: String,
                                   username: String,
                                   type: NotificationType,
                                   post: Post? = nil) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard uid != currentUid else { return }
        
        let docRef = Collection_Notifications.document(uid).collection("user-notification").document()
        
        var data: [String: Any] = ["timestamp" : Timestamp(date: Date()),
                                   "uid": currentUid,
                                   "type" : type.rawValue,
                                   "id": docRef.documentID,
                                   "userProfileImageURL": profileImageURL,
                                   "username": username
        ]
        
        if let post = post {
            data["postId"] = post.postId
            data["postImageURL"] = post.imageURL
        }
        docRef.setData(data)
    }
    
    static func fetchNotifications(completion: @escaping([Notification]) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Collection_Notifications.document(uid).collection("user-notification").getDocuments { snapshot, _ in
            
            guard let documents = snapshot?.documents else { return }
            
            let notifications = documents.map({Notification(dictionary: $0.data())})
            completion(notifications)
        }
    }
}
