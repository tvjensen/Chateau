//
//  RoomAnnotation.swift
//  Room
//
//  Created by Conner Smith on 5/3/18.
//  Copyright © 2018 csmith. All rights reserved.
//

import UIKit
import MapKit

class RoomAnnotation: MKPointAnnotation {

    var roomID: String
    var numMembers: Int
    var timeCreated: Double
    var name: String
    var latitude: Double
    var longitude: Double
    var posts: [String: Bool]
    
    // convenience method for writing to firebase
    var firebaseDict: [String : Any] {
        let dict: [String: Any] = ["roomID": self.roomID,
                                   "timeCreated":self.timeCreated,
                                   "latitude": self.latitude,
                                   "longitude": self.longitude,
                                   "posts": self.posts,
                                   "name": self.name,
                                   "numMembers": self.numMembers
        ]
        return dict
    }
    
    init?(dict: [String: Any?]) {
        guard let roomID = dict["roomID"] as? String else { return nil }
        guard let timeCreated = dict["timeCreated"] as? Double else { return nil }
        guard let latitude = dict["latitude"] as? Double else { return nil }
        guard let longitude = dict["longitude"] as? Double else { return nil }
        guard let name = dict["name"] as? String else { return nil }
        guard let numMembers = dict["numMembers"] as? Int else { return nil }
        
        self.roomID = roomID
        self.timeCreated = timeCreated
        self.latitude = latitude
        self.longitude = longitude
        self.posts = dict["posts"] as? [String: Bool] ?? [:]
        self.name = name
        self.numMembers = numMembers
        super.init()
        
        // set properties of MKPointAnnotation class
        self.title = self.name
        self.coordinate = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        self.subtitle = "\(numMembers) " + ((numMembers > 1) ? "people" : "person")
    }
    
    
}
