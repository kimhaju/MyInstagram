//
//  NotificationViewModel.swift
//  MyInstagram
//
//  Created by haju Kim on 2021/10/22.
//

import UIKit

struct NotificationViewModel {
    
    private let notification: Notification
    
    init(notification: Notification){
        self.notification = notification
    }
    
    var postImageURL: URL? {return URL(string: notification.postImageURL ?? "")}
    
    var profileImageURL: URL? { return URL(string: notification.userProfileImageURL)}
    
    var notificationMessage: NSAttributedString {
        let username = notification.username
        let message = notification.type.notificationMessage
        
        let attributedText = NSMutableAttributedString(string: username, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: message, attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: " 2m", attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.lightGray]))
        
        return attributedText
    }
    
}
