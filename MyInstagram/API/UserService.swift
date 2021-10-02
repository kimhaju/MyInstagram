//
//  UserService.swift
//  MyInstagram
//
//  Created by haju Kim on 2021/09/30.
//

import Foundation
import Firebase

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
}
