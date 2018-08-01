//
//  HangoutService.swift
//  on-the-spot
//
//  Created by William Han on 7/29/18.
//  Copyright © 2018 Will Han. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase

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
                
                    //reference refers to hangout key
                
                    //hangouRef = hangout key under hangouts
                  //  let hangoutRef = Database.database().reference().child("hangouts").child(hangout.key!)
//                    hangoutRef.updateChildValues(dict) { (error, reference) in
//                        if let error = error {
//                            assertionFailure("there was an error: \(error.localizedDescription)")
//                        } else {
//                            completion(hangout)
//                        }
//                    }
//                    hangoutRef.updateChildValues(invitedFriends) { (error, reference) in
//                        if let error = error {
//                            assertionFailure("there was an error: \(error.localizedDescription)")
//                        } else {
//                            completion(hangout)
//                        }
//                    }
                }
            }
        }
        
        //Updating hangout information under hangout key
        
    
    
    static func inviteFriend(user: User, hangout: Hangout, completion: @escaping (Hangout?) -> ()) {
        //let ref = Database.database().reference().child("hangouts").child(hangout.key)
    }

    //isInvited function returning bool
    //RSVP function -- pass in true or false (response)
    //RetrieveAllHangoutsForUser
    //
    
}
