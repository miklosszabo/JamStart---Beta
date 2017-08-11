//
//  User.swift
//  JamStart2
//
//  Created by Miklos Szabo on 8/9/17.
//  Copyright © 2017 Miklos Szabo. All rights reserved.
//

import Foundation
import Foundation
import FirebaseDatabase.FIRDataSnapshot

class User: NSObject {
    
    
    let uid: String
    let name: String
    let genre: String
    let instrument: String
    let bio: String
    
    init(uid: String, name: String,genre: String, instrument: String, bio: String) {
        self.uid = uid
        self.name = name
        self.genre = genre
        self.instrument = instrument
        self.bio = bio
        super.init()
    }
    
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let name = dict["name"] as? String,
            let genre = dict["genre"] as? String,
            let instrument = dict["instrument"] as? String,
            let bio = dict["bio"] as? String
            
            else { return nil }
        
        self.uid = snapshot.key
        self.name = name
        self.genre = genre
        self.instrument = instrument
        self.bio = bio
        super.init()
    }


    required init?(coder aDecoder: NSCoder) {
        guard let uid = aDecoder.decodeObject(forKey: Constants.UserDefaults.uid) as? String,
            let name = aDecoder.decodeObject(forKey: Constants.UserDefaults.name) as? String,
            let genre = aDecoder.decodeObject(forKey: Constants.UserDefaults.genre) as? String,
            let instrument = aDecoder.decodeObject(forKey: Constants.UserDefaults.instrument) as? String,
            let bio = aDecoder.decodeObject(forKey: Constants.UserDefaults.bio) as? String
            else { return nil }
        
        self.uid = uid
        self.name = name
        self.genre = genre
        self.instrument = instrument
        self.bio = bio
        super.init()
    }
    
    // MARK: - Singleton
    
    // 1
    private static var _current: User?
    
    // 2
    static var current: User {
        // 3
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        
        // 4
        return currentUser
    }
    
    // 1
    class func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        // 2
        if writeToUserDefaults {
            // 3
            let data = NSKeyedArchiver.archivedData(withRootObject: user)
            
            // 4
            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
        }
        
        _current = user
    }
    
    
}
extension User: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: Constants.UserDefaults.uid)
        aCoder.encode(name, forKey: Constants.UserDefaults.name)
        aCoder.encode(genre, forKey: Constants.UserDefaults.name)
        aCoder.encode(instrument, forKey: Constants.UserDefaults.instrument)
        aCoder.encode(bio, forKey: Constants.UserDefaults.bio)
    }
}
