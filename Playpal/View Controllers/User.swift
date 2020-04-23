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
    
    var firstName: String!
    var lastName: String!
    var hometown: String!
    var pupName: String!
    var breed: String!
    var size: String!
    var gender: String!
    
    init(userEmail: String, userID: String, userFirstName: String, userLastName: String, userHometown: String, userPupName: String, userBreed: String, userSize: String, userGender: String) {
           
           self.email = userEmail
           self.id = userID
        
           self.firstName = userFirstName
           self.lastName = userLastName
           self.hometown = userHometown
           self.pupName = userPupName
           self.breed = userBreed
           self.size = userSize
           self.gender = userGender
           
       }
    
}
