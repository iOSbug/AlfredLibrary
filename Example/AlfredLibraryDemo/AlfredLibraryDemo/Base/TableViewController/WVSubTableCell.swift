//
//  WVSubTableCell.swift
//  Wansview
//
//  Created by TMZ on 1/9/17.
//  Copyright © 2017 AJCloud. All rights reserved.
//

import UIKit

/**
 the default height is 22 and styles like:
 ----------------------------
       title        comment >
 ----------------------------
 */
open class WVSubTableCell: WVTableCell {
    override open class func cellID() -> String {
        return "WVSubTableCell"
    }
    
    override open class func cellHeight() -> CGFloat {
        return 22
    }
    
    override open func loadUIs() {
        //重载的时候，应该把所有数据清空
        for subview in self.contentView.subviews{
            subview.removeFromSuperview()
        }
        
        setTitleLabel()
        setAccessoryView()
        setAccessoryCustomImageView()
        setComment()
        
        if item.execute == nil {
            self.selectionStyle = .none
        }
        
        if item.hideSepratorLine {
            self.separatorInset = UIEdgeInsets(top: 0, left: self.bounds.size.width, bottom: 0, right: 0)
        } else {
            self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    public override func setTitleLabel() {
        if item.title == nil {
            return
        }
        
        titleLabel.text = item.title
//        titleLabel.font = HCFont.commentFont()
//        titleLabel.textColor = HCColor.HCCommentTextColor()
        self.contentView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let left = NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1.0, constant: leftGap*5)
        let centerY = NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0)
        contentView.addConstraints([left, centerY])
    }
}
