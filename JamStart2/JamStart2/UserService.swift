//
//  UserService.swift
//  JamStart2
//
//  Created by Miklos Szabo on 8/9/17.
//  Copyright © 2017 Miklos Szabo. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct UserService {
    static func create(firUser: User, name: String, genre: String, instrument: String, bio: String, completion: @escaping (User?) -> Void) {
        let userAttrs = ["genre": genre, "instrument": instrument, "bio": bio, "name": name]
        
        let ref = Database.database().reference().child("users").child(firUser.uid)
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
            
            
        }
    }
    
    static func show(forUID uid: String, completion: @escaping (User?) -> Void) {
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let user = User(snapshot: snapshot) else {
                return completion(nil)
            }
            
            completion(user)
        })
    }
    
    static func directory(completion: @escaping ([User]) -> Void) {
        
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return completion([]) }
            
            var users = [User]()
            
            for userSnap in snapshot {
                if let user = User(snapshot: userSnap) {
                    users.append(user)
                }
            }
            completion(users)
        })
    }
}

