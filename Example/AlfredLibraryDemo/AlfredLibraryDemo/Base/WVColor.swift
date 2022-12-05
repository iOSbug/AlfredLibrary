//
//  AJColor.swift
//  Wansview
//
//  Created by TMZ on 2018/2/24.
//  Copyright © 2018年 AJCloud. All rights reserved.
//

import UIKit

class WVColor: UIColor {
    
    /************** 背景 *****************/
    /// 按钮、APP主色、蓝
    public class func WVMainColor(alpha: CGFloat = 1.0) -> UIColor {
        return getColor(rgb: 0x448AFF, alpha: alpha)
    }
    
    /// 页面背景色、纯白
    public class func WVViewBackColor(alpha: CGFloat = 1.0) -> UIColor {
        return getColor(rgb: 0xFFFFFF, alpha: alpha)
    }
    
    /// 线条/边框、灰色
    @objc
    public class func WVLineColor(alpha: CGFloat = 1.0) -> UIColor {
        return getColor(rgb: 0x95A5AD, alpha: alpha)
    }
    
    /// 失效按钮颜色、深灰
    public class func WVDisabelBackColor(alpha: CGFloat = 1.0) -> UIColor {
        return getColor(rgb: 0x95A5AD, alpha: alpha)
    }
    
    /************** 字体 *****************/
    
    /// 输入框/按钮、黑色
    public class func WVBlackTextColor() -> UIColor {
        return getColor(rgb: 0x000000, alpha: 0.87)
    }
    
    /// 提示文字、浅灰色
    public class func WVCommentTextColor() -> UIColor {
        return getColor(rgb: 0x000000, alpha: 0.72)
    }
    
    /// 灰色
    public class func WVLightgrayTextColor() -> UIColor {
        return getColor(rgb: 0x000000, alpha: 0.56)
    }
    
    /// 不可用
    public class func WVGrayTextColor() -> UIColor {
        return getColor(rgb: 0x000000, alpha: 0.54)
    }
    
    /// 不可用
    public class func WVGrayLoadColor() -> UIColor {
        return getColor(rgb: 0x000000, alpha: 0.4)
    }
    
    /// 不可用
    public class func WVdeepGrayTextColor() -> UIColor {
        return getColor(rgb: 0x000000, alpha: 0.26)
    }
    
    /// tableview sepline
    public class func WVTableLineColor() -> UIColor {
        return getColor(rgb: 0x000000, alpha: 0.1)
    }
    
    /// 提示告警、红色
    public class func WVWarnTextColor(alpha: CGFloat = 1.0) -> UIColor {
        return getColor(rgb: 0xFF5252, alpha: alpha)
    }
    
    /// 提示告警、红色
    public class func WVRedTextColor(alpha: CGFloat = 1.0) -> UIColor {
        return getColor(rgb: 0xEF5350, alpha: alpha)
    }
    
    /************** 按钮 *****************/
    /// 按钮、蓝
    public class func WVBlueColor(alpha: CGFloat = 1.0) -> UIColor {
        return getColor(rgb: 0x448AFF, alpha: alpha)
    }
    
    /// 按钮、蓝（不可点击）
    public class func WVBlueUnableColor(alpha: CGFloat = 1.0) -> UIColor {
        return getColor(rgb: 0xB0BEC5, alpha: alpha)
    }
    
    /// 说明标题
    public class func WVInfoHeadColor(alpha: CGFloat = 1.0) -> UIColor {
        return getColor(rgb: 0x010101, alpha: 0.87)
    }
    
    /// 说明内容
    public class func WVInfoColor(alpha: CGFloat = 1.0) -> UIColor {
        return getColor(rgb: 0x010101, alpha: 0.72)
    }
    
    /// 说明内容
    public class func WVYellowColor(alpha: CGFloat = 1.0) -> UIColor {
        return getColor(rgb: 0xFFB74D, alpha: alpha)
    }
    
    /// 输入框
    public class func WVTextfieldColor(alpha: CGFloat = 1.0) -> UIColor {
        return getColor(rgb: 0x263238, alpha: alpha)
    }
    
    private class func getColor(rgb: Int, alpha: CGFloat) -> UIColor {
        return UIColor.init(
            red:   CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8)  / 255.0,
            blue:  CGFloat((rgb & 0x0000FF) >> 0)  / 255.0,
            alpha: alpha
        )
    }
}


public extension UIColor {
    
    convenience init(rgb: Int, alpha: CGFloat = 1) {
        self.init(
            red:   CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8)  / 255.0,
            blue:  CGFloat((rgb & 0x0000FF) >> 0)  / 255.0,
            alpha: alpha
        )
    }
    
    convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    
    convenience init(colorString: String) {
        var colorInt: UInt32 = 0
        Scanner(string: colorString).scanHexInt32(&colorInt)
        self.init(rgb: (Int)(colorInt))
    }
    
    func purecolorImage() -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        return self.purecolorImage(rect)
    }
    
    func purecolorImage(_ rect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(self.cgColor)
        context.fill(rect);
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
