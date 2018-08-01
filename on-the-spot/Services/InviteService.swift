//
//  InviteService.swift
//  on-the-spot
//
//  Created by William Han on 7/30/18.
//  Copyright © 2018 Will Han. All rights reserved.
//

import Foundation
import FirebaseDatabase
import SwiftyJSON

struct InviteService {
    //modeled after followUser
    private static func inviteFriend(_ user: User, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
        // 1
        let currentUID = User.current.uid
        let inviteData = ["followers/\(user.uid)/\(currentUID)" : true,
                          "following/\(currentUID)/\(user.uid)" : true]
        
        // 2
        let ref = Database.database().reference()
        ref.updateChildValues(inviteData) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            
            // 3
            success(error == nil)
        }
    }
}
