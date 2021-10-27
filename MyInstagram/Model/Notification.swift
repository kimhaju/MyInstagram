//
//  Notification.swift
//  MyInstagram
//
//  Created by haju Kim on 2021/10/21.
//

import Firebase

//->알림 설정에 저장될 데이터 베이스 모델
enum NotificationType: Int {
    case like
    case follow
    case comment
    
    var notificationMessage: String {
        switch self {
        case .like: return "님이 당신의 포스트를 좋아합니다."
        case .follow:
            return "님이 당신을 팔로우 합니다."
        case .comment:
            return "님이 당신의 글에 댓글이 달렸습니다."
        }
    }
}

struct Notification {
    let uid: String
    var postImageURL: String?
    var postId: String?
    let timestamp: Timestamp
    let type: NotificationType
    let id: String
    let userProfileImageURL: String
    let username: String
    var userIsFollowed = false
   
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.postImageURL = dictionary["postImageURL"] as? String ?? ""
        self.postId = dictionary["postId"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.type = NotificationType(rawValue: dictionary["type"] as? Int ?? 0) ?? .like
        self.id = dictionary["id"] as? String ?? ""
        self.userProfileImageURL = dictionary["userProfileImageURL"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
    }
}
