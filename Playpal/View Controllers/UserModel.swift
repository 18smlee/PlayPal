//
//  UserModel.swift
//  Playpal
//
//  Created by Samantha Lee on 4/23/20.
//  Copyright © 2020 Samantha Lee. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

class UserModel {
    
    static let model = UserModel()
    let db = Firestore.firestore()
    let id = Auth.auth().currentUser!.uid
    
    func createUser(uid: String?, firstName: String?, lastName: String?, hometown: String?, pupName: String?, breed: String?, size: String?, gender: String?, dogImageURL: URL?) {
        
        db.collection("users").addDocument(data: ["uid": uid, "firstName":firstName, "lastName":lastName, "hometown":hometown, "pupName":pupName, "breed":breed, "size":size, "gender":gender, "dogImageURL":dogImageURL])
    }
    
    func getDogName() -> String? {
        let userRef = db.collection("users").document(id)
        var dogName = ""
        userRef.getDocument(source: .cache) { (document, error) in
            if let document = document {
                dogName = document.get("pupName") as! String
            } else {
                print("Document does not exist in cache")
            }
        }
        return dogName
    }
}
