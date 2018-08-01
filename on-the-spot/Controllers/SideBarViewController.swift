//
//  ProfileViewController.swift
//  on-the-spot
//
//  Created by William Han on 7/25/18.
//  Copyright © 2018 Will Han. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase

class SideBarViewController: UIViewController {
    
    
    @IBOutlet weak var contactsbutton: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var LogoutButton: UIButton!
    @IBOutlet weak var email: UILabel!
    
    override func viewDidLoad() {
        let currentUser = User.current
        name.text = currentUser.name
//        email.text = currentUser.email
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logOutAction(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func contactsButtonTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: "sidebarToContacts", sender: nil)
        
    }
    
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
        
    }
    
}
