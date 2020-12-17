//
//  AlfredBridgePair.swift
//  AlfredCore
//
//  Created by Tianbao Wang on 2020/11/23.
//

import UIKit

public class AlfredBridgePair: ResultModel {
    @objc public var deviceid: String?
    @objc public var subDeviceId: String?
    @objc public var status: String? // 0: 初始值，尚无结果； 1: 可绑定； 2: 不可绑定
    
    @objc public var value: Bool = false
}
