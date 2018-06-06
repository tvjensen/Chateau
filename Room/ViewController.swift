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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // try to fetch stored session
        SessionManager.tryFetchingStoredUser() { foundUser in
            if foundUser {
                self.performSegue(withIdentifier: "loggedInSegue", sender: nil)
            } else {
                // un-hide the login elements
                self.emailLogin.isHidden = false
                self.passwordLogin.isHidden = false
                self.loginButton.isHidden = false
                self.signUpButton.isHidden = false
                self.forgotPasswordButton.isHidden = false
            }
        }
        
        emailLogin.delegate = self
        passwordLogin.delegate = self
        passwordLogin.isSecureTextEntry = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet var loginButton: UIButton!
    @IBOutlet weak var emailLogin: UITextField!
    @IBOutlet weak var passwordLogin: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    
    
    @IBAction func forgotPassword(_ sender: Any) {
        let alertError = UIAlertController(title: "Something went wrong", message: "We were unable to send your reset email. Please make sure your email is associated with an exisiting account and that you entered your email correctly.", preferredStyle: UIAlertControllerStyle.alert)
        alertError.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { [weak alertError] (_) in
        }))
        alertError.view.tintColor = UIColor.flatMint
        
        let alert = UIAlertController(title: "Forgot Password", message: "We can reset your password and send an email to you with further instructions.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Your email"
        })
        alert.addAction(UIAlertAction(title: "Send email", style: UIAlertActionStyle.default, handler: { [weak alert] (_) in
            Firebase.resetPassword(email: (alert?.textFields![0].text)!) { (success) in
                if (!success) {
                    print("Error reseting password", success)
                    self.present(alertError, animated: true, completion: nil)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Nevermind", style: UIAlertActionStyle.default, handler: { [weak alert] (_) in
        }))
        alert.view.tintColor = UIColor.flatMint
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func loginUser(_ sender: Any) {
        let emailLoginText: String = emailLogin.text!
        let passwordLoginText: String = passwordLogin.text!
        // don't need to validate stanford.edu here, auth will just find no account with that email
        if emailLoginText != "" && passwordLoginText != "" { // non-empty, attempt login
            Firebase.loginUser(emailLoginText.lowercased(), passwordLoginText) { success in
                if success { // successful login, session stored, can segue
                    print("Success in logging in user!")
                    self.performSegue(withIdentifier: "loggedInSegue", sender: nil)
                } else { // failed to login because of invalid user or password
                    let alertController = UIAlertController(title: "Error", message: "Invalid email or password. Please confirm your email if you have not confirmed already.", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    alertController.view.tintColor = UIColor.flatMint
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        } else { // invalid text entry. TODO: change this to floating sky text or whatever
            let alertController = UIAlertController(title: "Error", message: "Please enter a valid email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            alertController.view.tintColor = UIColor.flatMint
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    //Take email login text and password text and create a user
    @IBAction func signUp(_ sender: Any) {
        let emailLoginText : String = emailLogin.text!
        let passwordLoginText : String = passwordLogin.text!
        if ViewController.isValidEmail(emailLoginText) && passwordLoginText != "" {
            Firebase.registerUser(emailLoginText, passwordLoginText) { success in
                if success { // successfully registered user, let them know to confirm email
                    let alertController = UIAlertController(title: "Success", message: "You have been sent an email confirmation link. Please confirm your email to login.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    alertController.view.tintColor = UIColor.flatMint
                    self.present(alertController, animated: true, completion: nil)
                    SessionManager.storeSession(session: emailLoginText)
                } else { // an error occurred, could not successfully register
                    let alertController = UIAlertController(title: "Error", message: "An error occurred while registering. Please try again later.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    alertController.view.tintColor = UIColor.flatMint
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        } else { // either invalid stanford email or blank password. TODO: change this to floating sky text or whatever
            let alertController = UIAlertController(title: "Error", message: "Please enter a valid stanford.edu email and password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            alertController.view.tintColor = UIColor.flatMint
            present(alertController, animated: true, completion: nil)
        }
    }
    
    /* Returns true if provided email is of valid stanford.edu form*/
    static func isValidEmail(_ email: String) -> Bool {
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
