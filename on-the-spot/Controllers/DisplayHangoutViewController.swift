//
//  DisplayHangoutViewController.swift
//  on-the-spot
//
//  Created by William Han on 7/24/18.
//  Copyright © 2018 Will Han. All rights reserved.
//

import Foundation
import UIKit

class DisplayHangoutViewController: UIViewController {
    
    var friends = [User]()
    var invitedFriends = [String: Bool]()
    
    @IBOutlet weak var hangoutName: UITextField!
    
    @IBOutlet weak var maxCap: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        FriendService.getFriends { [unowned self] (friends) in
            self.friends = friends
            print(friends)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func sendButtonTapped(_ sender: UIBarButtonItem) {
        if let inputtedMaxCapText = maxCap.text, let intMaxCap = Int(inputtedMaxCapText) {
            
            let myCompletionCodeToRunWhenCreateIsDone: (Hangout?) -> () = { (hangout) in
                guard let hangout = hangout else {return}

                print(hangout)
            }
            
            HangoutService.create(for: hangoutName.text!, maxCap: intMaxCap, invitedFriends: invitedFriends, completion: myCompletionCodeToRunWhenCreateIsDone)
            
        }
    }
}

extension DisplayHangoutViewController: UITableViewDataSource, UITableViewDelegate {
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
//      cell.selectButton.isSelected = user.isFriended
    }
    
    @objc func didTapSelectButton(_ selectButton: UIButton) {
        print("hello")
        
        let index = selectButton.tag
        
        let friend = friends[index]
        invitedFriends[friend.uid] = true
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
