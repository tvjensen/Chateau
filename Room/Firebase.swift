//
//  Firebase.swift
//  Room
//
//  Created by Conner Smith on 5/3/18.
//  Copyright © 2018 csmith. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class Firebase {
    
    // use this to interact with db
    private static let ref = Database.database().reference()
    private static let roomsRef = ref.child("rooms")
    private static let usersRef = ref.child("users")
    private static let postsRef = ref.child("Posts")
    private static let commentsRef = ref.child("comments")
    private static let reportsRef = ref.child("reports")
    
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
    
    public static func fetchPosts(_ room: Models.Room, callback: @escaping ([Models.Post]) -> Void) {
        roomsRef.child("\(room.roomID)/posts").observeSingleEvent(of: .value, with: { (snapshot) in
            if (!snapshot.exists()) { return }
            let enumerator = snapshot.children // to iterate through room IDS associated with this user
            var posts: [Models.Post] = [] // array to be returned
            let dispatchGroup = DispatchGroup()
            while let r = enumerator.nextObject() as? DataSnapshot { // for each roomID, fetch room object from DB
                dispatchGroup.enter()
                postsRef.child("\(r.key)").observeSingleEvent(of: .value, with: { (snapshot) in
                    var dict = snapshot.value as! [String : Any?]
                    dict["postID"] = r.key
                    if let post = Models.Post(dict: dict) {
                        posts.append(post) // add to result
                    }
                    dispatchGroup.leave()
                })
            }
            
            dispatchGroup.notify(queue: .main) {
                callback(posts)
            }
        })
    }
    
    public static func fetchComments(_ post: Models.Post, callback: @escaping ([Models.Comment]) -> Void) {
        postsRef.child("\(post.postID)/comments").observeSingleEvent(of: .value, with: { (snapshot) in
            if (!snapshot.exists()) { return }
            let enumerator = snapshot.children // to iterate through room IDS associated with this user
            var comments: [Models.Comment] = [] // array to be returned
            let dispatchGroup = DispatchGroup()
            while let r = enumerator.nextObject() as? DataSnapshot { // for each roomID, fetch room object from DB
                dispatchGroup.enter()
                commentsRef.child("\(r.key)").observeSingleEvent(of: .value, with: { (snapshot) in
                    var dict = snapshot.value as! [String : Any?]
                    dict["commentID"] = r.key
                    if let comment = Models.Comment(dict: dict) {
                        comments.append(comment) // add to result
                    }
                    dispatchGroup.leave()
                })
            }
            
            dispatchGroup.notify(queue: .main) {
                callback(comments)
            }
        })
    }
    
    public static func createPost(_ roomID:String, _ body:String){
        let ref = postsRef.childByAutoId()
        postsRef.child(ref.key).setValue(["roomID": roomID,
                                            "body": body,
                                            "posterID": Current.user!.email,
                                            "timestamp": currentTime,
                                            "netVotes": 0,
                                            "lastActivity": currentTime])
        roomsRef.child("\(roomID)/posts/\(ref.key)").setValue(true)
        roomsRef.child("\(roomID)/lastActivity").setValue(currentTime)
    }
    
    public static func createComment(_ roomID:String, _ postID:String, _ body:String){
        
        let ref = commentsRef.childByAutoId()
        commentsRef.child(ref.key).setValue(["postID": postID,
                                          "body": body,
                                          "posterID": Current.user!.email,
                                          "timestamp": currentTime])
        postsRef.child("\(postID)/comments/\(ref.key)").setValue(true)
        roomsRef.child("\(roomID)/lastActivity").setValue(currentTime)
        postsRef.child("\(roomID)/lastActivity").setValue(currentTime)
    }
    
    public static func createRoom(_ name: String, callback: @escaping (Models.Room) -> Void) {
        // create room in db
        guard let location = LocationManager.shared.getLocation() else { return }
        var dict: [String:Any] = ["name": name, "creatorID": Current.user!.email,
                    "timeCreated": currentTime , "numMembers": 1,
                    "latitude": location.latitude, "longitude": location.longitude, "lastActivity": currentTime]
        let newRoomRef = roomsRef.childByAutoId()
        newRoomRef.setValue(dict)
        
        // update user object in db and locally
        Current.user!.rooms[newRoomRef.key] = currentTime
        usersRef.child("\(Current.user!.email)/rooms").setValue(Current.user!.rooms)
        dict["roomID"] = newRoomRef.key
        callback(Models.Room(dict:dict)!)
    }
    
    public static func joinRoom(room: Models.Room) {
        // update user object in db and locally
        Current.user!.rooms[room.roomID] = currentTime
        usersRef.child("\(Current.user!.email)/rooms").setValue(Current.user!.rooms)
        
        // update room object in db
        roomsRef.child("\(room.roomID)/numMembers").setValue(room.numMembers+1)
    }
    
    public static func leaveRoom(room: Models.Room) {
        // update user object in db and locally
        Current.user!.rooms.removeValue(forKey: room.roomID)
        usersRef.child("\(Current.user!.email)/rooms").setValue(Current.user!.rooms)
        
        // update room object in db
        roomsRef.child("\(room.roomID)/numMembers").setValue(room.numMembers-1)
    }
    
    // This function takes in an email and password and creates a user
    // If the user already exists, then it sends back a false boolean value
    // and does not add to database
    public static func fetchUser(_ emailLoginText: String, callback: @escaping (Bool) -> Void) {
        usersRef.child("\(emailLoginText)").observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
                if snapshot.exists() {
                    Current.user = Models.User(snapshot: snapshot)
                    callback(true)
                } else {
                    callback(false)
                }
            })
    }
    
    /* Logs in user by authenticating if they exist/have correct password. Returns true on success.
     TODO: change this to return error
     */
    public static func loginUser(_ emailLoginText: String, _ passwordLoginText: String, callback: @escaping (Bool) -> Void) {
        // Firebase does not accept certain tokens such as '.' so we must encode emails by replacing dots with commas. tvjensen@stanford.edu becomes tvjensen@stanford,edu
        let validEmailLoginText =  emailLoginText.replacingOccurrences(of: ".", with: ",")
        Auth.auth().signIn(withEmail: emailLoginText.lowercased(), password: passwordLoginText) { (user, error) in
            if error == nil && (user?.isEmailVerified)! { // successfully logged in user AND user has already verified email
                print("Successful login")
                usersRef.child("\(validEmailLoginText)").observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
                    if snapshot.exists() {
                        Current.user = Models.User(snapshot: snapshot) // get user metadata from DB
                        SessionManager.storeSession(session: validEmailLoginText) // store sesh to stay logged in
                        callback(true)
                    } else {
                        callback(false)
                    }
                })
            } else { // user not found or password wrong
                // TODO: sign out user if they exist but haven't verified email?
                callback(false)
            }
        }
    }
    
    /* Registers user by creating a user instance in both the Firebase Auth and database.
     Returns true on success.
    */
    public static func registerUser(_ emailLoginText: String, _ passwordLoginText: String, callback: @escaping (Bool) -> Void) {
        // create this user Auth object (Firebase will handle salting/hashing/store the password server side
        Auth.auth().createUser(withEmail: emailLoginText.lowercased(), password: passwordLoginText) { (user, error) in
            if error == nil { // successfully created user in auth
                user?.sendEmailVerification(completion: { (error) in
                    if let error = error { // failed to send email, return false
                        print(error.localizedDescription)
                        callback(false)
                    }
                    print("Sent email verification")
                    // Firebase does not accept certain tokens such as '.' so we must encode emails by replacing dots with commas. tvjensen@stanford.edu becomes tvjensen@stanford,edu
                    let validEmailLoginText =  emailLoginText.replacingOccurrences(of: ".", with: ",")
                    // we have to create a user object for this user in the db (not in auth, which we already did with createUser( )
                    
                    usersRef.child("\(validEmailLoginText)").observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
                        if snapshot.exists() {
                            callback(false)
                        } else {
                            let dict = ["email": validEmailLoginText]
                            self.usersRef.child(validEmailLoginText.lowercased()).setValue(dict) // update email for this user in the db
                            // TODO: remove password field from Models.User.
//                            Current.user = Models.User(dict: dict)
                            callback(true)
                        }
                    })
                })
            } else {
                callback(false)
            }
        }
    }

    public static func deleteCurrentUser(password: String, callback: @escaping (Bool) -> Void) {
        let userID = Current.user!.email
        usersRef.child(userID).removeValue { (error, refer) in
            if error != nil {
                print(error as Any)
            } else {
                print(refer)
                print("User Removed Correctly")

            }
        }
        let email = (Current.user?.email)!.replacingOccurrences(of: ",", with: ".")
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil { // correct old password, can update
                user?.delete { error in
                    if error != nil {
                        print("Failed to delete account")
                        callback(false)
                    } else {
                        print("Successfully deleted account")
                        callback(true)
                    }
                }
            } else {
                callback(false)
            }
        }
    }
    
    public static func updateLastRoomVisit(_ roomID: String) {
        usersRef.child("\(Current.user!.email)/rooms/\(roomID)").setValue(currentTime)
    }
    
    public static func upvote(_ postID: String, _ upvoters: inout [String:Bool], _ netVotes: Int) {
        let userID = Current.user!.email
        upvoters[userID] = true
        postsRef.child("\(postID)/upvoters").setValue(upvoters)
        postsRef.child("\(postID)/netVotes").setValue(netVotes)
    }
    
    public static func downvote(_ postID: String, _ downvoters: inout [String:Bool], _ netVotes: Int) {
        let userID = Current.user!.email
        downvoters[userID] = true
        postsRef.child("\(postID)/downvoters").setValue(downvoters)
        postsRef.child("\(postID)/netVotes").setValue(netVotes)
        
    }
    
    public static func removeUpvote(_ postID: String, _ upvoters: inout [String:Bool], _ netVotes: Int) {
        let userID = Current.user!.email
        upvoters.removeValue(forKey: userID)
        postsRef.child("\(postID)/upvoters").setValue(upvoters)
        postsRef.child("\(postID)/netVotes").setValue(netVotes)

    }
    
    public static func removeDownvote(_ postID: String, _ downvoters: inout [String:Bool], _ netVotes: Int) {
        let userID = Current.user!.email
        downvoters.removeValue(forKey: userID)
        postsRef.child("\(postID)/downvoters").setValue(downvoters)
        postsRef.child("\(postID)/netVotes").setValue(netVotes)
    }
    
    public static func commentUpvote(_ commentID: String, _ upvoters: inout [String:Bool]) {
        let userID = Current.user!.email
        upvoters[userID] = true
        commentsRef.child("\(commentID)/upvoters").setValue(upvoters)
    }
    
    public static func commentDownvote(_ commentID: String, _ downvoters: inout [String:Bool]) {
        let userID = Current.user!.email
        downvoters[userID] = true
        commentsRef.child("\(commentID)/downvoters").setValue(downvoters)
    }
    
    public static func commentRemoveUpvote(_ commentID: String, _ upvoters: inout [String:Bool]) {
        let userID = Current.user!.email
        upvoters.removeValue(forKey: userID)
        commentsRef.child("\(commentID)/upvoters").setValue(upvoters)
    }
    
    public static func commentRemoveDownvote(_ commentID: String, _ downvoters: inout [String:Bool]) {
        let userID = Current.user!.email
        downvoters.removeValue(forKey: userID)
        commentsRef.child("\(commentID)/downvoters").setValue(downvoters)
    }
    
    /*
     Given userID, returns all rooms for which userID is a participant.
     */
    public static func getMyRooms(callback: @escaping ([Models.Room]) -> Void)  {
        usersRef.child("\(Current.user!.email)/rooms").observeSingleEvent(of: .value, with: { (snapshot) in
            if (!snapshot.exists()) { return }
            let enumerator = snapshot.children // to iterate through room IDS associated with this user
            var rooms: [Models.Room] = [] // array to be returned
            let dispatchGroup = DispatchGroup()
            while let r = enumerator.nextObject() as? DataSnapshot { // for each roomID, fetch room object from DB
                dispatchGroup.enter()
                roomsRef.child(r.key).observeSingleEvent(of: .value, with: { (room_snapshot) in
                    print(r.key)
                    var dict = room_snapshot.value as! [String : Any?]
                    print(r.key)
                    dict["roomID"] = r.key
                    if let room = Models.Room(dict: dict) { // cast to Room
                        rooms.append(room) // add to result
                    }
                    dispatchGroup.leave()
                })
            }
            dispatchGroup.notify(queue: .main) {
                callback(rooms)
            }
        })
    }

    public static func updatePassword(oldPassword: String, newPassword: String, callback: @escaping (Bool) -> Void) {
        let email = (Current.user?.email)!.replacingOccurrences(of: ",", with: ".")
        Auth.auth().signIn(withEmail: email, password: oldPassword) { (user, error) in
            if error == nil { // correct old password, can update
                user?.updatePassword(to: newPassword) { (error) in
                    if error == nil {
                        print("Successfully update password")
                        callback(true)
                    } else {
                        print("Failed to update password")
                        callback(false)
                    }
                }
            } else { // password incorrect, return false
                callback(false)
            }
        }
    }

    public static func report(reportType: String, reporterID: String, reportedContentID: String, posterID: String, report: String) {
        let dict: [String:Any] = ["reportType": reportType, "reporterID": reporterID,
                                  "reportedContentID": reportedContentID , "posterID": posterID,
                                  "report": report, "timeReported": currentTime]
        let newReportRef = reportsRef.childByAutoId()
        newReportRef.setValue(dict)
    
    }
    
}

