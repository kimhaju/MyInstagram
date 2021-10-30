//
//  PostService.swift
//  MyInstagram
//
//  Created by haju Kim on 2021/10/08.
//

import UIKit
import Firebase

struct PostService {
    
    //->포스트 업로더
    static func uploadPost(caption: String, image: UIImage, user: User, completion: @escaping(FirestoreCompletion)) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        imageUploader.uploadImage(image: image) { imageURL in
            let data = ["caption" : caption,
                        "timestamp": Timestamp(date: Date()),
                        "likes" : 0,
                        "imageURL": imageURL,
                        "ownerUid": uid,
                        "ownerImageURL": user.profileImageURL,
                        "ownerUsername": user.username] as [String : Any]
            
            let docRef = Collection_Posts.addDocument(data: data, completion: completion)
            
            self.updateUserFeedAfterPost(postId: docRef.documentID)
        }
    }
    
    static func fetchPosts(completion: @escaping([Post]) -> Void) {
        Collection_Posts.order(by: "timestamp", descending: true).getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            
            let posts = documents.map({ Post(postId: $0.documentID, dictionary: $0.data()) })
            completion(posts)
        }
    }
    
    //->팔로우한 유저 뿐만 아니라 전부  포스트를 보이게 해주는 것
    static func fetchPosts(forUser uid: String, completion: @escaping([Post]) -> Void) {
        let query = Collection_Posts.whereField("ownerUid", isEqualTo: uid)
        query.getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            
            var posts = documents.map({ Post(postId: $0.documentID, dictionary: $0.data())})
            
            posts.sort(by: { $0.timestamp.seconds > $1.timestamp.seconds })
            
//            posts.sort { (post1, post2) -> Bool in
//                return post1.timestamp.seconds > post2.timestamp.seconds
//            }
//
            completion(posts)
        }
    }
    
    //-> 포스트 개인
    static func fetchPost(withPostId postId: String, completion: @escaping(Post) -> Void){
        
        Collection_Posts.document(postId).getDocument { snapshot, _ in
            guard let snapshot = snapshot else { return }
            guard let data = snapshot.data() else { return }
            let post = Post(postId: snapshot.documentID, dictionary: data)
            completion(post)
        }
    }
    
    static func likePost(post: Post, completion: @escaping(FirestoreCompletion)){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Collection_Posts.document(post.postId).updateData(["likes": post.likes + 1])
        
        Collection_Posts.document(post.postId).collection("post-likes").document(uid).setData([:]) { _ in
            
            Collection_Users.document(uid).collection("user-likes").document(post.postId).setData([:], completion: completion)
        }
    }
    
    static func unlikePost(post: Post, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard post.likes > 0 else { return }
        
        Collection_Posts.document(post.postId).updateData(["likes" : post.likes - 1])
        
        Collection_Posts.document(post.postId).collection("post-likes").document(uid).delete { _ in
            Collection_Users.document(uid).collection("user-likes").document(post.postId).delete(completion: completion)
        }
    }
    
    static func checkIfUserLikePost(post: Post, completion: @escaping(Bool) -> Void){
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Collection_Users.document(uid).collection("user-likes").document(post.postId).getDocument { (snapshot, _) in
            guard let didLike = snapshot?.exists else { return }
            completion(didLike)
        }
    }
    
    static func fetchFeedPosts(completion: @escaping([Post]) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var posts = [Post]()
        
        Collection_Users.document(uid).collection("user-feed").getDocuments { snapshot, error in
            snapshot?.documents.forEach({ document in
                fetchPost(withPostId: document.documentID) { post in
                    posts.append(post)
                    
                    //->팔로우한 포스트를 시간 순서대별로 나열
                    posts.sort(by: { $0.timestamp.seconds > $1.timestamp.seconds })
                    
//                    posts.sort { (post1, post2) -> Bool in
//                        return post1.timestamp.seconds > post2.timestamp.seconds
//                    }
                    
                    completion(posts)
                }
            })
        }
    }
    
    //->지금 인스타 창에 다보임. 다보이지 않게 팔로우한 유저만 보일수 있게 설정
    static func updateUserFeedAfterFollowing(user: User, didFollow: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let query = Collection_Posts.whereField("ownerUid", isEqualTo: user.uid)
        
        query.getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            
           let docIds = documents.map({ $0.documentID })
//           print("디버그 현재 팔로우한 아이디: \(docIds)")
            
            docIds.forEach { id in
                if didFollow {
                    Collection_Users.document(uid).collection("user-feed").document(id).setData([:])
                } else {
                    Collection_Users.document(uid).collection("user-feed").document(id).delete()
                }
            }
        }
    }
    //->팔로우 하는 유저만 보이도록 갱신!
    private static func updateUserFeedAfterPost(postId: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Collection_Followers.document(uid).collection("user_followers").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            
           
            documents.forEach { documnet in
                Collection_Users.document(documnet.documentID).collection("user-feed").document(postId).setData([:])
            }
            Collection_Users.document(uid).collection("user-feed").document(postId).setData([:])
        }
        
    }
}
