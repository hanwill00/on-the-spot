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
        print("in Hangout Service")
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
        
        //Updating hangout information under hangout key
        
    static func delete(hangout: Hangout) {
        let currentUser = User.current
        if let hangoutKey = hangout.key {
            //ref to hangout in hangout tree
            let hangoutRef = Database.database().reference().child("Hangouts").child(hangoutKey).child("invites")
            
            //remove from each invited user's tree
            hangoutRef.observeSingleEvent(of: .value, with: { (snapshot) in
//                guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
//                    else {return}
                let jsonSnapshot = JSON(snapshot.value)
                var userUIDs = [String]()
                print("PRINTING")
                for (key, subJson) in jsonSnapshot {
                    print(key)
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
    static func inviteFriend(user: User, hangout: Hangout, completion: @escaping (Hangout?) -> ()) {
        //let ref = Database.database().reference().child("hangouts").child(hangout.key)
    }

    static func getUserHangouts(completion: @escaping ([Hangout]) -> Void) {
        let currentUser = User.current
        let ref = Database.database().reference().child("users").child(currentUser.uid).child("hangouts")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
//
//                else {return completion([])}
            let jsonSnapshot = JSON(snapshot.value)
            var hangoutKeys = [String]()
            for (key, subJson) in jsonSnapshot {
                print(key)
                hangoutKeys.append(key)
            }
            let dg = DispatchGroup()
            var usersHangouts = [Hangout]()
            //key is all of the hangouts under currentUser.uid
            hangoutKeys.forEach({ (key) in
                dg.enter()
                let ref = Database.database().reference().child("Hangouts").child(key)
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
//                    guard let snapshot = snapshot else { return }
//                    let maxCapSnapshot = snapshot[2] as? String : Any
//                    let maxCap = maxCapSnapshot["maxCap"]
//                    let nameSnapshot = snapshot[3]
//                    let name = nameSnapshot["name"]
                    
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

    //isInvited function returning bool
    //RSVP function -- pass in true or false (response)
    //RetrieveAllHangoutsForUser
    //
    
}
