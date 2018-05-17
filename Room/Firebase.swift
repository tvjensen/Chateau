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
    private static let usersRef = ref.child("users")
    
    private static var currentTime: Double {
        return Double(NSDate().timeIntervalSince1970)
    }
    
    // start observing rooms so that explore page can display
    public static func startObservingRooms(callback: @escaping (Models.Room) -> Void) -> UInt {
        let handle = roomsRef.observe(DataEventType.childAdded) { (snapshot) in
            guard var roomDict = snapshot.value as? [String: Any?] else { return }
            roomDict["roomID"] = snapshot.key
            guard let room = Models.Room(dict: roomDict) else { return }
            callback(room)
        }
        return handle
    }
    
    public static func removeRoomObserver(handle: UInt) {
        roomsRef.removeObserver(withHandle: handle)
    }
    
    public static func createRoom(_ name: String) {
        // create room in db
        guard let location = LocationManager.shared.getLocation() else { return }
        let dict: [String:Any] = ["name": name, "creatorID": Current.user!.email,
                    "timeCreated": currentTime , "numMembers": 1,
                    "latitude": location.latitude, "longitude": location.longitude]
        let newRoomRef = roomsRef.childByAutoId()
        newRoomRef.setValue(dict)
        
        // update user object in db and locally
        Current.user!.rooms[newRoomRef.key] = true
        usersRef.child("\(Current.user!.email)/rooms").setValue(Current.user!.rooms)
    }
    
    public static func joinRoom(room: Models.Room) {
        // update user object in db and locally
        Current.user!.rooms[room.roomID] = true
        usersRef.child("\(Current.user!.email)/rooms").setValue(Current.user!.rooms)
        
        // update room object in db
        roomsRef.child("\(room.roomID)/numMembers").setValue(room.numMembers+1)
    }
    
    // This function takes in an email and password and creates a user
    // If the user already exists, then it sends back a false boolean value
    // and does not add to database
    public static func createOrLoginUser(_ emailLoginText: String, _ passwordLoginText: String,_ createUser: Bool, callback: @escaping (Bool) -> Void) {
        ref.child("users/\(emailLoginText)").observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
                if snapshot.exists() {
                    if createUser {
                        callback(false) //we want success to be false when signing up
                    } else {
                        Current.user = Models.User(snapshot: snapshot)
                        callback(true) //we want success to be true when logging in
                    }
                }
                else {
                    if createUser {
                        let dict = ["email": emailLoginText]
                        self.usersRef.child(emailLoginText.lowercased()).setValue(dict)
                        Current.user = Models.User(dict: dict)
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
    public static func getMyRooms(callback: @escaping ([Models.Room]) -> Void)  {
        ref.child("users/\(Current.user!.email)/rooms").observeSingleEvent(of: .value, with: { (snapshot) in
            if (!snapshot.exists()) { return }
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
        })
    }
    
}
