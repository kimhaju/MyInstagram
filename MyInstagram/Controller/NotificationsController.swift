//
//  NotificationController.swift
//  MyInstagram
//
//  Created by haju Kim on 2021/09/27.
//

import UIKit

private let reuseIdentifier = "NotificationCell"

class NotificationsController: UITableViewController {
    
    // MARK: -속성 값
    
    private var notifications = [Notification](){
        didSet { tableView.reloadData() }
    }
    
    // MARK: - 라이프 사이클
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchNotifications()
    }
    
    // MARK: - API
    
    func fetchNotifications() {
        NotificationService.fetchNotifications { notifications in
            self.notifications = notifications
            print("디버그 알림: \(notifications)")
        }
    }
    
    // MARK: -헬퍼
    
    func configureTableView() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
    }
}

extension NotificationsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        return cell
    }
}
