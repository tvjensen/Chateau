//
//  PopupViewController.swift
//
//  This class governs the popup for the writing of the posts.
//
//  Created by Frank Zheng on 5/9/18.
//

import UIKit

class PopupViewController: UIViewController, UITextViewDelegate {
    
    var roomID: String!
    var postID: String!
    var isComment: Bool!
    var onDoneBlock: (() -> Void)!
    // Instance variable to keep track if the textField did
    // change so that we don't post Write here...
    var textFieldChanged: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        postContent.delegate = self
        
        //Placeholder text
        postContent.text = "Write here..."
        postContent.textColor = UIColor.lightGray
        // Do any additional setup after loading the view.
        textFieldChanged = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func closePopup(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBOutlet weak var postContent: UITextView!
    
    //Change from placeholder to text that user inputs
    func textViewDidBeginEditing(_ postContent: UITextView) {
        if postContent.textColor == UIColor.lightGray {
            textFieldChanged = true
            postContent.text = nil
            postContent.textColor = UIColor.black
        }
    }
    
    /*
    Is called when the keyboard disappears. Is this really necessary?
    //Changes the text back to "Write post..." after user is finished input
    func textViewDidEndEditing(_ postContent: UITextView) {
        if postContent.text.isEmpty {
            postContent.text = "Write post..."
            postContent.textColor = UIColor.lightGray
        }
    }
    */

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            submit()
            return false
        }
        return true
    }

    @IBAction func submitPost(_ sender: Any) {
        submit()
    }
    
    func shakeAndDisplayErrorMessage(){
        /* Shaking alert setup */
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: postContent.center.x - 10, y: postContent.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: postContent.center.x + 10, y: postContent.center.y))
        /* Shaking alert end */
        postContent.layer.add(animation, forKey: "position")
        postContent.textColor = UIColor.lightGray
        postContent.text = "Please write something to post!"
        self.view.endEditing(true)
        // Reset internal variables, too
        textFieldChanged = false
    }
    
    
    func submit() {

        if !(textFieldChanged ?? false){
            shakeAndDisplayErrorMessage()
            return
        }
        if let text = postContent.text {
            let trimmedText = text.trimmingCharacters(in: .whitespaces)
            if trimmedText == ""{
                shakeAndDisplayErrorMessage()
                return
            }
            if isComment {
                Firebase.createComment(roomID, postID, text)
            } else {
                Firebase.createPost(roomID, text)
            }
        }
        onDoneBlock()
        self.view.removeFromSuperview()
    }
}
