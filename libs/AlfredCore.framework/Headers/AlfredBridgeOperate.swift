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
