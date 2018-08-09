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

        @IBOutlet weak var HangoutInfoView: UIView!
        @IBOutlet weak var hangoutName: UITextField!
        @IBOutlet weak var maxCap: UITextField!
        @IBOutlet weak var invitedTableView: UITableView!
        @IBOutlet weak var goingTableView: UITableView!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupViews()
            let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
            tap.cancelsTouchesInView = false
            self.view.addGestureRecognizer(tap)
        }
        
        func setupViews() {
            invitedTableView.layer.shadowOffset = CGSize(width: 0, height: 1)
            invitedTableView.layer.shadowOpacity = 0.05
            invitedTableView.layer.shadowColor = UIColor.black.cgColor
            invitedTableView.layer.shadowRadius = 35
            invitedTableView.layer.cornerRadius = 8
            invitedTableView.layer.masksToBounds = true
            
            goingTableView.layer.shadowOffset = CGSize(width: 0, height: 1)
            goingTableView.layer.shadowOpacity = 0.05
            goingTableView.layer.shadowColor = UIColor.black.cgColor
            goingTableView.layer.shadowRadius = 35
            goingTableView.layer.cornerRadius = 8
            goingTableView.layer.masksToBounds = true
            
            HangoutInfoView.layer.shadowOffset = CGSize(width: 0, height: 1)
            HangoutInfoView.layer.shadowOpacity = 0.05
            HangoutInfoView.layer.shadowColor = UIColor.black.cgColor
            HangoutInfoView.layer.shadowRadius = 35
            HangoutInfoView.layer.cornerRadius = 8
            HangoutInfoView.layer.masksToBounds = true
            
            hangoutName.borderStyle = UITextBorderStyle.roundedRect
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            AppUtility.lockOrientation(.all)
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            AppUtility.lockOrientation(.portrait)
            if let hangout = hangout {
                hangoutName.text = hangout.name
                maxCap.text = String(hangout.maxCap)
            } else {
                hangoutName.text = ""
                maxCap.text = ""
            }
            
            FriendService.getFriends { [unowned self] (friends) in
                self.friends = friends
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
                    HangoutService.isInvited(friend, hangout: hangout!) { (isInvited) in
                        cell.selectButton.isSelected = isInvited
                    }
            
            
        }
        
        
        func configureGoing(cell: GoingFriendsTableViewCell, atIndexPath indexPath: IndexPath) {
            let goingFriend = goingFriends[indexPath.row]
            
            cell.friendName.text = goingFriend.name

            
            
        }
        
        @objc func didTapSelectButton(_ selectButton: UIButton) {
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
