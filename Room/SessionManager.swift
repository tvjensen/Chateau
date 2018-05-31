//
//  SessionManager.swift
//  Room
//
//  Created by Thomas Jensen on 5/16/18.
//  Copyright © 2018 csmith. All rights reserved.
//

import Foundation
//import Alamofire

final class SessionManager {
    
    private static let userDefaults = UserDefaults.standard
    public static var session: String! {
        didSet {
            let sessionData = NSKeyedArchiver.archivedData(withRootObject: session)
            self.userDefaults.set(sessionData, forKey: "userEmail")
            self.userDefaults.synchronize()
        }
    }
    
    public static func storeSession(session: String) {
        let sessionData = NSKeyedArchiver.archivedData(withRootObject: session)
        userDefaults.set(sessionData, forKey: "userEmail")
        self.session = session
        NotificationCenter.default.post(name: Notification.Name("loginSuccessful"), object: nil)
    }
    
    public static func tryFetchingStoredUser(callback: @escaping (Bool) -> Void) {
        if let email = fetchSession() {
            Firebase.fetchUser(email, callback: callback)
        } else {
            callback(false)
        }
    }
    
    private static func fetchSession() -> String? {
        if let sessionData = userDefaults.object(forKey: "userEmail") as? Data {
            self.session = NSKeyedUnarchiver.unarchiveObject(with: sessionData) as? String
            return session
        }
        return nil
    }
    
    public static func refreshState() {
        self.session = nil
    }
}
