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
        emailLogin.delegate = self
        passwordLogin.delegate = self
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
        let emailLoginText: String = emailLogin.text!
        let passwordLoginText: String = passwordLogin.text!
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
        if ViewController.isValidEmail(email: emailLoginText) && passwordLoginText != "" {
            Firebase.registerUser(emailLoginText, passwordLoginText) { success in
                if success { // successfully registered user, let them know to confirm email
                    let alertController = UIAlertController(title: "Success", message: "You have been sent an email confirmation link. Please confirm your email to login.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                } else { // an error occurred, could not successfully register
                    let alertController = UIAlertController(title: "Error", message: "An error occurred while registering. Please try again later.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        } else { // either invalid stanford email or blank password
            let alertController = UIAlertController(title: "Error", message: "Please enter a valid stanford.edu email and password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    static func isValidEmail(email: String) -> Bool {
        let emailPattern = "[A-Z0-9a-z._%+-]+@stanford\\.edu"
        return NSPredicate(format: "SELF MATCHES %@", emailPattern).evaluate(with:email.lowercased())
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
