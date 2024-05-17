//
//  UserListViewController.swift
//  UsersForm
//
//  Created by Ramina Tastanova on 15.05.2024.
//

import UIKit
import SnapKit

enum ListConstants {
    static let cellIdentifier = "UserCell"
}

class UserListViewController: UIViewController {
    
    // MARK: - Properties
    
    private var users: [UserEntity] = []
    private let model: UserDataFormModel = UserDataFormModelImpl()
    
    // MARK: - UI Elements
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ListConstants.cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        fetchUsers()
    }
    
    // MARK: - Helper Methods
    
    private func setupUI() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewUser))
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func fetchUsers() {
        users = model.fetchUsers()
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc private func addNewUser() {
        let formViewController = UserDataFormViewController(user: nil)
        navigationController?.pushViewController(formViewController, animated: true)
    }
    
    // MARK: - Navigation
    
    private func openFormView(with user: UserEntity?) {
        let formViewController = UserDataFormViewController(user: user)
        formViewController.user = user
        navigationController?.pushViewController(formViewController, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension UserListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListConstants.cellIdentifier, for: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = users[indexPath.row]
        openFormView(with: selectedUser)
    }
}
