//
//  AppDelegate.swift
//  AlfredDemo
//
//  Created by Tianbao Wang on 2020/12/14.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 15, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
        ownLoad()

        return true
    }

    //拥有者启动
    func ownLoad() {
        self.window = UIWindow()
        self.window?.rootViewController = BaseNavigationController(rootViewController: HomeViewController())
        self.window?.makeKeyAndVisible()
    }
    
    //访客启动
    func guestLoad() {
        self.window = UIWindow()
        self.window?.rootViewController = BaseNavigationController(rootViewController: GuestHomeViewController())
        self.window?.makeKeyAndVisible()
    }
}

