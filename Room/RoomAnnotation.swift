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

    public var room: Models.Room
    
    init?(dict: [String: Any?]) {
        guard let room = Models.Room(dict: dict) else { return nil }
        self.room = room
        super.init()
        setProps()
    }
    
    init(_ room: Models.Room) {
        self.room = room
        super.init()
        setProps()
    }
    
    private func setProps() {
        // set properties of MKPointAnnotation class
        self.title = room.name
        self.coordinate = CLLocationCoordinate2D(latitude: room.latitude, longitude: room.longitude)
        self.subtitle = "\(room.numMembers) member" + ((room.numMembers > 1) ? "s" : "")
    }
    
    
}
