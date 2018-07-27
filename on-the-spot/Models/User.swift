//
//  User.swift
//  on-the-spot
//
//  Created by William Han on 7/25/18.
//  Copyright © 2018 Will Han. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class User {
    
    // MARK: - Properties
    
    let uid: String
    let name: String
    var isFriended = false
    
    // MARK: - Init
    
    init(uid: String, name: String) {
        self.uid = uid
        self.name = name
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let name = dict["name"] as? String
            else { return nil }
        
        self.uid = snapshot.key
        self.name = name
    }
    
    private static var _current: User?
    static var current: User {
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        return currentUser
    }
    
    static func setCurrent(_ user: User) {
        _current = user
    }
    
}
