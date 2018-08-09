//
//  LoginViewController.swift
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


class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    
    @IBOutlet weak var SignUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        setupView()
    }
    
    func setupView() {

        LoginButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        LoginButton.layer.shadowOpacity = 0.05
        LoginButton.layer.shadowColor = UIColor.black.cgColor
        LoginButton.layer.shadowRadius = 35
        LoginButton.layer.cornerRadius = 8
        LoginButton.layer.masksToBounds = true
        LoginButton.layer.borderWidth = 0.75
        
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: email.frame.size.height - width, width: email.frame.size.width, height: email.frame.size.height)
        
        border.borderWidth = width
        email.layer.addSublayer(border)
        email.layer.masksToBounds = true
        
        let border2 = CALayer()
        let width2 = CGFloat(1.0)
        border2.borderColor = UIColor.white.cgColor
        border2.frame = CGRect(x: 0, y: email.frame.size.height - width2, width: email.frame.size.width, height: email.frame.size.height)
        
        border2.borderWidth = width2
        password.layer.addSublayer(border2)
        password.layer.masksToBounds = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
    }
    
    
    @IBAction func loginAction(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            if error == nil{
                if let user = Auth.auth().currentUser {
                    let rootRef = Database.database().reference()
                    let userRef = rootRef.child("users").child(user.uid)
                    userRef.observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
                        if let user = User(snapshot: snapshot) {
                            User.setCurrent(user)
                        }
                    })
                }
                self.performSegue(withIdentifier: "loginToHome", sender: self)
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
