//
//  SettingsViewController.swift
//  Room
//
//  Created by Thomas Jensen on 5/24/18.
//  Copyright © 2018 csmith. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var email: UILabel!
    
    //how to call this every time tab bar 'settings' is clicked?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email.text = Current.user!.email
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        email.text = Current.user!.email.replacingOccurrences(of: ",", with: ".")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logout(_ sender: Any) {
        let alert = UIAlertController(title: "Log Out", message: "Are you sure that you want to log out?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Yes!", style: UIAlertActionStyle.default, handler: { [weak alert] (_) in
            self.email.text = nil
            SessionManager.refreshState()
            self.performSegue(withIdentifier: "backToLoginSegue", sender: nil)
            Current.user = nil
        }))
        alert.addAction(UIAlertAction(title: "Nevermind!", style: UIAlertActionStyle.default, handler: { [weak alert] (_) in
            //do nothing
        }))
        alert.view.tintColor = UIColor.flatMint
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func reportProblem(_ sender: Any) {
        let alertReport = UIAlertController(title: "Report Problem", message: "Please let us know what issues you might have encountered with the Room app", preferredStyle: UIAlertControllerStyle.alert)
        alertReport.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Description of problem"
        })
        alertReport.addAction(UIAlertAction(title: "Report problem", style: UIAlertActionStyle.default, handler: { [weak alertReport] (_) in
            // Store report
            Firebase.report(reportType: "general", reporterID: (Current.user?.email)!, reportedContentID: "", posterID: "", report: (alertReport?.textFields![0].text)!)
        }))
        alertReport.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { [weak alertReport] (_) in
            // do nothing
        }))
        alertReport.view.tintColor = UIColor.flatMint
        self.present(alertReport, animated: true, completion: nil)
    }
    
    @IBAction func deleteAccount(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Account", message: "Please enter your password to delete your account.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "password"
        })
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { [weak alert] (_) in
            Firebase.getMyRooms() {rooms in
                for room in rooms {
                    Firebase.leaveRoom(room: room)
                }
            }
            Firebase.deleteCurrentUser(password: (alert?.textFields![0].text)!) { success in
                if success {
                    SessionManager.refreshState()
                    self.performSegue(withIdentifier: "backToLoginSegue", sender: nil)
                    self.email.text = nil
                    Current.user = nil
                } else {
                    let alertError = UIAlertController(title: "Error Deleting Account", message: "Please try again. Confirm you entered a correct password. ", preferredStyle: UIAlertControllerStyle.alert)
                    alertError.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { [weak alert] (_) in
                        //do nothing
                    }))
                    self.present(alertError, animated: true, completion: nil)
                }
            }
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { [weak alert] (_) in
            //do nothing
        }))
        alert.view.tintColor = UIColor.flatMint
        self.present(alert, animated: true, completion: nil)
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
