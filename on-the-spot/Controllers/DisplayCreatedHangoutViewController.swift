    //
    //  DisplayHangoutViewController.swift
    //  on-the-spot
    //
    //  Created by William Han on 7/24/18.
    //  Copyright © 2018 Will Han. All rights reserved.
    //
    
    import Foundation
    import UIKit
    
    class DisplayCreatedHangoutViewController: UIViewController {
        var hangout: Hangout?
        var friends = [User]()
        var invitedFriends = [String: Bool]() {
            didSet {
                invitedTableView.reloadData()
            }
        }
        var goingFriends = [User]() {
            didSet {
                goingTableView.reloadData()
            }
        }

        @IBOutlet weak var hangoutName: UITextField!
        @IBOutlet weak var maxCap: UITextField!
        @IBOutlet weak var invitedTableView: UITableView!
        @IBOutlet weak var goingTableView: UITableView!
        
        override func viewDidLoad() {
            let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
            tap.cancelsTouchesInView = false
            self.view.addGestureRecognizer(tap)
            super.viewDidLoad()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if let hangout = hangout {
                // 2
                hangoutName.text = hangout.name
                maxCap.text = String(hangout.maxCap)
            } else {
                // 3
                hangoutName.text = ""
                maxCap.text = ""
            }
            
            FriendService.getFriends { [unowned self] (friends) in
                self.friends = friends
                print(friends)
                DispatchQueue.main.async {
                    self.invitedTableView.reloadData()
                }
            }
            FriendService.getGoingFriends(self.hangout!) { [unowned self] (goingFriends) in
                self.goingFriends = goingFriends
                DispatchQueue.main.async {
                    self.goingTableView.reloadData()
                }
            }
        }
        
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
    }
    
    extension DisplayCreatedHangoutViewController: UITableViewDataSource, UITableViewDelegate {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            var count:Int?
            
            if tableView == self.invitedTableView {
                count = friends.count
            }
            
            if tableView == self.goingTableView {
                count =  goingFriends.count
            }
            
            return count!
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var friendsTableViewCell:FriendsTableViewCell?
            var goingFriendsTableViewCell:GoingFriendsTableViewCell?
            
            if tableView == self.invitedTableView {
                friendsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell") as! FriendsTableViewCell
                configureInvited(cell: friendsTableViewCell as! FriendsTableViewCell, atIndexPath: indexPath)
                friendsTableViewCell?.selectButton.tag = indexPath.row
                friendsTableViewCell?.selectButton.addTarget(self, action: #selector(didTapSelectButton(_:)), for: .touchUpInside)
                if let friendsTableViewCell = friendsTableViewCell {
                    return friendsTableViewCell as! UITableViewCell
                }
            }
            if tableView == self.goingTableView {
                goingFriendsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "GoingFriendsTableViewCell") as! GoingFriendsTableViewCell
                configureGoing(cell: goingFriendsTableViewCell as! GoingFriendsTableViewCell, atIndexPath: indexPath)
                if let goingFriendsTableViewCell = goingFriendsTableViewCell {
                    return goingFriendsTableViewCell as! UITableViewCell
                }
            }
            return friendsTableViewCell as! UITableViewCell
        }
        
        func configureInvited(cell: FriendsTableViewCell, atIndexPath indexPath: IndexPath) {
            let friend = friends[indexPath.row]
            
            cell.friendName.text = friend.name
            //        HangoutService.isInvited(friend, hangout: hangout!) { (isInvited) in
            //            cell.selectButton.isSelected = isInvited
            //        }
            //
            
        }
        
        
        func configureGoing(cell: GoingFriendsTableViewCell, atIndexPath indexPath: IndexPath) {
            let goingFriend = goingFriends[indexPath.row]
            
            cell.friendName.text = goingFriend.name
            //        HangoutService.isInvited(friend, hangout: hangout!) { (isInvited) in
            //            cell.selectButton.isSelected = isInvited
            //        }
            //
            
        }
        
        @objc func didTapSelectButton(_ selectButton: UIButton) {
            print("hello")
            
            let index = selectButton.tag
            
            let friend = friends[index]
            if invitedFriends[friend.uid] == true {
                invitedFriends[friend.uid] = nil
                selectButton.isSelected = false
            } else {
                invitedFriends[friend.uid] = true
                selectButton.isSelected = true
            }
            
        }
        
        
        
    }
    
    //extension DisplayHangoutViewController: FriendsTableViewCellDelegate {
    //   @objc func didTapSelectButton(_ selectButton: UIButton) {
    //        print("hello")
    //        guard let indexPath = tableView.indexPath(for: cell) else { return }
    //        let friend = friends[indexPath.row]
    //        invitedFriends[friend.uid] = true
    //    }
    //
    //
    //}
