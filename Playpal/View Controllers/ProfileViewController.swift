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
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var breedLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var dogProfileImageView: UIImageView!
    
    @IBOutlet weak var bioView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserModel.model.getCurrentUser { (user) in
            self.dogProfileLabel.text = "\(user.pupName!)'s Profile"
            self.nameLabel.text = user.pupName!
            self.breedLabel.text = user.breed!
            self.infoLabel.text = "\(user.size!) | \(user.gender!)"
            if user.picURL != "" {
                let url = URL(string: user.picURL)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.dogProfileImageView.image = UIImage(data: data!)
                    }
                }).resume()
            } else {
                self.dogProfileImageView.image = UIImage(named: "dog_icon-1.")
            }
            self.bioView.text = user.bio!
        }
        
        setUpElements()
        
    }
    
    
    // log out functions
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
