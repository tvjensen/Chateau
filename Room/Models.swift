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
        var rooms: [String: Bool] = [:]

        var firebaseDict: [String : Any] {
            let dict: [String: Any] = [
                                        "rooms": self.rooms
                                       ]
            return dict
        }
    
        init?(dict: [String: Any?]) {
            guard let email = dict["email"] as? String else { return nil }
            self.rooms = dict["rooms"] as? [String: Bool] ?? [:]
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
        
        var firebaseDict: [String : Any] {
            let dict: [String: Any] = ["roomID": self.roomID,
                                       "creatorID": self.creatorID,
                                       "timeCreated":self.timeCreated,
                                       "latitude": self.latitude,
                                       "longitude": self.longitude,
                                       "name": self.name,
                                       "numMembers": self.numMembers
                                       ]
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
            
            self.roomID = roomID
            self.creatorID = creatorID
            self.timeCreated = timeCreated
            self.latitude = latitude
            self.longitude = longitude
            self.name = name
            self.numMembers = numMembers
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
        var timestamp: Double
        
        var firebaseDict: [String : Any] {
            let dict: [String: Any] = ["postID": self.postID,
                                       "roomID": self.roomID,
                                       "body":self.body,
                                       "posterID": self.posterID,
                                       "upvoters": self.upvoters,
                                       "timestamp": self.timestamp
                                       ]
            return dict
        }
        
        init?(dict: [String: Any?]) {
            guard let postID = dict["postID"] as? String else { return nil }
            guard let roomID = dict["roomID"] as? String else { return nil }
            guard let body = dict["body"] as? String else { return nil }
            guard let posterID = dict["posterID"] as? String else { return nil }
            guard let timestamp = dict["timestamp"] as? Double else { return nil }
            
            self.postID = postID
            self.roomID = roomID
            self.body = body
            self.posterID = posterID
            self.timestamp = timestamp
            self.upvoters = dict["upvoters"] as? [String: Bool] ?? [:]
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
        var posterEmail: String
        var upvoters: [String: Bool] = [:]
        var timestamp: Double
        
        var firebaseDict: [String : Any] {
            let dict: [String: Any] = ["commentID": self.postID,
                                       "postID": self.postID,
                                       "body":self.body,
                                       "posterEmail": self.posterEmail,
                                       "upvoters": self.upvoters,
                                       "timestamp": self.timestamp,
            ]
            return dict
        }
        
        init?(dict: [String: Any?]) {
            guard let commentID = dict["commentID"] as? String else { return nil }
            guard let postID = dict["postID"] as? String else { return nil }
            guard let body = dict["body"] as? String else { return nil }
            guard let posterEmail = dict["posterEmail"] as? String else { return nil }
            guard let timestamp = dict["timestamp"] as? Double else { return nil }
            
            self.commentID = commentID
            self.postID = postID
            self.body = body
            self.posterEmail = posterEmail
            self.timestamp = timestamp
            self.upvoters = dict["upvoters"] as? [String: Bool] ?? [:]
        }
        
    }
}



