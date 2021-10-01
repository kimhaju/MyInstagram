//
//  MainTapController.swift
//  MyInstagram
//
//  Created by haju Kim on 2021/09/27.
//

import UIKit
import Firebase

//->기본적으로 선택할수있는 화면을 제공

class MainTapController: UITabBarController {
    
    // MARK: -라이프 사이클
    private var user: User? {
        didSet {
            guard let user = user else { return }
            configureViewControllers(withUser: user)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        fetchUser()
    }
    
    // MARK: -API
    
    func fetchUser() {
        UserService.fetchUser { user in
            self.user = user
        }
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginController()
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
   

    // MARK: - 홈 탭바
    
    func configureViewControllers(withUser user: User) {
        view.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        
        //의견 보내기
        let feed = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: FeedController(collectionViewLayout: layout))
        
        //검색
        let search = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: SearchController())
        
        // 이미지 선택
        let imageSelector = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"), rootViewController: ImageSelectorController())
        
        // 좋아요 알림
        let notifications = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"), rootViewController: NotificationsController())
        
        // 프로파일
        let profileController = ProfileController(user: user)
//        let profileLayout = UICollectionViewLayout()
        let profile = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: profileController)
        
        viewControllers = [feed, search, imageSelector, notifications, profile]
        
        //->선택할시 바뀌는 색 지정
        tabBar.tintColor = .black
    }
    
    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        return nav
    }
}

// MARK: - 한번에 전달하는 델리게이트 

extension MainTapController: AuthenticationDelegate {
    func authenticationDidComplete() {
        fetchUser()
        self.dismiss(animated: true, completion: nil)
    }
}
