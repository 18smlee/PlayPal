//
//  ViewController.swift
//  Playpal
//
//  Created by Samantha Lee on 4/14/20.
//  Copyright © 2020 Samantha Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setUpElements()
   
    }
    
    func setUpElements() {
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
    }
}

