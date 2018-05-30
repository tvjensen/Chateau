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
    
    // TODO
    private func parseTime(_ time: Double) -> String {
        return "20 minutes ago"
    }

}
