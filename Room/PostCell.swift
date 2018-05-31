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
    
    private var currentTime: Double {
        return Double(NSDate().timeIntervalSince1970)
    }
    
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
        post.netVotes += 1
        if post.downvoters.keys.contains(Current.user!.email) {
            Firebase.removeDownvote(post.postID, &post.downvoters, post.netVotes)
            downvoteButton.isSelected = false
        } else {
            Firebase.upvote(post.postID, &post.upvoters, post.netVotes)
            upvoteButton.isSelected = true
        }
        
        self.numUpvotesLabel.text = "\(post.netVotes)"
    }
    
    @IBAction func downvotePressed(_ sender: Any) {
        if post.downvoters.keys.contains(Current.user!.email) { return }
        post.netVotes -= 1
        if post.upvoters.keys.contains(Current.user!.email) {
            Firebase.removeUpvote(post.postID, &post.upvoters, post.netVotes)
            upvoteButton.isSelected = false
        } else {
            Firebase.downvote(post.postID, &post.downvoters, post.netVotes)
            downvoteButton.isSelected = true
        }
        
        self.numUpvotesLabel.text = "\(post.netVotes)"
    }
    
    private func parseTime(_ time: Double) -> String {
        // Get the current time in Date()
        let curTime = Date()
        // Get the time of the post in terms of Date(), i.e. convert from seconds to Date()
        let postedTime = Date(timeIntervalSince1970: time)
        // Find the difference between the two dates
        let components = Calendar.current.dateComponents([.minute, .hour, .day, .weekOfYear, .year], from: postedTime, to: curTime)
        // if number of years is 0:
        if components.year == 0{
            if components.weekOfYear == 0{
                if components.day == 0{
                    if components.hour == 0{
                        if components.minute == 0{
                            return "Just now"
                        } else{
                            return "\(components.minute!)m ago"
                        }
                    } else{
                        return "\(components.hour!)h ago"
                    }
                } else{
                    return "\(components.day!)d ago"
                }
            } else{
                return "\(components.weekOfYear!)w ago"
            }
        } else{
            return "\(components.year!)y ago"
        }
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
