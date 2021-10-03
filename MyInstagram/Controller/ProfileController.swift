//
//  ProfileController.swift
//  MyInstagram
//
//  Created by haju Kim on 2021/09/27.
//

import UIKit

private let cellIdentifier = "ProfileCell"
private let headerIdentifier = "ProfileHeader"

class ProfileController: UICollectionViewController {
    
    // MARK: - 프로퍼티스
    
    private var user: User
    
    // MARK: - 라이프 사이클
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        //->오늘 또 발견한 에러 10.1
        // uiCollectionView 는 프로파일 이미지를 불러오지 못했고
        // -> UICollectionViewFlowLayout()) 로 고치니까 다시 원래대로 보였다.
        // 둘의 차이가 뭔지 확인을 다시 해보고 공부 필수 
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    // MARK: -API
    
//
//    func fetchUser() {
//        UserService.fetchUser { user in
//            self.user = user
//        }
//    }
//
    
    // MARK: -helpers
    
    func configureCollectionView() {
        navigationItem.title = user.username
        collectionView.backgroundColor = .white
        collectionView.register(
            ProfileCell.self,
            forCellWithReuseIdentifier: cellIdentifier
        )
        collectionView.register(
            ProfileHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: headerIdentifier
        )
    }
}

// MARK: -데이터소스

extension ProfileController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProfileCell
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        header.delegate = self
       
            header.viewModel = ProfileHeaderViewModel(user: user)
            return header
    }
}

// MARK: - 델리게이트

extension ProfileController {
    
}

// MARK: - 델리게이트 레이아웃

extension ProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 240)
        
        // 0930 발견한 에러: 여기서 화면 레이아웃 구성이 맞지 않으면 must register a nib or a class for the identifier or connect a prototype cell in a storyboard 이런 에러가 뜬다. 그래서 아이덴티티파이 연결을 확인해봤는데 이상하게 다 연결되어있는데 왜그럴까 했는데 내가 header 구성을 해야 하는데 footer구성을 해서 맞지 않은 것이였다.
        // 에러 로그 잘 읽어보고 에러 생긴 시점부터 하나씩 주석처리 해가면서 확인해보기
    }
}

// MARK: -프로파일 델리게이트

extension ProfileController: ProfileHeaderDelegate {
    func header(_ profileHeader: ProfileHeader, didTapActionsButtonFor user: User) {
        if user.isCurrentUser {
            print("프로파일 수정")
        } else if user.isFollowed {
            print("유저 언팔로우 ")
        } else {
            UserService.follow(uid: user.uid) { error in
                print("팔로우 유저! ui를 업데이트 합니다...")
            }
            
        }
    }
}
