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
                if let user = User(snapshot: snapshot) {
                    User.setCurrent(user)
                    print(User.current)
                }
                
                // handle newly created user here
            })
        }
    }
    
    static func usersExcludingCurrentUser(completion: @escaping ([User]) -> Void) {
        let currentUser = User.current
        // 1
        let ref = Database.database().reference().child("users")
        
        // 2
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return completion([]) }
            print(snapshot)
            let users = snapshot.compactMap(User.init).filter { $0.uid != currentUser.uid }
            // 4
            let dispatchGroup = DispatchGroup()
            users.forEach { (user) in
                dispatchGroup.enter()
                
                // 5
                FriendService.isUserFriended(user) { (isFriended) in
                    user.isFriended = isFriended
                    dispatchGroup.leave()
                }
            }
            
            // 6
            dispatchGroup.notify(queue: .main, execute: {
                completion(users)
            })
        })
    }
}
