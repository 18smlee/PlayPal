//
//  ProfileViewController.swift
//  Playpal
//
//  Created by Samantha Lee on 4/21/20.
//  Copyright © 2020 Samantha Lee. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var dogProfileLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(UserModel.model.getDogName())
    }
    

    @IBAction func logout(_ sender: Any) {
        try! Auth.auth().signOut()
        transitionToStart()
    }
    
    func transitionToStart() {
        let viewController =
            storyboard?.instantiateViewController(identifier: Constants.Storyboard.viewController) as? ViewController
        
        view.window?.rootViewController = viewController
        view.window?.makeKeyAndVisible()
    }
    
    // stylizing elements
    func setUpElements() {
        Utilities.styleFilledButton(logoutButton)
    }
}
