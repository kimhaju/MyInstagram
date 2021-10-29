//
//  NotificationViewModel.swift
//  MyInstagram
//
//  Created by haju Kim on 2021/10/22.
//

import UIKit

struct NotificationViewModel {
    
    var notification: Notification
    
    init(notification: Notification){
        self.notification = notification
    }
    
    var postImageURL: URL? {return URL(string: notification.postImageURL ?? "")}
    
    var profileImageURL: URL? { return URL(string: notification.userProfileImageURL)}
    
    //->몇 분전에 뜬 알림인지 표시하기 위한 시간표시
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 2
        formatter.unitsStyle = .full
        return formatter.string(from: notification.timestamp.dateValue(), to: Date())
    }
    
    var notificationMessage: NSAttributedString {
        let username = notification.username
        let message = notification.type.notificationMessage
        
        let attributedText = NSMutableAttributedString(string: username, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: message, attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: " \(timestampString ?? "")", attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.lightGray]))
        
        return attributedText
    }
    
    var shouldHidePostImage: Bool { return notification.type == .follow }
    
    var followButtonText: String { return notification.userIsFollowed ? "Following" : "Follow" }
    
    var followButtonBackgroundColor : UIColor {
        return notification.userIsFollowed ? .white: .systemBlue
    }
    
    var followButtonTextColor: UIColor {
        return notification.userIsFollowed ? .black : .white
    }
    
}
