//
//  SignUpViewController.swift
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
typealias FIRUser = FirebaseAuth.User


class SignupViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var SignUpButton: UIButton!
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
    override func viewDidLoad() {
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        Auth.auth().createUser(withEmail: email.text!, password: password.text!){ (user, error) in
            if error == nil {
                
                guard let firUser = Auth.auth().currentUser,
                    let name = self.nameTextField.text,
                    !name.isEmpty else { return }
                
                UserService.create(firUser, name: name) { (user) in
                    guard let user = user else { return }
                }
                let rootRef = Database.database().reference()
                let userRef = rootRef.child("users").child(firUser.uid)
                userRef.observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
                    print(snapshot)
                    if let firUser = User(snapshot: snapshot) {
                        User.setCurrent(firUser)
                        print("lel4")
                    }
                })
                self.performSegue(withIdentifier: "signupToHome", sender: self)
                
            }
            else{
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
}
