//
//  LoginViewController.swift
//  Playpal
//
//  Created by Samantha Lee on 4/15/20.
//  Copyright © 2020 Samantha Lee. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func loginTapped(_ sender: Any) {
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                   let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signs in user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                
                self.showError(error!.localizedDescription)
                
            } else {
                
                self.transitionToHome()
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
    }
    
    func setUpElements() {
        // hide error label
        errorLabel.alpha = 0;
        
        // Style the elements
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
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
}