//
//  HomeViewController.swift
//  Playpal
//
//  Created by Samantha Lee on 4/15/20.
//  Copyright © 2020 Samantha Lee. All rights reserved.
//

import UIKit
import GeoFire

class HomeViewController: UITabBarController {
    @IBInspectable var defaultIndex: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedIndex = defaultIndex

        tabBar.barTintColor = UIColor(red: 200/200, green: 200/200, blue: 200/200, alpha: 1)
        self.tabBarController?.selectedIndex = 2
        
    }
    
    func setUpNavBar() {
        let mapController = UINavigationController(rootViewController: MapViewController())
        mapController.tabBarItem.image = UIImage(named: "map_icon.png")
        mapController.tabBarItem.selectedImage = UIImage(named: "selected_map_icon.png")
        
        let profileController = UINavigationController(rootViewController: ProfileViewController())
        profileController.tabBarItem.image = UIImage(named: "dog_icon-1.png")
        profileController.tabBarItem.selectedImage = UIImage(named: "selected_dog_icon.png")
        
        let palsController = UINavigationController(rootViewController: PalsViewController())
        palsController.tabBarItem.image = UIImage(named: "pals_icon.png")
    }

}
