//
//  User.swift
//  Treez
//
//  Created by Weston Gibler on 10/5/18.
//  Copyright © 2018 Weston Gibler. All rights reserved.
//

import Foundation
import Firebase
import MapKit

struct Tree {
    
    let ref: DatabaseReference?
    let key: String
    let name: String
    let addedByUser: String
    var completed: Bool
    let coordinate: CLLocationCoordinate2D
    
    init(name: String, addedByUser: String, completed: Bool, key: String = "", coordinate: CLLocationCoordinate2D) {
        self.ref = nil
        self.key = key
        self.name = name
        self.addedByUser = addedByUser
        self.completed = completed
        self.coordinate = coordinate
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["name"] as? String,
            let addedByUser = value["addedByUser"] as? String,
            let completed = value["completed"] as? Bool,
            let coordinate = value["coordinate"]  as? CLLocationCoordinate2D else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.name = name
        self.addedByUser = addedByUser
        self.completed = completed
        self.coordinate = coordinate
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "addedByUser": addedByUser,
            "completed": completed,
            "coordinate": coordinate
        ]
    }
}
