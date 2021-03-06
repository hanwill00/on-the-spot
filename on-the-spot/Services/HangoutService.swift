//
//  HangoutService.swift
//  on-the-spot
//
//  Created by William Han on 7/29/18.
//  Copyright © 2018 Will Han. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseUI
import FirebaseStorage
import FirebaseDatabase
import SwiftyJSON

struct HangoutService {
    static func create(for name: String, maxCap: Int, invitedFriends: [String: Bool], completion: @escaping (Hangout?) -> ()) {
        let currentUser = User.current
        let hangout = Hangout(name: name, maxCap: maxCap)
        let dict = hangout.dictValue
        //currenUserHangoutRef = reference to hangout id under hangouts under current user ID
       
        
        let hangoutRef = Database.database().reference().child("Hangouts").childByAutoId()
        

        // Create reference to hangout in hangout tree
        hangoutRef.updateChildValues(dict) { (error, reference) in
            if let error = error {
                assertionFailure("Error:\(error.localizedDescription)")
            }
            
            //create reference to hangout in currentUser
            let currentUserHangoutRef = Database.database().reference().child("users").child(currentUser.uid).child("hangouts").child(reference.key)
            let createdAndGoingData = ["created" : true,
                                       "going": true]
            
            hangout.key = reference.key
            
            currentUserHangoutRef.updateChildValues(createdAndGoingData) { (error, reference) in
                if let error = error {
                    assertionFailure("Error: \(error.localizedDescription)")
                }
                let dg = DispatchGroup()
                
                for (key,_) in invitedFriends {
                    dg.enter()
                    let createdAndGoingData = ["created" : false,
                                               "going": false]
                    //add each invitedfriend to invited friends
                    let hangoutInvitedFriendsRef = hangoutRef.child("invites")
                    hangoutInvitedFriendsRef.updateChildValues([key : true]) { (error, reference) in
                        if let error = error {
                            assertionFailure("Error:\(error.localizedDescription)")
                        }
                    }
                    let ref = Database.database().reference().child("users").child(key).child("hangouts").child(hangout.key!)
                    ref.updateChildValues(createdAndGoingData, withCompletionBlock: { (error, ref) in
                        if let error = error {
                            assertionFailure("error: \(error.localizedDescription)")
                        }
                        dg.leave()
                    })
                    dg.notify(queue: .main, execute: {
                        completion(hangout)
                    })
                }
                
                
            }
        }
    }
    
    static func setGoing(_ hangout: Hangout, user: User) -> () {
        let ref = Database.database().reference().child("users").child(user.uid).child("hangouts").child(hangout.key!)
        ref.updateChildValues(["going" : true])
    }
    
    static func setNotGoing(_ hangout: Hangout, user: User) -> () {
        let ref = Database.database().reference().child("users").child(user.uid).child("hangouts").child(hangout.key!)
        ref.updateChildValues(["going" : false])
    }
    
    

    
    static func delete(hangout: Hangout) {
        let currentUser = User.current
        if let hangoutKey = hangout.key {
            //ref to invites in hangouts in hangout tree
            let hangoutInvitesRef = Database.database().reference().child("Hangouts").child(hangoutKey).child("invites")
            
            //remove from each invited user's tree
            hangoutInvitesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                let jsonSnapshot = JSON(snapshot.value)
                var userUIDs = [String]()
                for (key, subJson) in jsonSnapshot {
                    userUIDs.append(key)
                }
                
                let dispatchGroup = DispatchGroup()
                for userUID in userUIDs {
                    dispatchGroup.enter()
                    let invitedUsersHangoutRef = Database.database().reference().child("users").child(userUID).child("hangouts").child(hangoutKey)
                    invitedUsersHangoutRef.removeValue() { error, _ in
                        print(error)
                    }
                    dispatchGroup.leave()
                }
                let hangoutRef = Database.database().reference().child("Hangouts").child(hangoutKey)
                //remove from hangouts tree
                hangoutRef.removeValue() { error, _ in
                    print(error)
                }

            })
            
            
            
            //remove from currentUser tree
            let usersHangoutRef = Database.database().reference().child("users").child(currentUser.uid).child("hangouts").child(hangoutKey)
            usersHangoutRef.removeValue() { error, _ in
                print(error)
            }
            
        }
    }
//    static func inviteFriend(user: User, hangout: Hangout, completion: @escaping (Hangout?) -> ()) {
//        let ref = Database.database().reference().child("hangouts").child(hangout.key)
//    }

    
    static func getUserCreatedHangouts(completion: @escaping ([Hangout]) -> Void) {
        let currentUser = User.current
        let hangoutsRef = Database.database().reference().child("users").child(currentUser.uid).child("hangouts")
        hangoutsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let jsonSnapshot = JSON(snapshot.value)
            var hangoutKeys = [String]()
            for (key, subJson) in jsonSnapshot {
                let createdBoolean = subJson["created"].boolValue
                if createdBoolean {
                    hangoutKeys.append(key)
                }
                
            }
            
            let dg = DispatchGroup()
            var usersHangouts = [Hangout]()
            //key is all of the hangouts under currentUser.uid
            hangoutKeys.forEach({ (key) in
                dg.enter()
                let ref = Database.database().reference().child("Hangouts").child(key)
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    let hangout = Hangout(snapshot: snapshot)
                    usersHangouts.append(hangout!)
                    dg.leave()
                })
                dg.notify(queue: .main, execute: {
                    completion(usersHangouts)
                })

            })
        })
    }
    
    static func getUserInvitedHangouts(completion: @escaping ([Hangout]) -> Void) {
        let currentUser = User.current
        let hangoutsRef = Database.database().reference().child("users").child(currentUser.uid).child("hangouts")
        hangoutsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let jsonSnapshot = JSON(snapshot.value)
            var hangoutKeys = [String]()
            for (key, subJson) in jsonSnapshot {
                
                let createdBoolean = subJson["created"].boolValue
                if !createdBoolean {
                    hangoutKeys.append(key)
                }
                
            }
            let dg = DispatchGroup()
            var usersHangouts = [Hangout]()
            //key is all of the hangouts under currentUser.uid
            hangoutKeys.forEach({ (key) in
                dg.enter()
                let ref = Database.database().reference().child("Hangouts").child(key)
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    let hangout = Hangout(snapshot: snapshot)
                    usersHangouts.append(hangout!)
                    dg.leave()
                })
                dg.notify(queue: .main, execute: {
                    completion(usersHangouts)
                })
                
            })
        })
    }
    
    static func flag(_ hangout: Hangout) {
        guard let hangoutKey = hangout.key else { return }
        let flaggedHangoutRef = Database.database().reference().child("flaggedHangouts").child(hangoutKey)
        UserService.getUser(hangout.admin) { (user) in
            let flaggedDict = ["name": hangout.name,
                               "admin_uid": user.uid,
                               "reporter_uid": User.current.uid]
            flaggedHangoutRef.updateChildValues(flaggedDict)
        }
        let flagCountRef = flaggedHangoutRef.child("flag_count")
        flagCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
            let currentCount = mutableData.value as? Int ?? 0
            
            mutableData.value = currentCount + 1
            
            return TransactionResult.success(withValue: mutableData)
        })
    }

    static func getInvitedUsers(_ hangout: Hangout, completion: @escaping ([User]) -> Void) {
        if let hangoutKey = hangout.key {
            let hangoutRef = Database.database().reference().child("Hangouts").child(hangoutKey).child("invites")
            hangoutRef.observeSingleEvent(of: .value) { (snapshot) in
                let jsonSnapshot = JSON(snapshot.value)
                var userUIDs = [String]()
                for (key, _) in jsonSnapshot {
                    userUIDs.append(key)
                }
                
                let dg = DispatchGroup()
                var users = [User]()
                //key is all of the hangouts under currentUser.uid
                for id in userUIDs {
                    dg.enter()
                    let ref = Database.database().reference().child("users").child(id)
                    ref.observeSingleEvent(of: .value, with: { (snapshot) in
                        let user = User(snapshot: snapshot)
                        users.append(user!)
                        dg.leave()
                    })
                    dg.notify(queue: .main, execute: {
                        completion(users)
                    })
                    
                }
                
            }
        }
    }

    
    static func isInvited(_ user: User, hangout: Hangout, completion: @escaping (Bool) -> Void ) {
        if let hangoutKey = hangout.key {
            let hangoutRef = Database.database().reference().child("hangouts").child(hangoutKey).child("invites")
            var userFound = false
            hangoutRef.observeSingleEvent(of: .value) { (snapshot) in
                let jsonSnapshot = JSON(snapshot.value)
                for (key, subJson) in jsonSnapshot {
                    if key == user.uid {
                        userFound = true
                        completion(userFound)
                    }
                }
                completion(false)
            }
        }
    }
}
