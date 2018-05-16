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
    
    public static func createRoom(_ roomName: String, _ createdByUser: String,_ timeCreated: Double,_ latitude: Double,_ longitude: Double, callback: @escaping (Bool) -> Void) {
        
        //create room, add to rooms table
        let roomInfo: [String: Any] = ["name": roomName, "creatorID": createdByUser, "timeCreated": timeCreated, "latitude": latitude, "longitude": longitude]
        let reference  = ref.child("rooms").childByAutoId()
        reference.setValue(roomInfo)
        let roomID = reference.key
        callback(true)
        
        
        //add roomID to user's current list of rooms in db
        ref.child("users").child(createdByUser).child("rooms").observeSingleEvent(of: .value, with: { (snapshot) in
            let enumerator = snapshot.children
            var prevRooms: [String:Bool] = [:]
            while let rest = enumerator.nextObject() as? DataSnapshot {
                prevRooms[rest.key] = true
            }
            var roomsUpdate = prevRooms
            roomsUpdate[roomID] = true
            let userUpdate = ["users/\(createdByUser)/":["rooms":roomsUpdate]]
            ref.updateChildValues(userUpdate)
        })
    }
    
    
    /*
     Given userID, returns all rooms for which userID is a participant.
     */
    public static func getMyRooms(_ userID: String, callback: @escaping ([Models.Room]) -> Void)  {
        ref.child("users").child(userID).child("rooms").observeSingleEvent(of: .value, with: { (snapshot) in
            let enumerator = snapshot.children // to iterate through room IDS associated with this user
            var rooms: [Models.Room] = [] // array to be returned
            while let r = enumerator.nextObject() as? DataSnapshot { // for each roomID, fetch room object from DB
                ref.child("rooms").child(r.key).observeSingleEvent(of: .value, with: { (snapshot) in
                    var dict = snapshot.value as! [String : Any?]
                    dict["roomID"] = r.key
                    let room = Models.Room(dict: dict) // cast to Room
                    rooms.append(room!) // add to result
                    callback(rooms)
                })
            }
//            callback(rooms)
        })
    }
    
//    struct Room {
//        var roomID: String
//        var name: String
//        var creatorID: String
//        var timeCreated: Double
//        var latitude: Double
//        var longitude: Double
//    }
}
