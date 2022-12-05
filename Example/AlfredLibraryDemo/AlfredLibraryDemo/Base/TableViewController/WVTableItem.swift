//
//  HCTableItem.swift
//  Homecare
//
//  Created by TMZ on 1/7/17.
//  Copyright © 2017 AJCloud. All rights reserved.
//

import Foundation
import UIKit

class CommonTableItem: WVTableItem {
    public var showTopLine: Bool = false
    public var showBottomLine: Bool = true
}

class WVSwitchTableItem: WVTableItem {
    ///switch开关的取值
    public var matSwitchOn: Bool = false
    
    ///切换switch按钮时的执行函数
    public var matSwitchTarget: ((Bool)->Void)?
}

open class WVTableItem:NSObject {
    ///单元格左侧图标
    public var icon: UIImage?
    
    ///标题，左对齐
    public var title: String?
    
    ///详情说明
    public var comment:String?
    
    ///是否显示单元格右侧标示，默认为 右箭头 >
    public var showAccessory = false
    
    ///如果需要自定义单元格右侧的图标，请修改该参数
    public var accessoryCustomImage: UIImage?
    
    ///switch开关的取值
    public var switchOn: Bool = false
    
    ///switch是否可以点击
    public var switchEnable: Bool = true
    
    ///切换switch按钮时的执行函数
    public var switchTarget: (()->Void)?
    
    ///点击单元格的执行函数
    public var execute: (()->Void)?
    
    ///cell的样式，默认为HCTableCell
    public var style:String?
    
    ///是否需要隐藏
    public var hideSepratorLine:Bool = false
    
    ///默认高度为62,如果需要改变行高，请定义该字段； 如果整个表格默认都是非62的某个数字，建议重写tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath)
    public var height:CGFloat?
    
    public override init() {
        super.init()
    }
}
