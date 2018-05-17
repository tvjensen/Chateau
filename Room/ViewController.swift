//
//  ViewController.swift
//  Room
//
//  Created by Conner Smith on 4/23/18.
//  Copyright © 2018 csmith. All rights reserved.
//

import UIKit
import Firebase
//import SkyFloatingLabelTextField

class ViewController: UIViewController {

//    @IBOutlet weak var emailLogInTextField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //fetchSession
        if let userEmail = SessionManager.fetchSession() {
            Firebase.createOrLoginUser(userEmail, " ", false) {success in //sets current user
                if success {
                    self.performSegue(withIdentifier: "loggedInSegue", sender: nil)
                } else {
                    print("Failed to use stored session to set current user.")
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    @IBAction func enterEmail(_ sender: SkyFloatingLabelTextField) {
//        if let text = emailLogInTextField.text {
//            if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
//                if(text.characters.count < 3 || !text.containsString("@")) {
//                    floatingLabelTextField.errorMessage = "Invalid email"
//                }
//                else {
//                    // The error message will only disappear when we reset it to nil or empty string
//                    floatingLabelTextField.errorMessage = ""
//                }
//            }
//        }
//    }
    
    @IBOutlet weak var emailLogin: UITextField!
    @IBOutlet weak var passwordLogin: UITextField!
    
    @IBAction func loginUser(_ sender: Any) {
        let emailLoginText : String = emailLogin.text!
        let passwordLoginText : String = passwordLogin.text!
        if emailLoginText != "" && passwordLoginText != "" {
            Firebase.createOrLoginUser(emailLoginText, passwordLoginText, false) { success in
                if success {
                    print("Success in logging in user!")
                    self.performSegue(withIdentifier: "loggedInSegue", sender: nil)
                } else {
                    print("That login and password was unsuccessful")
                }
            }
        }

    }
    //Take email login text and password text and create a user
    @IBAction func signUp(_ sender: Any) {
        let emailLoginText : String = emailLogin.text!
        let passwordLoginText : String = passwordLogin.text!
        if emailLoginText != "" && passwordLoginText != "" {
            Firebase.createOrLoginUser(emailLoginText, passwordLoginText, true) { success in
                if success {
                    print("Success in creating user!")
                    self.performSegue(withIdentifier: "loggedInSegue", sender: nil)
                } else {
                    print("That login and password was unsuccessful")
                }
            }
        }
    }
}
