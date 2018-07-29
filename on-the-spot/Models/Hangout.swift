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
    
    var dictValue: [String : Any] {
        let createdAgo = creationDate.timeIntervalSince1970
        
        return ["name" : name,
                "maxCap" : maxCap,
                "created_at" : createdAgo]
    }
    
    init(name: String, maxCap: Int) {
        self.name = name
        self.maxCap = maxCap
        self.creationDate = Date()
    }
}
