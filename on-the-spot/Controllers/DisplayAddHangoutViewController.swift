    //
//  DisplayHangoutViewController.swift
//  on-the-spot
//
//  Created by William Han on 7/24/18.
//  Copyright © 2018 Will Han. All rights reserved.
//

import Foundation
import UIKit

class DisplayAddHangoutViewController: UIViewController {
    var hangout: Hangout?
    var friends = [User]()
    var invitedFriends = [String: Bool]()
    
    @IBOutlet weak var hangoutName: UITextField!
    
    @IBOutlet weak var maxCap: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIBarButtonItem!
    
    @IBOutlet weak var HangoutInfoView: UIView!
    
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
                self.tableView.reloadData()
            }
        }
//                setupViews()
    }
    
//    func setupViews() {
//        HangoutInfoView.layer.shadowOffset = CGSize(width: 0, height: 1)
//        HangoutInfoView.layer.shadowOpacity = 0.05
//        HangoutInfoView.layer.shadowColor = UIColor.black.cgColor
//        HangoutInfoView.layer.shadowRadius = 35
//        HangoutInfoView.layer.cornerRadius = 8
//        HangoutInfoView.layer.masksToBounds = true
//
//        hangoutName.layer.cornerRadius = 5
//        hangoutName.layer.masksToBounds = true
//    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func sendButtonTapped(_ sender: UIBarButtonItem) {
        if let inputtedMaxCapText = maxCap.text, let intMaxCap = Int(inputtedMaxCapText) {
            
            let myCompletionCodeToRunWhenCreateIsDone: (Hangout?) -> () = { (hangout) in
                guard let hangout = hangout else {return}
                self.performSegue(withIdentifier: "send", sender: self)
            }
            
            HangoutService.create(for: hangoutName.text!, maxCap: intMaxCap, invitedFriends: invitedFriends, completion: myCompletionCodeToRunWhenCreateIsDone)
            
        }
    }
}

extension DisplayAddHangoutViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell") as! FriendsTableViewCell
        configure(cell: cell, atIndexPath: indexPath)
        
        cell.selectButton.tag = indexPath.row
        
        cell.selectButton.addTarget(self, action: #selector(didTapSelectButton(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func configure(cell: FriendsTableViewCell, atIndexPath indexPath: IndexPath) {
        let friend = friends[indexPath.row]
        
        cell.friendName.text = friend.name
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
