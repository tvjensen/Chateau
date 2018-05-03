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

    struct FirebaseUser {
        var userID: String
        var email: String
        var rooms: [String: Bool] = [:]

        var firebaseDict: [String : Any] {
            let dict: [String: Any] = ["userID": self.userID,
                                       "email":self.email,
                                       "rooms": self.rooms,
                                       ]
            return dict
        }
    
        init?(dict: [String: Any?]) {
            guard let userID = dict["userID"] as? String else { return nil }
            guard let email = dict["email"] as? String else { return nil }
            
            self.userID = userID
            self.email = email
            self.rooms = dict["rooms"] as? [String: Bool] ?? [:]
        }
    }
    
    struct FirebaseRoom {
        var roomID: String
        var timeCreated: Double
        var location: String
        var posts: [String: Bool] = [:]
        
        var firebaseDict: [String : Any] {
            let dict: [String: Any] = ["roomID": self.roomID,
                                       "timeCreated":self.timeCreated,
                                       "location": self.location,
                                       "posts": self.posts,
                                       ]
            return dict
        }
        
        init?(dict: [String: Any?]) {
            guard let roomID = dict["roomID"] as? String else { return nil }
            guard let timeCreated = dict["timeCreated"] as? Double else { return nil }
            guard let location = dict["location"] as? String else { return nil }
            
            self.roomID = roomID
            self.timeCreated = timeCreated
            self.location = location
            self.posts = dict["posts"] as? [String: Bool] ?? [:]
        }
    }
    
    struct FirebasePosts {
        var postID: String
        var body: String
        var posterEmail: String
        var upvoters: [String: Bool] = [:]
        var timestamp: Double?
        var comment: Bool
        var comments: [String: Bool] = [:]
        
        var firebaseDict: [String : Any] {
            var dict: [String: Any] = ["postID": self.postID,
                                       "body":self.body,
                                       "posterEmail": self.posterEmail,
                                       "upvoters": self.upvoters,
                                       "timestamp": self.timestamp,
                                       "comment": self.comment,
                                       "comments": self.comments,
                                       ]
            return dict
        }
        
        init?(dict: [String: Any?]) {
            guard let postID = dict["postID"] as? String else { return nil }
            guard let body = dict["body"] as? String else { return nil }
            guard let posterEmail = dict["posterEmail"] as? String else { return nil }
            guard let timestamp = dict["timestamp"] as? Double else { return nil }
            guard let comment = dict["comment"] as? Bool else { return nil }
            
            self.postID = postID
            self.body = body
            self.posterEmail = posterEmail
            self.timestamp = timestamp
            self.comment = comment
            self.upvoters = dict["upvoters"] as? [String: Bool] ?? [:]
            self.comments = dict["comments"] as? [String: Bool] ?? [:]
        }
        
    }
}



