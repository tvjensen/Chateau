//
//  ViewController.swift
//  Room
//
//  Created by Conner Smith on 4/23/18.
//  Copyright © 2018 csmith. All rights reserved.
//

import UIKit
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
    
    @IBAction func createRoom(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popupID") as! PopupViewController
        self.addChildViewController(popOverVC)

        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)

    }
}
