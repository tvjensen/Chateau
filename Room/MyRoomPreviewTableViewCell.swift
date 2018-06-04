//
//  MyRoomPreviewTableViewCell.swift
//  Room
//
//  Created by Rick Duenas on 5/16/18.
//  Copyright © 2018 csmith. All rights reserved.
//

import UIKit

class MyRoomPreviewTableViewCell: UITableViewCell {
    
    @IBOutlet var unreadIndicator: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nMemLabel: UILabel!
    @IBOutlet weak var lastActivityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
