//
//  Toast.swift
//  Wansview
//
//  Created by TMZ on 2018/2/5.
//  Copyright © 2018年 AJCloud. All rights reserved.
//

import UIKit
import MBProgressHUD

open class Toast: NSObject {
    @objc
    public static func promptMessage(_ message: String?) {
        let delegate = UIApplication.shared.delegate
        MBProgressHUD.hide(for: (delegate?.window!)!, animated: true)
        
        let promptHud = MBProgressHUD.showAdded(to: (delegate?.window!)!, animated: true)
        delegate?.window??.bringSubviewToFront(promptHud)
        
        promptHud.isUserInteractionEnabled = false
        promptHud.mode = .text
        promptHud.detailsLabel.text = message
        promptHud.detailsLabel.font = UIFont.systemFont(ofSize: 14)
        promptHud.margin = 10.0
//        promptHud.contentColor = UIColor.white
        promptHud.bezelView.backgroundColor = UIColor.black
        promptHud.bezelView.layer.cornerRadius = 10.0
        promptHud.offset.y = UIScreen.main.bounds.size.height * 2 / 5
        promptHud.removeFromSuperViewOnHide = true
        
        promptHud.hide(animated: true, afterDelay: 3)
    }
    @objc
    public static func showHud() {
        self.hideHud()
        self.showMessageHud(nil)
    }
    @objc
    public static func showLoadingHud() {
        self.hideHud()
        self.showMessageHud("Loading...")
    }
    @objc
    public static func showMessageHud(_ message: String?) {
        self.showMessageHud(message, nil)
    }
    @objc
    public static func showMessageHud(_ message: String?, _ view: UIView?) {
        self.hideHud()
        
        if #available(iOS 9.0, *) {
            let activityIndicator = UIActivityIndicatorView.appearance(whenContainedInInstancesOf: [MBProgressHUD.self])
            activityIndicator.color = UIColor.white
        }
        
        var hudSuperView = view
        if view == nil {
            let delegate = UIApplication.shared.delegate
            hudSuperView = (delegate?.window!)!
        }
        
        let hud = MBProgressHUD.showAdded(to: hudSuperView!, animated: true)
        hud.mode = .indeterminate
        hud.bezelView.backgroundColor = WVColor.WVBlackTextColor()
        hudSuperView?.bringSubviewToFront(hud)
        hud.label.text = message
    }
    @objc
    public static func hideHud() {
        self.hideHud(nil)
    }
    @objc
    public static func hideHud(_ view: UIView?) {
        var hudSuperView = view
        if hudSuperView == nil {
            let delegate = UIApplication.shared.delegate
            hudSuperView = (delegate?.window!)!
        }
        
        MBProgressHUD.hide(for: hudSuperView!, animated: true)
    }
    
    private static func hideAllHud() {
        
    }
}
