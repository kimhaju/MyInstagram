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
    
}
