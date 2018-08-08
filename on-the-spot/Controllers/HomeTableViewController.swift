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
import SnapKit


class HomeTableViewController: UITableViewController {
    
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var createdHangouts = [Hangout]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var invitedHangouts = [Hangout]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
        if let user = Auth.auth().currentUser {
            print(user)
            let rootRef = Database.database().reference()
            let userRef = rootRef.child("users").child(user.uid)
            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
                if let user = User(snapshot: snapshot) {
                    User.setCurrent(user)
                    
                    HangoutService.getUserCreatedHangouts { [unowned self] (hangouts) in
                        self.createdHangouts = hangouts
                        print(self.createdHangouts)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    
                    HangoutService.getUserInvitedHangouts { [unowned self] (hangouts) in
                        self.invitedHangouts = hangouts
                        print(self.invitedHangouts)
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
        case "displayCreatedHangout":
            // 1
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let hangout = createdHangouts[indexPath.row]
            let destination = segue.destination as! DisplayCreatedHangoutViewController
            destination.hangout = hangout
            
        case "displayInvitedHangout":
            // 1
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let hangout = invitedHangouts[indexPath.row]
            let destination = segue.destination as! DisplayInvitedHangoutViewController
            destination.hangout = hangout

            
        case "addNote":
            print("create note bar button item tapped")
            
        default:
            print("unexpected segue identifier")
        }
    }
    
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    @IBAction func unwindToHome(_ segue: UIStoryboardSegue) {
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return createdHangouts.count
        } else if segmentedControl.selectedSegmentIndex == 1 {
            return invitedHangouts.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if segmentedControl.selectedSegmentIndex == 0 {
            if editingStyle == .delete {
                HangoutService.delete(hangout: createdHangouts[indexPath.row])
                createdHangouts.remove(at: indexPath.row)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.didTapOptionsButtonForCell = handleOptionsButtonTap(from:)
        configure(cell: cell, atIndexPath: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentedControl.selectedSegmentIndex == 0 {
            self.performSegue(withIdentifier: "displayCreatedHangout", sender: self)
        } else if segmentedControl.selectedSegmentIndex == 1 {
            self.performSegue(withIdentifier: "displayInvitedHangout", sender: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle
    {
        if segmentedControl.selectedSegmentIndex == 1 {
            return UITableViewCellEditingStyle.none
        } else {
            return UITableViewCellEditingStyle.delete
        }
    }
    
    func configure(cell: HomeTableViewCell, atIndexPath indexPath: IndexPath) {
        if segmentedControl.selectedSegmentIndex == 0 {
            let hangout = createdHangouts[indexPath.row]
            cell.hangoutName.text = hangout.name
            cell.adminName.text = ""
            cell.optionsButton.isEnabled = false
            let btnImage = UIImage(named: "blank")
            cell.optionsButton.setImage(btnImage, for: .normal)
            
        } else if segmentedControl.selectedSegmentIndex == 1 {
            let hangout = invitedHangouts[indexPath.row]
            cell.hangoutName.text = hangout.name
            cell.optionsButton.isEnabled = true
            let btnImage = UIImage(named: "options-button")
            cell.optionsButton.setImage(btnImage, for: .normal)
            UserService.getUser(hangout.admin) { (user) in
                cell.adminName.text = user.name
            }
        }
    }
    
    func handleOptionsButtonTap(from cell: HomeTableViewCell) {
        // 1
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        // 2
        let hangout = invitedHangouts[indexPath.row]
        let admin = hangout.admin
        
        // 3
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 4
        if admin != User.current.uid {
            let flagAction = UIAlertAction(title: "Report as Inappropriate", style: .default) { _ in
                HangoutService.flag(hangout)
                
                let okAlert = UIAlertController(title: nil, message: "The post has been flagged.", preferredStyle: .alert)
                okAlert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(okAlert, animated: true)
            }
            
            alertController.addAction(flagAction)
        }
        
        // 5
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // 6
        present(alertController, animated: true, completion: nil)
    }
}
