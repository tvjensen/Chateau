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
        print("Loaded view")
        // Do any additional setup after loading the view, typically from a nib.
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
    
    
    //Take email login text and password text and create a user
    @IBAction func signUp(_ sender: Any) {
        let emailLoginText : String = emailLogin.text!
        let passwordLoginText : String = passwordLogin.text!
        if emailLoginText != "" && passwordLoginText != "" {
            print(emailLoginText)
            print(passwordLoginText)
//            var ref: DatabaseReference!
//
//            ref = Database.database().reference()
            
            Firebase.createUser(emailLoginText, passwordLoginText) { success in
                if success {
                    print("Success in creating user!")
                } else {
                    print("That login and password was unsuccessful")
                }
            }
        }
    }
}
