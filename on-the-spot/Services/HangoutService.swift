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
    static func create(for name: String, maxCap: Int) {
        let currentUser = User.current
        // 2
        let hangout = Hangout(name: name, maxCap: maxCap)
        // 3
        let dict = hangout.dictValue
        
        // 4
        let hangoutRef = Database.database().reference().child("hangouts").child(currentUser.uid).childByAutoId()
        //5
        hangoutRef.updateChildValues(dict)
    }
}
