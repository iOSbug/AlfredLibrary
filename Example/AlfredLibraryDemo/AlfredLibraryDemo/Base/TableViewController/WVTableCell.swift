//
//  WVTableCell.swift
//  Wansview
//
//  Created by TMZ on 1/7/17.
//  Copyright © 2017 AJCloud. All rights reserved.
//
import UIKit

/**
 the default height is 62 and styles like:
 ----------------------------
 icon  Title                >
 Comment
 ----------------------------
 */

class CommSwitchCell: CommonTableCell {
    let switchControl = UISwitch()
    
    override func loadUIs() {
        //重载的时候，应该把所有数据清空
        for subview in self.contentView.subviews{
            subview.removeFromSuperview()
        }
        setIconImageView()
        setTitleLabel()
        setAccessoryView()
        setAccessoryCustomImageView()
        setComment()
        setBottomLine()
        if (item as? WVSwitchTableItem)?.matSwitchTarget != nil {
            setupMatSwitch()
        }
        setfontcolor()
        if item.execute == nil {
            self.selectionStyle = .none
        }
    }
        
    public func setupMatSwitch() {
        switchControl.isOn = ((item as? WVSwitchTableItem)?.matSwitchOn)!
        if (item as? WVSwitchTableItem)?.matSwitchTarget != nil {
            switchControl.addTarget(self, action: #selector(switchDidChangeState), for: .valueChanged)
        }
        switchControl.isEnabled = item.switchEnable
        self.contentView.addSubview(switchControl)
        
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        let left = NSLayoutConstraint(item: switchControl, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1.0, constant: -rightGap-50)
        let right = NSLayoutConstraint(item: switchControl, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1.0, constant: -rightGap)
        let centerY = NSLayoutConstraint(item: switchControl, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0)
        
        contentView.addConstraints([left, right, centerY])
    }
    
    @objc func switchDidChangeState() {
        (item as? WVSwitchTableItem)?.matSwitchTarget?(switchControl.isOn)
    }
}

class CommonTableCell: WVThinTableCell {
    
    override func loadUIs() {
        //重载的时候，应该把所有数据清空
        for subview in self.contentView.subviews{
            subview.removeFromSuperview()
        }
        setIconImageView()
        setTitleLabel()
        setAccessoryView()
        setAccessoryCustomImageView()
        setComment()
        setBottomLine()
        setfontcolor()
        if item.execute == nil {
            self.selectionStyle = .none
        }
    }
    
    func setfontcolor() {
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = WVColor.WVBlackTextColor()
        
        commentLabel.font = UIFont.systemFont(ofSize:16)
        commentLabel.textColor = WVColor.WVCommentTextColor()
    }
    
    public func setBottomLine() {
        let line = UIView()
        line.backgroundColor = WVColor.WVTableLineColor()
        self.contentView.addSubview(line)
        
        line.snp.makeConstraints { (make) in
            make.left.equalTo(24)
            make.right.equalTo(-24)
            make.height.equalTo(0.8)
            make.bottom.equalTo(self.contentView)
        }
    }
    
    public func setTopLine() {
        let line = UIView()
        line.backgroundColor = WVColor.WVTableLineColor()
        self.contentView.addSubview(line)
        
        line.snp.makeConstraints { (make) in
            make.left.equalTo(24)
            make.right.equalTo(-24)
            make.height.equalTo(0.8)
            make.top.equalTo(self.contentView)
        }
    }
}



open class WVTableCell: UITableViewCell {
    public let leftGap: CGFloat = 24.0
    let topGap: CGFloat = 5.0
    public let rightGap: CGFloat  = 24.0
    open var leftIconGap: CGFloat = 15.0
    open var rightAccessoryGap: CGFloat = 15.0
    
    open var item = WVTableItem() {
        didSet{
            self.loadUIs()
        }
    }
    
    public let iconView = UIImageView()
    public let titleLabel = UILabel()
    public   let commentLabel = UILabel()
    public let userSwitch = UISwitch()
    public var indicator = UIImageView(image: UIImage(named: "arrow_right"))
    public var customImageView = UIImageView()
    
    open class func cellID() -> String {
        return "WVTableCell"
    }
    
    open class func cellHeight() -> CGFloat {
        return 62
    }
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override open func layoutSubviews() {
        self.layoutIfNeeded()
        super.layoutSubviews()
    }
    
    open func loadUIs() {
        //重载的时候，应该把所有数据清空
        for subview in self.contentView.subviews{
            subview.removeFromSuperview()
        }
        
        setIconImageView()
        setTitleLabel()
        setAccessoryView()
        setAccessoryCustomImageView()
        setCommentLabel()
        
        if item.execute == nil {
            self.selectionStyle = .none
        }
        
        if item.hideSepratorLine {
            self.separatorInset = UIEdgeInsets(top: 0, left: self.bounds.size.width, bottom: 0, right: 0)
        } else {
            self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    public func setIconImageView() {
        if item.icon == nil {
            return
        }
        
        iconView.image = item.icon!
        self.contentView.addSubview(iconView)
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        let left = NSLayoutConstraint(item: iconView, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1.0, constant: leftGap)
        let right = NSLayoutConstraint(item: iconView, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1.0, constant: leftGap+item.icon!.size.width)
        let centerY = NSLayoutConstraint(item: iconView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0)
        contentView.addConstraints([left, right, centerY])
    }
    
    public func setTitleLabel() {
        if item.title == nil {
            return
        }
        
        titleLabel.text = item.title!
        titleLabel.sizeToFit()
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor(rgb: 0x404040)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleLabel)
        
        var gap:CGFloat = -50
        if item.switchTarget != nil {
            gap = gap - 60
        }
        let right = NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .lessThanOrEqual, toItem: contentView, attribute: .right, multiplier: 1.0, constant: gap)
        if item.icon != nil {
            let left = NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: iconView, attribute: .right, multiplier: 1.0, constant: leftIconGap)
            if item.comment != nil {
                let bottom = NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0)
                contentView.addConstraints([left, right, bottom])
            } else {
                let centerY = NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0)
                contentView.addConstraints([left, right, centerY])
            }
        } else {
            let left = NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1.0, constant: leftGap)
            if item.comment != nil {
                let bottom = NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0)
                contentView.addConstraints([left, right, bottom])
            } else {
                let centerY = NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0)
                contentView.addConstraints([left, right, centerY])
            }
        }
    }
    
    public func setupIndicator() {
        self.contentView.addSubview(indicator)
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        let left = NSLayoutConstraint(item: indicator, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1.0, constant: -rightGap-indicator.image!.size.width)
        let right = NSLayoutConstraint(item: indicator, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1.0, constant: -rightGap)
        let centerY = NSLayoutConstraint(item: indicator, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0)
        contentView.addConstraints([left, right, centerY])
    }
    
    open func setupSwitch() {
        userSwitch.isOn = item.switchOn
        
        if ((item.switchTarget) != nil) {
            userSwitch.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        }
        
        self.contentView.addSubview(userSwitch)
        
        userSwitch.translatesAutoresizingMaskIntoConstraints = false
        let left = NSLayoutConstraint(item: userSwitch, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1.0, constant: -rightGap-50)
        let right = NSLayoutConstraint(item: userSwitch, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1.0, constant: -rightGap)
        let centerY = NSLayoutConstraint(item: userSwitch, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0)
        
        contentView.addConstraints([left, right, centerY])
    }
    
    public func setAccessoryView() {
        if item.switchTarget != nil {
            setupSwitch()
        }
        else if item.accessoryCustomImage != nil {
            indicator = UIImageView(image: item.accessoryCustomImage)
            setupIndicator()
        }
        else if item.showAccessory || item.execute != nil {
            setupIndicator()
        }
    }
    
    ///TODO: 自定义右侧图标的功能需要完善
    public func setAccessoryCustomImageView() {
        if item.accessoryCustomImage == nil {
            return
        }
        customImageView = UIImageView(image: item.accessoryCustomImage)
        self.contentView.addSubview(customImageView)
        
        customImageView.translatesAutoresizingMaskIntoConstraints = false
        let right = NSLayoutConstraint(item: customImageView, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1.0, constant: -rightGap)
        let centerY = NSLayoutConstraint(item: customImageView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0)
        
        contentView.addConstraints([right, centerY])
    }
    
    public func setCommentLabel() {
        if item.comment == nil || item.title == nil {
            return
        }
        commentLabel.text = item.comment!
        commentLabel.sizeToFit()
        commentLabel.textColor = UIColor(rgb: 0x959595)
        commentLabel.font = UIFont.systemFont(ofSize: 12)
        commentLabel.textAlignment = NSTextAlignment.left
        contentView.addSubview(commentLabel)
        
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let left = NSLayoutConstraint(item: commentLabel, attribute: .left, relatedBy: .equal, toItem: titleLabel, attribute: .left, multiplier: 1.0, constant: 0)
        let right:NSLayoutConstraint
        if item.switchTarget != nil {
            right = NSLayoutConstraint(item: commentLabel, attribute: .right, relatedBy: .lessThanOrEqual, toItem: userSwitch, attribute: .left, multiplier: 1.0, constant: -leftGap)
        } else if item.showAccessory || item.execute != nil {
            right = NSLayoutConstraint(item: commentLabel, attribute: .right, relatedBy: .lessThanOrEqual, toItem: indicator, attribute: .left, multiplier: 1.0, constant: -10)
        } else {
            right = NSLayoutConstraint(item: commentLabel, attribute: .right, relatedBy: .lessThanOrEqual, toItem: contentView, attribute: .right, multiplier: 1.0, constant: -rightAccessoryGap)
        }
        let bottom = NSLayoutConstraint(item: commentLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 5)
        
        contentView.addConstraints([left, right, bottom])
    }
    
    @objc open func valueChanged() {
        item.switchOn = userSwitch.isOn
        item.switchTarget?()
    }
    
    ///显示在右侧，供sub、thin样式使用
    open func setComment() {
        if item.comment == nil {
            return
        }
        commentLabel.text = item.comment!
        commentLabel.font = UIFont.systemFont(ofSize: 14)
        commentLabel.textColor = UIColor(rgb: 0x61727A)
        commentLabel.textAlignment = NSTextAlignment.right
        commentLabel.numberOfLines = 1
        commentLabel.lineBreakMode = .byTruncatingTail
        self.contentView.addSubview(commentLabel)
        
        var maxWidth = self.frame.width - leftGap * 2
        if item.icon != nil {
            maxWidth -= iconView.image!.size.width + rightGap
        }
        
        if titleLabel.text != nil {
            let attributes = [NSAttributedString.Key.font: titleLabel.font as Any]
            let option = NSStringDrawingOptions.usesLineFragmentOrigin
            let text:NSString = NSString(cString: titleLabel.text!.cString(using: String.Encoding.utf8)!, encoding: String.Encoding.utf8.rawValue)!
            let rect = text.boundingRect(with: CGSize(width:300, height:0), options: option, attributes: attributes, context: nil)
            let width = rect.size.width
            
            maxWidth -= width + rightGap
        }
        
        if (item.accessoryCustomImage != nil || item.showAccessory) {
            maxWidth -= (indicator.image!.size.width )
        } else if item.switchTarget != nil {
            maxWidth -= 50
        }
        
        if maxWidth < 60 {
            maxWidth = 60
        }
        
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if item.showAccessory {
            let right = NSLayoutConstraint(item: commentLabel, attribute: .right, relatedBy: .equal, toItem: indicator, attribute: .left, multiplier: 1.0, constant: 0)
            let left = NSLayoutConstraint(item: commentLabel, attribute: .left, relatedBy: .greaterThanOrEqual, toItem: indicator, attribute: .left, multiplier: 1.0, constant: -rightGap/3-maxWidth)
            let centerY = NSLayoutConstraint(item: commentLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0)
            contentView.addConstraints([left, right, centerY])
        } else if (item.switchTarget) != nil {
            let right = NSLayoutConstraint(item: commentLabel, attribute: .right, relatedBy: .equal, toItem: userSwitch, attribute: .left, multiplier: 1.0, constant: -rightGap)
            let left = NSLayoutConstraint(item: commentLabel, attribute: .left, relatedBy: .greaterThanOrEqual, toItem: userSwitch, attribute: .left, multiplier: 1.0, constant: -rightGap-maxWidth)
            let centerY = NSLayoutConstraint(item: commentLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0)
            contentView.addConstraints([left, right, centerY])
        } else if item.accessoryCustomImage != nil {
            let right = NSLayoutConstraint(item: commentLabel, attribute: .right, relatedBy: .equal, toItem: customImageView, attribute: .left, multiplier: 1.0, constant: -rightAccessoryGap)
            let left = NSLayoutConstraint(item: commentLabel, attribute: .left, relatedBy: .greaterThanOrEqual, toItem: customImageView, attribute: .left, multiplier: 1.0, constant: -rightGap-maxWidth)
            let centerY = NSLayoutConstraint(item: commentLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0)
            
            contentView.addConstraints([left, right, centerY])
        } else {
            let right = NSLayoutConstraint(item: commentLabel, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1.0, constant: -rightGap)
            let left = NSLayoutConstraint(item: commentLabel, attribute: .left, relatedBy: .greaterThanOrEqual, toItem: contentView, attribute: .right, multiplier: 1.0, constant: -rightGap-maxWidth)
            let centerY = NSLayoutConstraint(item: commentLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0)
            
            contentView.addConstraints([left, right, centerY])
        }
    }
}
