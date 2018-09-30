//
//  DroppablePin.swift
//  Treez
//
//  Created by Weston Gibler on 9/30/18.
//  Copyright © 2018 Weston Gibler. All rights reserved.
//

import UIKit
import MapKit

class DroppablePin: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    var identifier: String
    
    init(coordinate: CLLocationCoordinate2D, identifier: String) {
        self.coordinate = coordinate
        self.identifier = identifier
        super.init()
    }
}
