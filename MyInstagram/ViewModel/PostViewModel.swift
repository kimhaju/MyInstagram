//
//  PostViewModel.swift
//  MyInstagram
//
//  Created by haju Kim on 2021/10/09.
//

import Foundation

struct PostViewModel {
    var post: Post
    
    var imageURL: URL? { return URL(string: post.imageURL) }
    
    var profileImageURL: URL? { return URL(string: post.ownerImageURL) }
    
    var username: String { return post.ownerUsername }
    
    var caption: String { return post.caption }
    
    var likes: Int { return post.likes }
    
    var likesLabelText: String {
        if post.likes != 1 {
            return "\(post.likes) likes"
        }else {
            return "\(post.likes) like"
        }
    }
    
    init(post: Post) { self.post = post }
}