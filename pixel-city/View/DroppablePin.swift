//
//  DroppablePin.swift
//  pixel-city
//
//  Created by Kunal Tyagi on 28/12/17.
//  Copyright © 2017 Kunal Tyagi. All rights reserved.
//

import UIKit
import MapKit

class DropabblePin: NSObject, MKAnnotation{
    dynamic var coordinate: CLLocationCoordinate2D
    var identifier: String
    
    init(coordinate: CLLocationCoordinate2D, identifier: String){
        self.coordinate = coordinate
        self.identifier = identifier
        super.init()
    }
}
