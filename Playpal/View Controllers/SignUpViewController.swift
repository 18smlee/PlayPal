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
import CoreLocation
import GeoFire

class SignUpViewController: UIViewController, CLLocationManagerDelegate {
    
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
    var dogImageURL: String? = ""
    var bioText: String?
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    // variables for storing and updating user location
    private let manager = CLLocationManager()
    var geoFireRef: DatabaseReference?
    var geoFire: GeoFire?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adds locations to database
        configureLocationManager()
        geoFireRef = Database.database().reference().child("Geolocs")
        geoFire = GeoFire(firebaseRef: geoFireRef!)
        
        
        self.navigationController?.isNavigationBarHidden = false
        setUpElements()
    }
    
    private func configureLocationManager(){
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
        manager.pausesLocationUpdatesAutomatically = false
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
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
            let bio = bioText?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Gets user's current location
            let userLat = UserDefaults.standard.value(forKey: "current_latitude") as! String
            let userLong = UserDefaults.standard.value(forKey: "current_longitude") as! String
            
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                
                if error != nil {
                    print(error?.localizedDescription)
                    self.showError(error?.localizedDescription ?? "Error creating user")
                    
                } else {
                    
                    self.uploadDogProfileImage(dogImageData: self.dogImageData) { (doneUploading) in
                        // fills database with user info
                        UserModel.model.sendUserInfo(email, firstName, lastName, hometown, pupName, breed, self.size, self.gender, self.dogImageURL, bio: bio)
                        
                        // adds location to database
                        let location:CLLocation = CLLocation(latitude: CLLocationDegrees(Double(userLat)!), longitude: CLLocationDegrees(Double(userLong)!))
                        self.geoFire?.setLocation(location, forKey:Auth.auth().currentUser?.uid ?? "")
                        
                        self.transitionToHome()
                    }
                    
                }
            }
        }
    }
    
    
    //MARK: LocationManager Delegate Methods
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if (status == .authorizedAlways) || (status == .authorizedWhenInUse)
        {
            manager.startUpdatingLocation()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Location Error:\(error.localizedDescription)")
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let updatedLocation:CLLocation = locations.first!
        
        let newCoordinate: CLLocationCoordinate2D = updatedLocation.coordinate
        
        let usrDefaults:UserDefaults = UserDefaults.standard
        
        usrDefaults.set("\(newCoordinate.latitude)", forKey: "current_latitude")
        usrDefaults.set("\(newCoordinate.longitude)", forKey: "current_longitude")
        usrDefaults.synchronize()
    }
    
    
    
    // uploads chosen picture to Firebase Storage and stores URL in database
    func uploadDogProfileImage(dogImageData: Data?, doneUploading: (Bool) -> Void) {
        
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
                        Database.database().reference().child("users").child(UserModel.model.CURRENT_USER_ID).child("picURL").setValue(metaImageURL.absoluteString)
                    }
                })
            } else {
                print("error uploading picture")
                print(error?.localizedDescription)
            }
        }
        doneUploading(true)
        
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
        Utilities.styleTextField(hometownTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
    }
    
}
