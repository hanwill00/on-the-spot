//
//  UserService.swift
//  on-the-spot
//
//  Created by William Han on 7/25/18.
//  Copyright © 2018 Will Han. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase

struct UserService {
    static func create(_ firUser: FIRUser, name: String, completion: @escaping (User?) -> Void) {
        let userAttrs = ["name": name]
        
        // 3
        let ref = Database.database().reference().child("users").child(firUser.uid)
        
        // 4
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return
            }
            
            // 5
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                
                // handle newly created user here
            })
        }
    }
}
