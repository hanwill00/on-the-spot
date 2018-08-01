//
//  Hangout.swift
//  on-the-spot
//
//  Created by William Han on 7/29/18.
//  Copyright © 2018 Will Han. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class Hangout {
    var key: String?
    let name: String
    let maxCap: Int
    let creationDate: Date
    var admin: String
    
    
    var dictValue: [String : Any] {
        let createdAgo = creationDate.timeIntervalSince1970
        
        return ["name" : name,
                "maxCap" : maxCap,
                "admin" : admin,
                "created_at" : createdAgo]
    }
    
    init(name: String, maxCap: Int) {
        self.admin = User.current.uid
        self.name = name
        self.maxCap = maxCap
        self.creationDate = Date()
    }
    
    init?(snapshot: DataSnapshot) {
        print(snapshot)
        guard let dict = snapshot.value as? [String : AnyObject] else { return nil }

        self.maxCap = dict["maxCap"] as! Int
        self.name = dict["name"] as! String
        self.admin = User.current.uid
        self.creationDate = Date()
    }
}
