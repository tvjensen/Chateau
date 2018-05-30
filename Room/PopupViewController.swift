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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        postContent.delegate = self
        
        //Placeholder text
        postContent.text = "Write post..."
        postContent.textColor = UIColor.lightGray
        // Do any additional setup after loading the view.
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
            postContent.text = nil
            postContent.textColor = UIColor.black
        }
    }
    
    //Changes the text back to "Write post..." after user is finished input
    func textViewDidEndEditing(_ postContent: UITextView) {
        if postContent.text.isEmpty {
            postContent.text = "Write post..."
            postContent.textColor = UIColor.lightGray
        }
    }
    
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
    
    func submit() {
        print(postContent.text)
        if let text = postContent.text {
            if isComment {
                Firebase.createComment(postID, text)
            } else {
                Firebase.createPost(roomID, text)
            }
        }
        onDoneBlock()
        self.view.removeFromSuperview()
    }
}
