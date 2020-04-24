//
//  MapViewController.swift
//  Playpal
//
//  Created by Samantha Lee on 4/21/20.
//  Copyright © 2020 Samantha Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GeoFire

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    // Geofire references
    var geoFireRef: DatabaseReference?
    var geoFire: GeoFire?
    var myQuery: GFQuery?
    
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        showNearbyUsers()
        
        setUpManager()
        
    }
    
    func setUpManager() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    // updates user's location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        let region: MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: span)
        
        mapView.setRegion(region, animated: true)
        
        self.mapView.showsUserLocation = true
    }
    
    // fills array with users in given radius
    func showNearbyUsers() {
                
        geoFireRef = Database.database().reference().child("Geolocs")
        
        geoFire = GeoFire(firebaseRef: geoFireRef!)
        
        let userLat = UserDefaults.standard.value(forKey: "current_latitude") as! String
        let userLong = UserDefaults.standard.value(forKey: "current_longitude") as! String
        
        let location:CLLocation = CLLocation(latitude: CLLocationDegrees(Double(userLat)!), longitude: CLLocationDegrees(Double(userLong)!))
        
        myQuery = geoFire?.query(at: location, withRadius: 100)
        
        myQuery?.observe(.keyEntered, with: { (key, location) in
            print("KEY FOUND")
            if key != UserModel.model.CURRENT_USER_ID {
                
                UserModel.model.getUser(key) { (nearUser) in
                    print("getting user")
                    /// create annotation for nearby user
                    let nearUserAnnotation = UserAnnotation(coordinate: location.coordinate, pupName_ann: nearUser.pupName, dogImageURL_ann: nearUser.picURL)
                    
                    print(nearUserAnnotation.pupName_ann)
                    
                    /// add annotation to mapView
                    self.mapView.addAnnotation(nearUserAnnotation)
                }
            }
        })
        let dogParkCoord = CLLocationCoordinate2D(latitude: 40.005011256438635, longitude: -75.2586615706985)
        let dogPark = UserAnnotation(coordinate: dogParkCoord, pupName_ann: "Haverford Dog Park", dogImageURL_ann: "")
    }
}

// MARK: MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    
    /// customize annotation view
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print("CUSTOMIZING ANNOTATION")
         guard let userAnnotation = annotation as? UserAnnotation else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        
        if annotationView == nil {
            print("initializing annotationView")
            annotationView = MKAnnotationView(annotation: userAnnotation, reuseIdentifier: "AnnotationView")
        }
        if userAnnotation.pupName_ann == "Haverford Dog Park" {
            //annotationView?.image = 
        } else {
            annotationView?.image = UIImage(named: "dog_icon-1")
        }
        annotationView?.detailCalloutAccessoryView = getCalloutLabel(with: userAnnotation.pupName_ann)
        
        annotationView?.canShowCallout = true
        
        return annotationView
    
    }
    // This function should not require modification
    private func getCalloutLabel(with name: String) -> UILabel {
        let label = UILabel()
        label.text = name
        return label
    }
}
