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
    public static func startObservingRooms(callback: @escaping (RoomAnnotation) -> Void) {
        roomsRef.observe(DataEventType.childAdded) { (snapshot) in
            guard var roomDict = snapshot.value as? [String: Any?] else { return }
            roomDict["roomID"] = snapshot.key
            guard let room = RoomAnnotation(dict: roomDict) else { return }
            callback(room)
        }
    }
    // This function takes in an email and password and creates a user
    // If the user already exists, then it sends back a false boolean value
    // and does not add to database
    public static func createOrLoginUser(_ emailLoginText: String, _ passwordLoginText: String,_ createUser: Bool, callback: @escaping (Bool) -> Void) {
        ref.child("users").queryOrdered(byChild: "userID").queryEqual(toValue: emailLoginText)
            .observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
                if snapshot.exists() {
                    if createUser {
                        callback(false) //we want success to be false when signing up
                    } else {
                        callback(true) //we want success to be true when logging in
                    }
                }
                else {
                    if createUser {
                        ref.child("users").child(emailLoginText.lowercased()).setValue(["userID":emailLoginText,"email":emailLoginText])
                        callback(true) //returning success in creating user
                    } else {
                        callback(false)
                    }
                    
                }
            })
    }
    /*
     Given userID, returns all rooms for which userID is a participant.
     */
    public static func getMyRooms(_ userID: String, callback: @escaping (DataSnapshot) -> Void) {
        //TODO: I'm not sure what these keys/values are... right now this gets a list of roomIDs for a user
        // we need to foreach of those roomIDs, fetch the corresponding room object from the db, and then
        // return them as an array for the controller
        ref.child("users").child(userID).observeSingleEvent(of: .value, with: {(snapshot) in
            callback(snapshot);
            //for child in snapshot.children {
                //let snap = child as! DataSnapshot;
                //let roomID = snap.key;
                //ref.child("rooms").child(roomID)
            //}
        });
    }
}
