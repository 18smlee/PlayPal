//
//  PalsViewController.swift
//  Playpal
//
//  Created by Samantha Lee on 4/22/20.
//  Copyright © 2020 Samantha Lee. All rights reserved.
//

import UIKit
import GeoFire

class PalsViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    var geoFireRef: DatabaseReference?
    var geoFire: GeoFire?
    var myQuery: GFQuery?
    
    var nearbyUsers = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNearbyUsers()
        
    }
    
    // fills array with users in given radius
    func getNearbyUsers() {
        
        geoFireRef = Database.database().reference().child("Geolocs")
        
        geoFire = GeoFire(firebaseRef: geoFireRef!)
        
        let userLat = UserDefaults.standard.value(forKey: "current_latitude") as! String
        let userLong = UserDefaults.standard.value(forKey: "current_longitude") as! String
        
        let location:CLLocation = CLLocation(latitude: CLLocationDegrees(Double(userLat)!), longitude: CLLocationDegrees(Double(userLong)!))
        
        myQuery = geoFire?.query(at: location, withRadius: 100)
        
        myQuery?.observe(.keyEntered, with: { (key, location) in
            
            UserModel.model.getUser(key) { (nearUser) in
                self.nearbyUsers.append(nearUser)
            }
        })
    }
}

extension PalsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("number of rows called")
        return nearbyUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cell for row at called")
        let user = nearbyUsers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellData") as! UserCell
        cell.setData(user: user)
        
        return cell
    }
    
}
