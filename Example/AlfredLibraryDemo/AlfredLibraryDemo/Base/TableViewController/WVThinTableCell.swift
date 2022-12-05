//
//  WVThinTableCell.swift
//  Wansview
//
//  Created by TMZ on 1/7/17.
//  Copyright © 2017 AJCloud. All rights reserved.
//
import UIKit

/*＊
 the default height is 44 and styles like:
    ----------------------------
    icon  Title        comment >
    ----------------------------
 */
open class WVThinTableCell: WVTableCell {
    override open class func cellID() -> String {
        return "WVThinTableCell"
    }
    
    override open class func cellHeight() -> CGFloat {
        return 44
    }
    
    open override func loadUIs() {
        //重载的时候，应该把所有数据清空
        for subview in self.contentView.subviews{
            subview.removeFromSuperview()
        }
        
        setIconImageView()
        setTitleLabel()
        setAccessoryView()
        setAccessoryCustomImageView()
        setComment()
        
        if item.execute == nil {
            self.selectionStyle = .none
        }
        
        if item.hideSepratorLine {
            self.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.size.width, bottom: 0, right: 0)
        } else {
            self.separatorInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)
        }
    }
    
    public override func setTitleLabel() {
        if item.title == nil {
            return
        }
        titleLabel.text = item.title
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = UIColor(rgb: 0x263238)
        
        self.contentView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let left: NSLayoutConstraint
        if item.icon != nil {
            left = NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: iconView, attribute: .right, multiplier: 1.0, constant: leftIconGap)
        } else {
            left = NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1.0, constant: leftGap)
        }
        var gap:CGFloat = -50
        if item.comment != nil {
            gap = gap - 60
        }
        let right = NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .lessThanOrEqual, toItem: contentView, attribute: .right, multiplier: 1.0, constant: gap)
        let centerY = NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0)
        contentView.addConstraints([left, right, centerY])
    }
}
