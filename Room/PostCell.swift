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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
