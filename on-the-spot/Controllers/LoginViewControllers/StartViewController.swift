//
//  StartViewController.swift
//  on-the-spot
//
//  Created by William Han on 7/24/18.
//  Copyright © 2018 Will Han. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase


class StartViewController: UIViewController {
    
    
    @IBOutlet weak var LoginButton: UIButton!
    
    @IBOutlet weak var SignUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            if let user = Auth.auth().currentUser {
                print("lel2")
                let rootRef = Database.database().reference()
                let userRef = rootRef.child("users").child(user.uid)
                userRef.observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
                    print(snapshot)
                    if let user = User(snapshot: snapshot) {
                        User.setCurrent(user)
                        print("lel4")
                    }
                })
            }
            self.performSegue(withIdentifier: "alreadyLoggedIn", sender: nil)
        }
    }
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
        
    }
    
//    @IBAction func loginButtonTapped(_ sender: UIButton) {
////        self.performSegue(withIdentifier: "startToLogin", sender: self)
//    }
    
    
}
