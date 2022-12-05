//
//  WVTableGroup.swift
//  Wansview
//
//  Created by TMZ on 1/7/17.
//  Copyright © 2017 AJCloud. All rights reserved.
//

import Foundation
import UIKit

open class WVTableGroup: NSObject {
    ///自定义section header的内容，原则上该内容不能超过一行
    public var header: String?
    
    ///自定义section footer的内容，不限制内容长度
    public var footer: String?
    
    ///设置footer中需要自定义颜色的内容
    public var fHighlightStr:String?
    
    ///自定义footer内容中fHighlightStr字段对应内容的颜色
    public var fHighlightColor:UIColor?
    
    ///表格最下方添加的按钮
    public var footerBtn:UIButton?
    
    ///单元格内容
    public var items = [WVTableItem]()
    
    public override init() {
        super.init()
    }
}
