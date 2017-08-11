//
//  ViewController.swift
//  JamStart2
//
//  Created by Miklos Szabo on 8/7/17.
//  Copyright © 2017 Miklos Szabo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseAuthUI
import FirebaseFacebookAuthUI
import FirebaseDatabase

typealias FIRUser = FirebaseAuth.User
let user: FIRUser? = Auth.auth().currentUser


class LoginViewController: UIViewController, FUIAuthDelegate {
    
    
    
    //MARK: - INITIALIZATION
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: - SIGN IN / SIGN UP
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let authUI = FUIAuth.defaultAuthUI()
            else { return }
        
        authUI.delegate = self
        
        // configure Auth UI for Facebook login
        let providers: [FUIAuthProvider] = [FUIFacebookAuth()]
        authUI.providers = providers
        
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
    }
    
    
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        print("Signed In")
        if let error = error {
            assertionFailure("Error signing in: \(error.localizedDescription)")
            return
        }
        
        // 1
        guard let user = user
            else { return }
        
        // 2
        let userRef = Database.database().reference().child("users").child(user.uid)
        
        userRef.observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
            if let user = User(snapshot: snapshot) {
                print("Welcome back, \(user.name).")
            } else {
                self.performSegue(withIdentifier: Constants.Segue.toCreateProfile, sender: self)
            }
        })
        
//        let storyboard = UIStoryboard(name: "Login", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "CreateProfile")
//        self.present(controller, animated: true, completion: nil)
    }
    
}
