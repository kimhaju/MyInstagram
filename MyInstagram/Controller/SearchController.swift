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
    
    
    // MARK: -라이프 사이클
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
}

// MARK: -uitableView데이터 소스

extension SearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        cell.user = users[indexPath.row]
        return cell
    }
}
