//
//  UserAnnotation.swift
//  Playpal
//
//  Created by Samantha Lee on 4/23/20.
//  Copyright © 2020 Samantha Lee. All rights reserved.
//

import Foundation
import MapKit

class UserAnnotation: MKPointAnnotation {
    var pupName_ann: String
    var dogImageURL_ann: String
    
    init(coordinate: CLLocationCoordinate2D, pupName_ann: String, dogImageURL_ann: String) {
        self.pupName_ann = pupName_ann
        self.dogImageURL_ann = dogImageURL_ann
        super.init()
        self.coordinate = coordinate
    }
}
