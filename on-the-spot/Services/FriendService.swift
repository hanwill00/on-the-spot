//
//  FollowService.swift
//  on-the-spot
//
//  Created by William Han on 7/25/18.
//  Copyright © 2018 Will Han. All rights reserved.
//

import Foundation
import FirebaseDatabase
import SwiftyJSON

struct FriendService {
    private static func friendUser(_ user: User, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
        let currentUID = User.current.uid
        let friendData = ["friends/\(user.uid)/\(currentUID)" : true,
                          "friends/\(currentUID)/\(user.uid)" : true]
        
        

        // 2
        let ref = Database.database().reference()
        ref.updateChildValues(friendData) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }

            // 3
            success(error == nil)
        }
    }
    
    private static func unfriendUser(_ user: User, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
        let currentUID = User.current.uid
        let friendData = ["friends/\(user.uid)/\(currentUID)" : NSNull(),
                          "friends/\(currentUID)/\(user.uid)" : NSNull()]
        
        // 2
        let ref = Database.database().reference()
        ref.updateChildValues(friendData) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            
            // 3
            success(error == nil)
        }
    }
    
    static func isUserFriended(_ user: User, byCurrentUserWithCompletion completion: @escaping (Bool) -> Void) {
        let currentUID = User.current.uid
        let ref = Database.database().reference().child("friends").child(user.uid)
        
        ref.queryEqual(toValue: nil, childKey: currentUID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? [String : Bool] {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    static func setIsFriends(_ isFriends: Bool, fromCurrentUserTo friend: User, success: @escaping (Bool) -> Void) {
        if isFriends {
            friendUser(friend, forCurrentUserWithSuccess: success)
        } else {
            unfriendUser(friend, forCurrentUserWithSuccess: success)
        }
    }
    
    static func getFriends(completion: @escaping ([User]) -> Void) {
        let currentUser = User.current
        let ref = Database.database().reference().child("friends").child(currentUser.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value
            let json = JSON(value)
            var ids = [String]()
            for (key, subJson) in json {
                print(key)
                ids.append(key)
            }
            let dg = DispatchGroup()
            var friends = [User]()
            ids.forEach({ (id) in
                dg.enter()
                let ref = Database.database().reference().child("users").child(id)
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    let user = User(snapshot: snapshot)
                    friends.append(user!)
                     dg.leave()
                })
                dg.notify(queue: .main, execute: {
                    completion(friends)
                })
            })
           
          
            
            
//            guard let snapshots = snapshot.children.allObjects as? [DataSnapshot]
//                else { return completion([]) }
//            let newSnapshots = snapshots.map { (snapshot: DataSnapshot) in
//                var userUID = snapshot.key
//                let ref = Database.database().reference().child("users").child("userUID")
//                ref.observeSingleEvent(of: .value, with: { (newSnapshot) in
//                    return newSnapshot
//                })
//            }
//          //  let friends = newSnapshots.compactMap(User.init)
            //print(friends)
            //completion(friends)
        })
    }
}
