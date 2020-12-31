//
//  DeviceToken.swift
//  AlfredCore
//
//  Created by Tianbao Wang on 2020/11/25.
//

import UIKit

public class DeviceToken: ResultModel {
    @objc public var token: String?
    public var expireSec: Int?
}
