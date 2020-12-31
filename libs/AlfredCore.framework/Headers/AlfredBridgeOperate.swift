//
//  AlfredBridgeOperate.swift
//  AlfredCore
//
//  Created by Tianbao Wang on 2020/11/23.
//

import UIKit

public class AlfredBridgeOperate: ResultModel {
    @objc public var status: String? // 0: 初始值，尚无结果； 1: 为成功； 2: 失败
    @objc public var lockStatus: String?  // 门锁状态，1是开门 0是关门
    @objc public var err: String? //网关错误详情
}


//门锁状态
public class AlfredBridgeLockStatusListModel: ResultModel {
    @objc public var value: [AlfredBridgeStatusModel]?
}

//网关状态
public class AlfredBridgeStatusModel: ResultModel {
    @objc public var deviceId: String?  //网关id
    @objc public var onlineStatus: String? // offline - 1, online - 2, UPGRADE - 4
    @objc public var subDevices: [AlfredBridgeLockStatusModel]?
}

//门锁状态
public class AlfredBridgeLockStatusModel: ResultModel {
    @objc public var deviceId: String?   //门锁id
    @objc public var onlineStatus: String? // offline - 1, online - 2, UPGRADE - 4
    @objc public var lockStatus: String?  // 门锁状态，1是开门 0是关门
    @objc public var malfunction: String?
    @objc public var blesignal: String? //  网关探测门锁蓝牙信号量
    @objc public var blesignalTs: String?
}
