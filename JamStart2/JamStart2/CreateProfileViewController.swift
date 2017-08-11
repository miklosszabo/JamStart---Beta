//
//  CreateProfileViewController.swift
//  JamStart2
//
//  Created by Miklos Szabo on 8/7/17.
//  Copyright © 2017 Miklos Szabo. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit
import FBSDKCoreKit


class CreateProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var grabURL: URL?
    
    var selectInstrument = "Guitarist"
    var selectGenre = "Rock"
    
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerView2: UIPickerView!
    @IBOutlet weak var bioTextField: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    
    
    
    
    @IBAction func createProfile(_ sender: Any) {
        print(selectInstrument)
        print(selectGenre)
        print(bioTextField.text)
        print(nameTextField.text!)
        guard let firUser = Auth.auth().currentUser,
            let name = nameTextField.text,
            let bio = bioTextField.text,
            !bio.isEmpty,
            !name.isEmpty else { return }
        
        let userAttrs = ["name": name, "genre": selectGenre, "instrument": selectInstrument, "bio": bio]
        
        // 3
        let ref = Database.database().reference().child("users").child(firUser.uid)
        
        // 4
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return
            }
            
            // 5
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                _ = User(snapshot: snapshot)
                
                // handle newly created user here
            })
        }
        
    }
    
    
    //        UserService.create(firUser: firUser, name: name, genre: genre, instrument: instrument, bio: bio) { (user) in
    //            guard let user = user else { return }
    //
    //            print("Created new user: \(user.name)")
    //        }
    
    // 2
    
    
    //    UserService.create(firUser, username: username) { (user) in
    //    guard let _ = user else {
    //    return
    //    }
    //
    //    let storyboard = UIStoryboard(name: "Main", bundle: .main)
    //
    //    if let initialViewController = storyboard.instantiateInitialViewController() {
    //    self.view.window?.rootViewController = initialViewController
    //    self.view.window?.makeKeyAndVisible()
    //    }
    //    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //if tag == 1 { execute for instrumet
        // if tag ==0 then do code for genre
        if (pickerView.tag == 1) {
            selectInstrument = instrument[row]
        } else /* if (pickerView.tag == 0)*/ {
            selectGenre = genre[row]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePicture.layer.borderWidth = 1
        profilePicture.layer.masksToBounds = false
        profilePicture.layer.borderColor = UIColor.black.cgColor
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
        profilePicture.clipsToBounds = true
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView2.delegate = self
        pickerView2.dataSource = self
        
    }
    
    func getFBUserData() {
        let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, picture.type(large)"])
        let _ = request?.start(completionHandler: { (connection, result, error) in
            guard let userInfo = result as? [String: Any] else { return } //handle the error
            
            
            //The url is nested 3 layers deep into the result so it’s pretty messy
            if let imageURL = ((userInfo["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                print(imageURL)//Download image from imageURL
                if let checkedUrl = URL(string: imageURL) {
                    self.grabURL = checkedUrl
                    self.profilePicture.contentMode = .scaleAspectFit
                    self.downloadImage(url: checkedUrl)
                }
            }
        })
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBAction func importProfilePicture(_ sender: Any) {
        getFBUserData()
    }
    
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                self.profilePicture.image = UIImage(data: data)
            }
        }
    }
    
    
    var instrument = ["Guitarist", "Drummer", "Bassist", "Pianist", "Singer", "Emcee", "Violinst", "Saxophonist",  "Trumpeter", "Flutist", "Celloist"]
    
    var genre = ["Rock", "Jazz", "R&B", "Hip-Hop", "Soul", "EDM", "Folk", "Classical", "Pop", "Reggae", "Blues", "Country", "Funk"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 1) {
            return instrument.count
        } else {
            return genre.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 1) {
            return instrument[row]
        } else {
            return genre[row]
        }
    }
}
