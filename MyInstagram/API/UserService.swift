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
    static func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        print("아이디 전달 \(uid)")
        
        //->10.27일 에러 고침 위의 아이디로 전달하게 되면 무조건 현재 로그인한 유저 아이디로 전달되어 내 프로필 밖에 뜨지 않는다. 그래서 위의 아이디를 지우고 컨트롤러를 통해 아이디를 제공하고 그 프로필을 뜨게 만들어준다! 위의 코드는 필요 없지만 고친 기념으로 냅두자.
        
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
    
    //->유저 프로파일 업데이트 기능을 사용해보자. 문제 생길시 여기를 우선 주석처리
    static func editProfileUser(uid: String, data: [String: Any], completion: @escaping(FirestoreCompletion)){
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        Collection_Users.document(currentUid).collection("users").document(uid).updateData(data) {
            error in
            
            if let error = error {
                print("업데이트 하는데 문제가 생겼습니다. \(error.localizedDescription)")
            } else {
                print("업데이트에 성공했습니다. \(currentUid)")
            }
        }
    }
    
    //->팔로우 체크 여부 확인
    static func checkUserIsFollowed(uid: String, completion: @escaping(Bool)->Void){
        guard let currnetUid = Auth.auth().currentUser?.uid else { return }
        
        Collection_Following.document(currnetUid).collection("user_following").document(uid).getDocument { (snapshot, error) in
            
            guard let isFollowed = snapshot?.exists else { return }
            completion(isFollowed)
        }
    }
    
    //->팔로잉 팔로워 유저수 설정
    static func fetchUserStats(uid: String, completion: @escaping(UserStats) -> Void) {
        Collection_Followers.document(uid).collection("user_followers").getDocuments { (snapshot, _) in
            let followers = snapshot?.documents.count ?? 0
            
            Collection_Following.document(uid).collection("user_following").getDocuments { (snapshot, _) in
                let following = snapshot?.documents.count ?? 0
                
                Collection_Posts.whereField("ownerUid", isEqualTo: uid).getDocuments { (snapshot, _) in
                    let posts = snapshot?.documents.count ?? 0
                    completion(UserStats(followers: followers, following: following, posts: posts))
                }
            }
        }
    }
}
