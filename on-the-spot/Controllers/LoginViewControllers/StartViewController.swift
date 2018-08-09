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
        setupViews()
        
    }
    
    func setupViews() {
        LoginButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        LoginButton.layer.shadowOpacity = 0.05
        LoginButton.layer.shadowColor = UIColor.black.cgColor
        LoginButton.layer.shadowRadius = 35
        LoginButton.layer.cornerRadius = 8
        LoginButton.layer.masksToBounds = true
        LoginButton.layer.borderWidth = 0.75
        LoginButton.layer.borderColor = UIColor.white.cgColor
        
        SignUpButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        SignUpButton.layer.shadowOpacity = 0.05
        SignUpButton.layer.shadowColor = UIColor.black.cgColor
        SignUpButton.layer.shadowRadius = 35
        SignUpButton.layer.cornerRadius = 8
        SignUpButton.layer.masksToBounds = true
    }
    override open var shouldAutorotate: Bool {
        return false
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
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
        
    }
    
    
}
