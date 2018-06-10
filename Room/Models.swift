//
//  Models.swift
//  Room
//
//  Created by Thomas Jensen on 5/3/18.
//  Copyright © 2018 csmith. All rights reserved.
//

import Foundation
import Firebase

class Models {

    /*
     Relation for User. Key is userID. Email for login and verification.
     Rooms is contains all the roomIDs of rooms of which this user has partaken.
     */
    struct User {
        var email: String
        var rooms: [String: Double] = [:]   // RoomID -> Last visit timestamp
        var hidden: [String: Double] = [:]
        var firebaseDict: [String : Any] {
            let dict: [String: Any] = [
                                        "rooms": self.rooms,
                                        "hidden": self.hidden
                                       ]
            return dict
        }
    
        init?(dict: [String: Any?]) {
            guard let email = dict["email"] as? String else { return nil }
            self.rooms = dict["rooms"] as? [String: Double] ?? [:]
            self.hidden = dict["hidden"] as? [String: Double] ?? [:]
            self.email = email
        }
        
        init?(snapshot: DataSnapshot) {
            guard var dict = snapshot.value as? [String: Any?] else { return nil }
            dict["email"] = snapshot.key
            self.init(dict: dict)
        }
    }

    /*
     Relation for room object. Key is roomID. Note that this only stores metadata about the room,
     for better scaling and UI. Another query must be made to get a room's associated posts.
     */
    struct Room {
        var roomID: String
        var name: String
        var creatorID: String
        var timeCreated: Double
        var latitude: Double
        var longitude: Double
        var numMembers: Int
        var lastActivity: Double
        
        var firebaseDict: [String : Any] {
            let dict: [String: Any] = ["roomID": self.roomID,
                                       "creatorID": self.creatorID,
                                       "timeCreated":self.timeCreated,
                                       "latitude": self.latitude,
                                       "longitude": self.longitude,
                                       "name": self.name,
                                       "numMembers": self.numMembers,
                                       "lastActivity": self.lastActivity]
            return dict
        }
        
        init?(dict: [String: Any?]) {
            guard let roomID = dict["roomID"] as? String else { return nil }
            guard let creatorID = dict["creatorID"] as? String else { return nil }
            guard let timeCreated = dict["timeCreated"] as? Double else { return nil }
            guard let latitude = dict["latitude"] as? Double else { return nil }
            guard let longitude = dict["longitude"] as? Double else { return nil }
            guard let name = dict["name"] as? String else { return nil }
            guard let numMembers = dict["numMembers"] as? Int else { return nil }
            guard let lastActivity = dict["lastActivity"] as? Double else { return nil }

            
            self.roomID = roomID
            self.creatorID = creatorID
            self.timeCreated = timeCreated
            self.latitude = latitude
            self.longitude = longitude
            self.name = name
            self.numMembers = numMembers
            self.lastActivity = lastActivity
        }
    }
    
    /*
     Relation for Post object. Key is postId. Contains metadata for a post. Note that upvoters is a
     nested dict entity within this relation. This is justified because the number of unique upvoters
     is metadata that needs to be displayed for each room before a user even joins a room.
     */
    struct Post {
        var postID: String
        var roomID: String
        var body: String
        var posterID: String
        var upvoters: [String: Bool] = [:]
        var downvoters: [String: Bool] = [:]
        var netVotes: Int
        var timestamp: Double
        var lastActivity: Double
        
        var firebaseDict: [String : Any] {
            let dict: [String: Any] = ["postID": self.postID,
                                       "roomID": self.roomID,
                                       "body":self.body,
                                       "posterID": self.posterID,
                                       "upvoters": self.upvoters,
                                       "timestamp": self.timestamp,
                                       "downvoters": self.downvoters,
                                       "netVotes": self.netVotes,
                                       "lastActivity": self.lastActivity
                                       ]
            return dict
        }
        
        init?(dict: [String: Any?]) {
            guard let postID = dict["postID"] as? String else { return nil }
            guard let roomID = dict["roomID"] as? String else { return nil }
            guard let body = dict["body"] as? String else { return nil }
            guard let posterID = dict["posterID"] as? String else { return nil }
            guard let timestamp = dict["timestamp"] as? Double else { return nil }
            guard let netVotes = dict["netVotes"] as? Int else { return nil }
            guard let lastActivity = dict["lastActivity"] as? Double else { return nil }
            
            self.postID = postID
            self.roomID = roomID
            self.body = body
            self.posterID = posterID
            self.timestamp = timestamp
            self.upvoters = dict["upvoters"] as? [String: Bool] ?? [:]
            self.downvoters = dict["downvoters"] as? [String: Bool] ?? [:]
            self.netVotes = netVotes
            self.lastActivity = lastActivity
        }
        
    }
    

    
    /* Relation for comment object. Key is commentID. Note that upvoters is a nested dict entity.
     This is justified because the number of unique upvoters is data that needs to be
     displayed for each comment in a list display.
     */
    struct Comment {
        var commentID: String
        var postID: String
        var body: String
        var posterID: String
        var upvoters: [String: Bool] = [:]
        var downvoters: [String: Bool] = [:]
        var timestamp: Double
        
        var firebaseDict: [String : Any] {
            let dict: [String: Any] = ["commentID": self.postID,
                                       "postID": self.postID,
                                       "body":self.body,
                                       "posterID": self.posterID,
                                       "upvoters": self.upvoters,
                                       "timestamp": self.timestamp,
                                       "downvoters": self.downvoters,
            ]
            return dict
        }
        
        init?(dict: [String: Any?]) {
            guard let commentID = dict["commentID"] as? String else { return nil }
            guard let postID = dict["postID"] as? String else { return nil }
            guard let body = dict["body"] as? String else { return nil }
            guard let posterID = dict["posterID"] as? String else { return nil }
            guard let timestamp = dict["timestamp"] as? Double else { return nil }
            
            self.commentID = commentID
            self.postID = postID
            self.body = body
            self.posterID = posterID
            self.timestamp = timestamp
            self.upvoters = dict["upvoters"] as? [String: Bool] ?? [:]
            self.downvoters = dict["downvoters"] as? [String: Bool] ?? [:]
        }
        
    }
}

let MAX_DAYS = 3

func postSort (lhs: Models.Post, rhs: Models.Post) -> Bool {
    // TODO: I HAVENT REALLY TESTED THE 3 DAY THING BUT IT SHOULD WORK
    // See how many days old each post is
    // Get the current time in Date()
    let curTime = Date()
    // Get the time of the posts in terms of Date(), i.e. convert from seconds to Date()
    let postedTime0 = Date(timeIntervalSince1970: lhs.timestamp)
    let postedTime1 = Date(timeIntervalSince1970: rhs.timestamp)
    // Find the difference between the two dates
    let components0 = Calendar.current.dateComponents([.day], from: postedTime0, to: curTime)
    let components1 = Calendar.current.dateComponents([.day], from: postedTime1, to: curTime)
    // if both posts are more than 3 days old or if both of them are less than 3 days old
    if(components0.day! <= MAX_DAYS && components1.day! <= MAX_DAYS) || (components1.day! > MAX_DAYS && components1.day! > MAX_DAYS){
        // compare votes
        if lhs.netVotes == rhs.netVotes{
            return lhs.timestamp > rhs.timestamp
        } else{
            return lhs.netVotes > rhs.netVotes
        }
    } else{
        // This means one of the posts is older and the other is not
        // The older one gets to go later
        if(components0.day! > MAX_DAYS){
            return false
        } else{
            return true
        }
    }
}

func commentSort(lhs: Models.Comment, rhs: Models.Comment) -> Bool {
    return lhs.timestamp > rhs.timestamp
}




