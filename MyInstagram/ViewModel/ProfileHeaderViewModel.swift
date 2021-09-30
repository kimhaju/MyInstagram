//
//  ProfileHeaderViewModel.swift
//  MyInstagram
//
//  Created by haju Kim on 2021/09/30.
//

import Foundation

struct ProfileHeaderViewModel {
    let user: User
    
    var fullname: String {
        return user.fullname
    }
    
    var profileImageURL: URL? {
        return URL(string: user.profileImageURL)
    }
    
    init(user: User){
        self.user = user
    }
}
