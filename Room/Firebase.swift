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
    public static func startObservingRooms(callback: @escaping (Models.Room) -> Void) {
        roomsRef.observe(DataEventType.childAdded) { (snapshot) in
            guard var roomDict = snapshot.value as? [String: Any?] else { return }
            roomDict["roomID"] = snapshot.key
            guard let room = Models.Room(dict: roomDict) else { return }
            callback(room)
        }
    }
    
    
    public static func createUser(_ emailLoginText: String, _ passwordLoginText: String, callback: @escaping (Bool) -> Void) {
        ref.child("users").queryOrdered(byChild: "userID").queryEqual(toValue: emailLoginText)
            .observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
                if snapshot.exists() {
                    callback(false) //user already exists
                }
                else {
                    ref.child("users").child(emailLoginText.lowercased()).setValue(["userID":emailLoginText,"email":emailLoginText])
                    callback(true) //returning success in creating user
                }
            })
    }
}
