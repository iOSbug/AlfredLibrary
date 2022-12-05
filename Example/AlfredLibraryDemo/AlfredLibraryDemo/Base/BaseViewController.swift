//
//  BaseViewController.swift
//  DeviceAddDemo
//
//  Created by Tianbao Wang on 2020/9/14.
//  Copyright © 2020 Tianbao Wang. All rights reserved.
//

import UIKit
import SnapKit

public func LockLocalizedString(_ key: String, comment: String) -> String {
    return NSLocalizedString(key, tableName: "Lock", comment: comment)
}

public func LockLocalizedString(_ key: String) -> String {
    return LockLocalizedString(key, comment: "")
}

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = WVColor.WVViewBackColor()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = WVColor.WVViewBackColor()
        navigationController?.navigationBar.tintColor = WVColor.WVBlackTextColor()//UIColor(rgb: 0x61727A)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: WVColor.WVBlackTextColor(), NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18)]
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(image(with: WVColor.WVViewBackColor(), size: CGSize(width: UIScreen.main.bounds.size.width, height: 1)), for: UIBarMetrics.default)
        if #available(iOS 15, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            //背景色
            navBarAppearance.backgroundColor = WVColor.WVViewBackColor()
            //去掉半透明效果
            navBarAppearance.backgroundEffect = nil
            //去掉导航栏阴影（如果不设置clear，导航栏底下会有一条阴影线）
            navBarAppearance.shadowColor = UIColor.clear
            //字体颜色
            navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: WVColor.WVBlackTextColor(), NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18)]
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            navigationController?.navigationBar.standardAppearance = navBarAppearance
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_back_"), style: .plain, target: self, action: #selector(PopPrevious))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc
    @discardableResult
    public func PopPrevious() -> UIViewController? {
        return self.navigationController?.popViewController(animated: true)
    }
    
    public func PopToRootViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    public func PopToViewController<T: UIViewController>(_ viewControllerType: T.Type) {
        self.navigationController?.viewControllers.forEach({ (viewController) in
            if viewController.isKind(of: viewControllerType) {
                self.navigationController?.popToViewController(viewController, animated: true)
                return
            }
        })
    }
    
    public func Dissmiss() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    public func DismissWithCompletion(_ completion: @escaping () -> Void) {
        self.dismiss(animated: true, completion: completion)
    }
    
    public func PresentViewController(_ vc: UIViewController) {
        if vc.isKind(of: UIViewController.self) {
            vc.modalPresentationStyle = .fullScreen
            PresentViewController(vc, completion: nil)
        }
    }
    
    public func PresentViewController(_ vc: UIViewController, completion: (()->Void)?) {
        if vc.isKind(of: UIViewController.self) {
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: completion)
        }
    }
    
    public func PushViewController(_ vc: UIViewController) {
        if vc.isKind(of: UIViewController.self) && navigationController != nil {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    public class func topViewController() -> UIViewController? {
        var result: UIViewController?
        if let window = UIApplication.shared.delegate?.window {
            let appRootVC = window?.rootViewController
            if appRootVC?.presentedViewController != nil {
                result = appRootVC?.presentedViewController
            } else if appRootVC is UINavigationController {
                let navi = appRootVC as! UINavigationController
                result = navi.topViewController
            } else if appRootVC is UITabBarController {
                let navi = (appRootVC as! UITabBarController).selectedViewController
                if navi is UINavigationController {
                    result = (navi as! UINavigationController).children.last
                }
            }
        }
        
        return result
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension UIImageView {
    
    //旋转
    func rotation(_ stop: Bool = false) {
        if stop {
            self.layer.removeAnimation(forKey: "imageviewTransform")
            self.transform = CGAffineTransform()
            return
        }
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = Double.pi
        animation.duration = 1
        animation.autoreverses = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.repeatCount = MAXFLOAT
        self.layer.add(animation, forKey: "imageviewTransform")
    }
}

func image(with color: UIColor, size: CGSize) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
      guard let context = UIGraphicsGetCurrentContext() else {
        return nil
      }
      
      context.scaleBy(x: 1.0, y: -1.0)
      context.translateBy(x: 0.0, y: -size.height)
      
      context.setBlendMode(.multiply)
      
      let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
      color.setFill()
      context.fill(rect)
      
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return image?.withRenderingMode(.alwaysOriginal)
}
