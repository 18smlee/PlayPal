//
//  SignUpViewController.swift
//  Playpal
//
//  Created by Samantha Lee on 4/15/20.
//  Copyright © 2020 Samantha Lee. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage

class SignUpViewController: UIViewController {
    
    // owner info
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var hometownTextField: UITextField!
    
    // dog info
    var pupNameText: String?
    var breedText: String?
    var size: String?
    var gender: String?
    var dogImageData: Data?
    var dogImageURL: URL?
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        setUpElements()
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            print("not working")
            showError(error!)
        } else {
            print("working")
            // Create cleaned versions of data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let hometown = hometownTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let pupName = pupNameText?.trimmingCharacters(in: .whitespacesAndNewlines)
            let breed = breedText?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                
                if error != nil {
                    print(error?.localizedDescription)
                    self.showError(error?.localizedDescription ?? "Error creating user")
                    
                } else {
                    print("before")
                    print(self.dogImageURL?.absoluteString)
                    
//                    let group = DispatchGroup()
//                    group.enter()
//
//                    DispatchQueue.main.sync {
                        // Upload the profile image to Firebase Storage
                        self.uploadDogProfileImage(dogImageData: self.dogImageData)
//                        group.leave()
//                    }
                    
//                    group.notify(queue: .main) {
                        print("Simulation finished")
                        print("after")
                        print(self.dogImageURL?.absoluteString)
//                        let db = Firestore.firestore()
//
//                        db.collection("users").addDocument(data: ["uid": result!.user.uid, "firstName":firstName, "lastName":lastName, "hometown":hometown, "pupName":pupName, "breed":breed, "size":self.size, "gender":self.gender, "dogImageURL":self.dogImageURL]) {(error) in
//
//                            if error != nil {
//                                self.showError("Error saving user data")
//                            }
//
//                        }
                    UserModel.model.createUser(uid: result!.user.uid, firstName: firstName, lastName: lastName, hometown: hometown, pupName: pupName, breed: breed, size: self.size, gender: self.gender, dogImageURL: self.dogImageURL)
                        self.transitionToHome()
//                    }
                }
            }
        }
    }
    
    func uploadDogProfileImage(dogImageData: Data?) {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let storageRef = Storage.storage().reference().child("user/\(uid)")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        storageRef.putData(self.dogImageData!, metadata: metadata) {(metadata, error) in
            if error == nil, metadata != nil {
                storageRef.downloadURL(completion: { (url, error) in
                    if let metaImageURL = url {
                        self.dogImageURL = metaImageURL
                        print("-------")
                        print(self.dogImageURL?.absoluteString)
                        print("-------")
                    } else {
                        print("dogImageURL not set!")
                        print(url)
                    }
                })
            } else {
                print(error?.localizedDescription)
            }
        }
        
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {
        
        let homeViewController =
            storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    // Checks to make sure all text fields are valid. If correct return nil, else return error message.
    func validateFields() -> String?{
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            hometownTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please fill in all fields."
        }
        // check if password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isPasswordValid(cleanedPassword) == false {
            return "Make sure your password is at least 8 characters and contains a special character and a number"
        }
        return nil
    }
    
    func isPasswordValid(_ password: String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[1-Z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    func setUpElements() {
        // hide error label
        errorLabel.alpha = 0;
        
        // Style the elements
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
    }
    
}
