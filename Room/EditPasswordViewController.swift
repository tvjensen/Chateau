//
//  EditPasswordViewController.swift
//  Room
//
//  Created by Thomas Jensen on 5/24/18.
//  Copyright © 2018 csmith. All rights reserved.
//

import UIKit

class EditPasswordViewController: UIViewController {

    @IBOutlet weak var currentPass: UITextField!
    @IBOutlet weak var newPass: UITextField!
    @IBOutlet weak var retypePass: UITextField!
    
    
    
    //TODO: need to access old password of user and have access to set new password
    @IBAction func changePassword(_ sender: UIButton) {
        if (currentPass.text != newPass.text && newPass.text == retypePass.text && newPass.text != "" && (newPass.text?.count)! >= 6) {
            Firebase.updatePassword(oldPassword: currentPass.text!, newPassword: newPass.text!) { (success) in
                if success {
                    let alert = UIAlertController(title: "Changed Password", message: "Your password has been successfully been changed.", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(defaultAction)
                    
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Error", message: "Please confirm that you have entered a correct current password. Please ensure that the new password is 6 characters or longer.", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(defaultAction)
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
            currentPass.text = ""
            newPass.text = ""
            retypePass.text = ""
        } else {
            let alert = UIAlertController(title: "Invalid Password Entries", message: "Please enter a new password that is different from the current password. Confirm the new password is retyped correctly and is at least 6 characters long.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(defaultAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
//    //TODO: access users password and send email
    @IBAction func forgotPassword(_ sender: UIButton) {
        let email = Current.user!.email.replacingOccurrences(of: ",", with: ".")
        
        let alert = UIAlertController(title: "Forgot Password", message: "We can reset your password and send an email to " + email + " with further instructions. [Not implemented yet]", preferredStyle: UIAlertControllerStyle.alert)

        alert.addAction(UIAlertAction(title: "Send email!", style: UIAlertActionStyle.default, handler: { [weak alert] (_) in
            //send email with old password
        }))
        alert.addAction(UIAlertAction(title: "Nevermind!", style: UIAlertActionStyle.default, handler: { [weak alert] (_) in
        }))

        self.present(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
