//
//  Firebase.swift
//  Room
//
//  Created by Conner Smith on 5/3/18.
//  Copyright © 2018 csmith. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Firebase {
    
    // use this to interact with db
    private static let ref = Database.database().reference()
    private static let roomsRef = ref.child("rooms")
    
    // start observing rooms so that explore page can display
    public static func startObservingRooms() {
//        callback: ((Models.Room) -> (Void)
//        roomsRef.observe(DataEventType.childAdded) { (snapshot) in
//            guard let room = Models.Room(snapshot.value) else { callback(nil); return; }
//            callback(room)
//        }
    }
    
}
