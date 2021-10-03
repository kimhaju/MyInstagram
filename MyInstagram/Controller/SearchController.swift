//
//  SearchController.swift
//  MyInstagram
//
//  Created by haju Kim on 2021/09/27.
//

import UIKit

private let reuseIdentifier = "UserCell"

class SearchController: UITableViewController  {
    
    // MARK: - 프로퍼티스
    
    private var users = [User]()
    private var filteredUsers = [User]()
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    // MARK: -라이프 사이클
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchController()
        configureTableView()
        searchUsers()
       
    }
    
    // MARK: - API
    
    // 원래 이름 fetchusers 바뀐이름 searchUsers
    func searchUsers() {
        UserService.searchUsers { users in
            self.users = users
            self.tableView.reloadData()
        }
    }
    
    // MARK: -helper
    
    func configureTableView() {
        view.backgroundColor = .white
        
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 64
    }
    
    //->검색한 결과를 보여주는 메서드
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
}

// MARK: -uitableView데이터 소스

extension SearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.viewModel = UserCellViewModel(user: user)
        
        return cell
    }
}
// MARK: - 테이블 뷰 델리게이트

//->유저를 클릭하면 그 유저의 해당 프로필을 연결해서 볼 수 있게 해주는 기능
extension SearchController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //-> 오늘의 에러 10월 2일
        // 자꾸 왜 검색결과를 클릭하면 느와르->느와르 그래도 고흐->느와르
        // 어떤 결과를 검색해도 지금 인덱스 패스순서대로만 나옴. 이유는 여기 있었다.
        // 검색을 하면 그 결과에 따라서 인덱스 번호도 재정렬되어야 하는데 그대로 사용하고 있어서 그런거였음.
        //->그래서 검색결과에 따라서 인덱스 번호가 재정렬할수 있도록 아래 코드 추가
        
        //->오늘 일로 배운거: 검색기능 구현에만 신경쓰는게 아니라 검색한 이후 결과가 어떻게 되는지 꼼꼼하게 테스트 해볼것.
        
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row] //-추가된 코드
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - 탐색

extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filteredUsers = users.filter({
            $0.username.contains(searchText) ||
            $0.fullname.lowercased().contains(searchText)
        })
//        print("users: \(filteredUsers)")

        self.tableView.reloadData()
    }

}
