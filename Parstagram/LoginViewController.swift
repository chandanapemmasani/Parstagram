//
//  LoginViewController.swift
//  Parstagram
//
//  Created by Chandana Pemmasani on 10/6/21.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var userNameField: UITextField!
    
    
    @IBOutlet weak var passwordField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func signupAction(_ sender: Any) {
        
        let user = PFUser()
        user.username = userNameField.text
        user.password = userNameField.text
        
        user.signUpInBackground{ (success, error) in
            if success {
                self.performSegue(withIdentifier: "loginSegueway", sender: nil)
            } else {
                print("error:\(error?.localizedDescription)")
            }
        }
         
    }
    @IBAction func signinAction(_ sender: Any) {
        
        let username = userNameField.text!
        let password = userNameField.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password)
        { (user, error) in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegueway", sender: nil)
            } else {
                print("error:\(error?.localizedDescription)")
            }
        }
    }
}
