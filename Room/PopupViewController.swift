//
//  PopupViewController.swift
//  
//
//  Created by Frank Zheng on 5/9/18.
//

import UIKit

class PopupViewController: UIViewController, UITextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        postContent.delegate = self
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
    
    func textViewDidBeginEditing(_ postContent: UITextView) {
        if postContent.textColor == UIColor.lightGray {
            postContent.text = nil
            postContent.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ postContent: UITextView) {
        if postContent.text.isEmpty {
            postContent.text = "Write post..."
            postContent.textColor = UIColor.lightGray
        }
    }
    
    
}
