//
//  UILabelPadding.swift
//  Room
//
//  Created by Thomas Jensen on 6/5/18.
//  Copyright © 2018 csmith. All rights reserved.
//

import UIKit

class UILabelPadding: UILabel {
//    let padding = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
    let padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, padding))
    }
    
    override var intrinsicContentSize : CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSizeThatFits = super.sizeThatFits(size)
        let width = superSizeThatFits.width + padding.left + padding.right
        let heigth = superSizeThatFits.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
}
