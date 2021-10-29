//
//  PostViewModel.swift
//  MyInstagram
//
//  Created by haju Kim on 2021/10/09.
//

import UIKit

struct PostViewModel {
    var post: Post
    
    var imageURL: URL? { return URL(string: post.imageURL) }
    
    var profileImageURL: URL? { return URL(string: post.ownerImageURL) }
    
    var username: String { return post.ownerUsername }
    
    var caption: String { return post.caption }
    
    var likes: Int { return post.likes }
    
    var likeButtonTintColor: UIColor {
        return post.didLike ? .red : .black
    }
    
    var likeButtonImage: UIImage? {
        let imageName = post.didLike ? "like_selected" : "like_unselected"
        return UIImage(named: imageName)
    }
    
    var likesLabelText: String {
        if post.likes != 1 {
            return "\(post.likes) likes"
        }else {
            return "\(post.likes) like"
        }
    }
    
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        //->날짜를 얼만큼 표시할건지 알려주는 카운트 수
        formatter.maximumUnitCount = 2
        formatter.unitsStyle = .full
//            .abbreviated 제일 불친절하고 제일 엉망
//            .full  ->그나마 제일 깔끔하게 표시
//            .spellOut -> 좀 불친절함

        return formatter.string(from: post.timestamp.dateValue(), to: Date())
    }
    
    init(post: Post) { self.post = post }
}
