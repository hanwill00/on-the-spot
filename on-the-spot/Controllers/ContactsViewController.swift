//
//  ContactsViewController.swift
//  on-the-spot
//
//  Created by William Han on 7/26/18.
//  Copyright © 2018 Will Han. All rights reserved.
//

import Foundation
import UIKit

class ContactsViewController: UIViewController {
    
    var users = [User]()

    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 71
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UserService.usersExcludingCurrentUser { [unowned self] (users) in
            self.users = users
            print(users)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ContactsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsCell") as! ContactTableViewCell
        cell.delegate = self as! ContactTableViewCellDelegate
        configure(cell: cell, atIndexPath: indexPath)
        
        return cell
    }
    
    func configure(cell: ContactTableViewCell, atIndexPath indexPath: IndexPath) {
        let user = users[indexPath.row]
        
        cell.ContactName.text = user.name
        cell.FriendButton.isSelected = user.isFriended
    }
}

extension ContactsViewController: ContactTableViewCellDelegate {
    func didTapFriendButton(_ FriendButton: UIButton, on cell: ContactTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        FriendButton.isUserInteractionEnabled = false
        let friend = users[indexPath.row]
        
        FriendService.setIsFriends(!friend.isFriended, fromCurrentUserTo: friend) { (success) in
            defer {
                FriendButton.isUserInteractionEnabled = true
            }
            
            guard success else { return }
            
            friend.isFriended = !friend.isFriended
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}
