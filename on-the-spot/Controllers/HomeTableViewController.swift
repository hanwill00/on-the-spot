//
//  HomeViewController.swift
//  on-the-spot
//
//  Created by William Han on 7/24/18.
//  Copyright © 2018 Will Han. All rights reserved.
//

import Foundation
import UIKit
import UIKit
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase


class HomeTableViewController: UITableViewController {
    var hangouts = [Hangout]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        if let user = Auth.auth().currentUser {
            print(user)
            let rootRef = Database.database().reference()
            let userRef = rootRef.child("users").child(user.uid)
            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
                if let user = User(snapshot: snapshot) {
                    User.setCurrent(user)
                    
                    HangoutService.getUserCreatedHangouts { [unowned self] (hangouts) in
                        self.hangouts = hangouts
                        print(hangouts)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            })
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "displayHangout":
            // 1
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            // 2
            let hangout = hangouts[indexPath.row]
            // 3
            let destination = segue.destination as! DisplayHangoutViewController
            // 4
            destination.hangout = hangout
            
        case "addNote":
            print("create note bar button item tapped")
            
        default:
            print("unexpected segue identifier")
        }
    }
    
    @IBAction func unwindToHome(_ segue: UIStoryboardSegue) {
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hangouts.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            HangoutService.delete(hangout: hangouts[indexPath.row])
            hangouts.remove(at: indexPath.row)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        configure(cell: cell, atIndexPath: indexPath)

        
        return cell
    }
    
    
    
    func configure(cell: HomeTableViewCell, atIndexPath indexPath: IndexPath) {
        let hangout = hangouts[indexPath.row]
        cell.hangoutName.text = hangout.name
    }
    
}
