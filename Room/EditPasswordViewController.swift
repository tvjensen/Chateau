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
//        if (currentPass.text != oldPass) {
//            let alert = UIAlertController(title: "Incorrect current password entered!", message: "Please make sure you have the right password.", preferredStyle: UIAlertControllerStyle.alert)
//            self.present(alert, animated: true, completion: nil)
//        }
        
        if (newPass.text == retypePass.text) {
            //set users password to newPass
        } else {
            let alert = UIAlertController(title: "Passwords do not match!", message: "Please make sure that the same password is entered in both fields.", preferredStyle: UIAlertControllerStyle.alert)
           
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: { [weak alert] (_) in
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    //TODO: access users password and send email 
    @IBAction func forgotPassword(_ sender: UIButton) {
        let email = Current.user!.email
        let alert = UIAlertController(title: "Forgot Password", message: "We can send an email to " + email + " with your password.", preferredStyle: UIAlertControllerStyle.alert)
        
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
