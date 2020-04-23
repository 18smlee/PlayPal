//
//  User.swift
//  Playpal
//
//  Created by Samantha Lee on 4/23/20.
//  Copyright © 2020 Samantha Lee. All rights reserved.
//

import Foundation

class User {
    
    var email: String!
    var id: String!
    
    init(userEmail: String, userID: String) {
        self.email = userEmail
        self.id = userID
    }
    
}
