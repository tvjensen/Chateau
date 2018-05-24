//
//  InsideOfRoom_v2.swift
//  Room
//
//  Created by Batuhan BALCI on 5/16/18.
//  Copyright © 2018 csmith. All rights reserved.
//

import UIKit

class InsideOfRoom_v2: UIViewController, UITableViewDelegate, UITableViewDataSource,
    UITextFieldDelegate/* 1 */ {

    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postsTableView.delegate = self
        postsTableView.dataSource = self
        self.textField.delegate = self

        // Do any additional setup after loading the view.
        
        // Move the screen up when keyboard shown
        // Listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)),
                                               name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)),
                                               name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)),
                                               name: .UIKeyboardWillChangeFrame, object: nil)
    }
    
    // Move the screen up when keyboard shown
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)

        
    }
    
    @IBAction func submitPost(_ sender: UIButton) {
        // Check if the postfield is empty
        // Make keyboard disappear when you click somewhere else on the screen
        // Move text field
        print(textField.text!)
        let text = textField.text!
        textField.text = ""
        let roomID = "testRoom"
        let posterID = "testUser"
        // write to database
        Firebase.createPost(roomID, text, posterID, 0.0)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 20
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as! PostCell
        cell.postLabel.text = "This is a sample post"
        return cell
    }
    
    // Hide keyboard when user touches outside keyboard
    // Not sure why this does not work
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touched outside the keyboard")
        self.view.endEditing(true)
    }
    
    // Move the screen up when keyboard shown
    // START
    // https://www.youtube.com/watch?v=xVZubAMFuIU
    @objc func keyboardWillChange(notification: Notification){
        print("Keyboard will show: \(notification.name.rawValue)")
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        if notification.name == Notification.Name.UIKeyboardWillShow ||
            notification.name == Notification.Name.UIKeyboardWillChangeFrame{
            view.frame.origin.y = -keyboardRect.height
        } else{
            view.frame.origin.y = 0
        }
        
    }

    
    // END
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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

/* 1: Need this to implement making the keyboard disappear when I click somewhere on the screen */
