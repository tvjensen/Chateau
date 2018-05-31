//
//  Current.swift
//  Room
//
//  Created by Conner Smith on 5/16/18.
//  Copyright © 2018 csmith. All rights reserved.
//

import Foundation

class Current {
    
    static var user: Models.User?
    
    // atrocious style but this is used inside
    // the MyRoomsViewController because if user
    // presses "Go to room" from map view, this global is how we can
    // communicate which room to enter to the controller
    static var roomToEnter: Models.Room?
    
}
