//
//  DirectoryFeedViewController.swift
//  JamStart2
//
//  Created by Miklos Szabo on 8/10/17.
//  Copyright © 2017 Miklos Szabo. All rights reserved.
//

import Foundation
import UIKit

class DirectoryFeedViewController: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    
    var users = [User]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        UserService.directory { (users) in
            
            self.users = users
            
            for user in users {
                print("\(user.name) is a \(user.instrument)")
            }
            
            self.tableView.reloadData()
            
        }
        
        
    }
    

}

extension DirectoryFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicianCell") as! MusicianCell
        let musician = users[indexPath.row]
        
        cell.nameLabel.text = musician.name
        cell.instrumentLabel.text = musician.instrument
        cell.genreLabel.text = musician.genre
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //create profile vc 
        //pass a user using users[indexPath.row] into the profile VC and load it like we did for the cell
        //see notes app on connecting a cell tap to another screen 
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//       // let post = posts[indexPath.row]
//        
//       // return post.imageHeight
//        
//        return 100 // temporary
//    }
}
