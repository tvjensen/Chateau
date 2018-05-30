//
//  PostCell.swift
//  Room
//
//  Created by Conner Smith on 5/16/18.
//  Copyright © 2018 csmith. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet var numUpvotesLabel: UILabel!
    @IBOutlet var downvoteButton: UIButton!
    @IBOutlet var upvoteButton: UIButton!
    @IBOutlet var body: UILabel!
    @IBOutlet var timeLabel: UILabel!
    private var post: Models.Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func reportPost(_ sender: UIButton) {
        let alert = UIAlertController(title: "Report Post", message: "Please tell us why you are reporting this post.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Description of problem"
        })
        alert.addAction(UIAlertAction(title: "Report post", style: UIAlertActionStyle.default, handler: { [weak alert] (_) in
            // Store report
            Firebase.report(reportType: "post", reporterID: (Current.user?.email)!, reportedContentID: self.post.postID, posterID: self.post.posterID, report: (alert?.textFields![0].text)!)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { [weak alert] (_) in
            // do nothing
        }))
        
        parentViewController?.present(alert, animated: true, completion: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setPost(_ post: Models.Post) {
        self.post = post
        self.body.text = post.body
        self.timeLabel.text = parseTime(post.timestamp)
        self.numUpvotesLabel.text = "\(post.upvoters.keys.count - post.downvoters.keys.count)"
        upvoteButton.isSelected = post.upvoters.keys.contains(Current.user!.email)
        downvoteButton.isSelected = post.downvoters.keys.contains(Current.user!.email)
    }
    
    @IBAction func upvotePressed(_ sender: Any) {
        if post.upvoters.keys.contains(Current.user!.email) { return }
        let newNetVotes = post.netVotes + 1
        if post.downvoters.keys.contains(Current.user!.email) {
            Firebase.removeDownvote(post.postID, &post.downvoters, newNetVotes)
            downvoteButton.isSelected = false
        } else {
            Firebase.upvote(post.postID, &post.upvoters, newNetVotes)
            upvoteButton.isSelected = true
        }
        
        self.numUpvotesLabel.text = "\(post.upvoters.keys.count - post.downvoters.keys.count)"
    }
    
    @IBAction func downvotePressed(_ sender: Any) {
        if post.downvoters.keys.contains(Current.user!.email) { return }
        let newNetVotes = post.netVotes - 1
        if post.upvoters.keys.contains(Current.user!.email) {
            Firebase.removeUpvote(post.postID, &post.upvoters, newNetVotes)
            upvoteButton.isSelected = false
        } else {
            Firebase.downvote(post.postID, &post.downvoters, newNetVotes)
            downvoteButton.isSelected = true
        }
        
        self.numUpvotesLabel.text = "\(post.upvoters.keys.count - post.downvoters.keys.count)"
    }
    
    // TODO
    private func parseTime(_ time: Double) -> String {
        return "20 minutes ago"
    }

}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as! UIViewController!
            }
        }
        return nil
    }
}
