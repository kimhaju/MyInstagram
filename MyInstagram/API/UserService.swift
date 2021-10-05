//
//  UserService.swift
//  MyInstagram
//
//  Created by haju Kim on 2021/09/30.
//

import Firebase

typealias FirestoreCompletion = (Error?) -> Void

struct UserService {
    //->프로파일에 쓰이는 패치
    static func fetchUser(completion: @escaping(User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Collection_Users.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else { return }
            
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    //->이름이 비슷한게  별로 좋은 이름도 아니라고 판단해서 이름바꿈
    // 원래 이름 fetchUsers
    static func searchUsers(completion: @escaping([User]) -> Void) {
        Collection_Users.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            
            let users = snapshot.documents.map({ User(dictionary: $0.data())})
            completion(users)
        }
    }
    
    static func follow(uid: String, completion: @escaping(FirestoreCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        Collection_Following.document(currentUid).collection("user_following").document(uid).setData([:]) { error in
            
            Collection_Followers.document(uid).collection("user_followers").document(currentUid).setData([:], completion: completion)
        }
    }
    
    static func unfollow(uid: String, completion: @escaping(FirestoreCompletion)) {
        guard let currnetUid = Auth.auth().currentUser?.uid else { return }
        
        //->10. 5 에러 팔로우 해제가 안되었던 이유 _를 -로 써버림 그래서 파이어 베이스의 컬렉션을 못찾았던 거임 
        Collection_Following.document(currnetUid).collection("user_following").document(uid).delete { error in
            
            Collection_Followers.document(uid).collection("user_followers").document(currnetUid).delete(completion: completion)
        }
    }
    
    static func checkUserIsFollowed(uid: String, completion: @escaping(Bool)->Void){
        guard let currnetUid = Auth.auth().currentUser?.uid else { return }
        
        Collection_Following.document(currnetUid).collection("user_following").document(uid).getDocument { (snapshot, error) in
            
            guard let isFollowed = snapshot?.exists else { return }
            completion(isFollowed)
        }
    }
}
