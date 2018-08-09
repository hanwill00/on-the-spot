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
        let ref = Database.database().reference().child("users").child(firUser.uid)
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return
            }
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let user = User(snapshot: snapshot) {
                    User.setCurrent(user)
                }
            })
        }
    }
    
    static func getUser(_ userUID: String, completion: @escaping (User) -> Void) {
        let userRef = Database.database().reference().child("users").child(userUID)
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            if let user = User(snapshot: snapshot) {
                completion(user)
            }
        }
    }
    
    static func usersExcludingCurrentUser(completion: @escaping ([User]) -> Void) {
        let currentUser = User.current
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return completion([]) }
            let users = snapshot.compactMap(User.init).filter { $0.uid != currentUser.uid }
            let dispatchGroup = DispatchGroup()
            users.forEach { (user) in
                dispatchGroup.enter()
                FriendService.isUserFriended(user) { (isFriended) in
                    user.isFriended = isFriended
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.notify(queue: .main, execute: {
                completion(users)
            })
        })
    }
}
