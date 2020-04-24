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
    
    // Firebase references
    let BASE_REF = Database.database().reference()
    let USER_REF = Database.database().reference().child("users")
    
    var CURRENT_USER_REF: DatabaseReference {
        let id = Auth.auth().currentUser!.uid
        return USER_REF.child("\(id)")
    }
    
    var CURRENT_USER_FRIENDS_REF: DatabaseReference {
        return CURRENT_USER_REF.child("friends")
    }
    
    var CURRENT_USER_REQUESTS_REF: DatabaseReference {
        return CURRENT_USER_REF.child("requests")
    }
    
    var CURRENT_USER_ID: String {
        let id = Auth.auth().currentUser!.uid
        return id
    }
    
    
    func getCurrentUser(_ completion: @escaping (User) -> Void) {
        CURRENT_USER_REF.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            let email = snapshot.childSnapshot(forPath: "email").value as! String
            let firstName = snapshot.childSnapshot(forPath: "firstName").value as! String
            let lastName = snapshot.childSnapshot(forPath: "lastName").value as! String
            let hometown = snapshot.childSnapshot(forPath: "hometown").value as! String
            let pupName = snapshot.childSnapshot(forPath: "pupName").value as! String
            let breed = snapshot.childSnapshot(forPath: "breed").value as! String
            let size = snapshot.childSnapshot(forPath: "size").value as! String
            let gender  = snapshot.childSnapshot(forPath: "gender").value as! String
            let picURL  = snapshot.childSnapshot(forPath: "picURL").value as! String
             let bio  = snapshot.childSnapshot(forPath: "bio").value as! String
            let id = snapshot.key
            
            completion(User(userEmail: email, userID: id, userFirstName: firstName, userLastName: lastName, userHometown: hometown, userPupName: pupName, userBreed: breed, userSize: size, userGender: gender, userPicURL: picURL, userBio: bio))
        })
    }
    
    func getUser(_ userID: String, completion: @escaping (User) -> Void) {
        USER_REF.child(userID).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            
            let email = snapshot.childSnapshot(forPath: "email").value as! String
            let firstName = snapshot.childSnapshot(forPath: "firstName").value as! String
            let lastName = snapshot.childSnapshot(forPath: "lastName").value as! String
            let hometown = snapshot.childSnapshot(forPath: "hometown").value as! String
            let pupName = snapshot.childSnapshot(forPath: "pupName").value as! String
            let breed = snapshot.childSnapshot(forPath: "breed").value as! String
            let size = snapshot.childSnapshot(forPath: "size").value as! String
            let gender  = snapshot.childSnapshot(forPath: "gender").value as! String
            let picURL  = snapshot.childSnapshot(forPath: "picURL").value as! String
            let bio  = snapshot.childSnapshot(forPath: "bio").value as! String
            let id = snapshot.key
            
            completion(User(userEmail: email, userID: id, userFirstName: firstName, userLastName: lastName, userHometown: hometown, userPupName: pupName, userBreed: breed, userSize: size, userGender: gender, userPicURL: picURL, userBio: bio))
        })
    }
    
    
    
    // sends user info to store in database
    func sendUserInfo(_ email: String?, _ firstName: String?, _ lastName: String?,_ hometown: String?,_ pupName: String?, _ breed: String?, _ size: String?, _ gender: String?, _ picURL: String?, bio: String?) {
        
        var userInfo = [String: AnyObject]()
        userInfo = ["email": email as AnyObject, "firstName": firstName as AnyObject,"lastName":lastName as AnyObject, "hometown":hometown as AnyObject, "pupName":pupName as AnyObject, "breed":breed as AnyObject, "size":size as AnyObject, "gender":gender as AnyObject, "picURL":picURL as AnyObject, "bio":bio as AnyObject]
        self.CURRENT_USER_REF.setValue(userInfo)
        
    }
    
    
    // MARK: - All users
       var userList = [User]()

       func addUserObserver(_ update: @escaping () -> Void) {
           UserModel.model.USER_REF.observe(DataEventType.value, with: { (snapshot) in
               self.userList.removeAll()
               for child in snapshot.children.allObjects as! [DataSnapshot] {

                let email = snapshot.childSnapshot(forPath: "email").value as! String
                let firstName = snapshot.childSnapshot(forPath: "firstName").value as! String
                let lastName = snapshot.childSnapshot(forPath: "lastName").value as! String
                let hometown = snapshot.childSnapshot(forPath: "hometown").value as! String
                let pupName = snapshot.childSnapshot(forPath: "pupName").value as! String
                let breed = snapshot.childSnapshot(forPath: "breed").value as! String
                let size = snapshot.childSnapshot(forPath: "size").value as! String
                let gender  = snapshot.childSnapshot(forPath: "gender").value as! String
                let picURL  = snapshot.childSnapshot(forPath: "picURL").value as! String
                let bio  = snapshot.childSnapshot(forPath: "bio").value as! String
                let id = snapshot.key
                
                   if email != Auth.auth().currentUser?.email! {
                       self.userList.append(User(userEmail: email, userID: id, userFirstName: firstName, userLastName: lastName, userHometown: hometown, userPupName: pupName, userBreed: breed, userSize: size, userGender: gender, userPicURL: picURL, userBio: bio))
                   }
               }
               update()
           })
       }
       /** Removes the user observer. This should be done when leaving the view that uses the observer. */
       func removeUserObserver() {
           USER_REF.removeAllObservers()
       }
}
