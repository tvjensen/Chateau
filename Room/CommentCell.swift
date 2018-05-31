//
//  CommentCell.swift
//  Room
//
//  Created by Frank Zheng on 5/29/18.
//  Copyright © 2018 csmith. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet var numUpvotesLabel: UILabel!
    @IBOutlet var downvoteButton: UIButton!
    @IBOutlet var upvoteButton: UIButton!
    @IBOutlet var body: UILabel!
    @IBOutlet var timeLabel: UILabel!
    private var comment: Models.Comment!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setComment(_ comment: Models.Comment) {
        self.comment = comment
        self.body.text = comment.body
        self.timeLabel.text = parseTime(comment.timestamp)
        self.numUpvotesLabel.text = "\(comment.upvoters.keys.count - comment.downvoters.keys.count)"
        upvoteButton.isSelected = comment.upvoters.keys.contains(Current.user!.email)
        downvoteButton.isSelected = comment.downvoters.keys.contains(Current.user!.email)
    }
    
    @IBAction func upvotePressed(_ sender: Any) {
        if comment.upvoters.keys.contains(Current.user!.email) { return }
        if comment.downvoters.keys.contains(Current.user!.email) {
            Firebase.commentRemoveDownvote(comment.commentID, &comment.downvoters)
            downvoteButton.isSelected = false
        } else {
            Firebase.commentUpvote(comment.commentID, &comment.upvoters)
            upvoteButton.isSelected = true
        }
        
        self.numUpvotesLabel.text = "\(comment.upvoters.keys.count - comment.downvoters.keys.count)"
    }
    
    @IBAction func downvotePressed(_ sender: Any) {
        if comment.downvoters.keys.contains(Current.user!.email) { return }
        if comment.upvoters.keys.contains(Current.user!.email) {
            Firebase.commentRemoveUpvote(comment.commentID, &comment.upvoters)
            upvoteButton.isSelected = false
        } else {
            Firebase.commentDownvote(comment.commentID, &comment.downvoters)
            downvoteButton.isSelected = true
        }
        
        self.numUpvotesLabel.text = "\(comment.upvoters.keys.count - comment.downvoters.keys.count)"
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
