//
//  AlfredDeviceBindStatus.swift
//  AlfredNetManager
//
//  Created by Tianbao Wang on 2020/11/18.
//

import UIKit

public class AlfredDeviceBindStatus: ResultModel {
    @objc public var sn: String? //sn
    @objc public var mac: String?
    @objc public var bleUUID: String? 
    @objc public var rssi: Int = 0    //型号强度
    @objc public var localName: String? //蓝牙名称

    @objc public var deviceId: String?
    @objc public var password1: String?
    @objc public var isPreemptBind: String?
    @objc public var deviceType: String?     //设备类别
    @objc public var mode: String?          //型号
    @objc public var status: String?        //返还绑定状态（0-无绑定；1-已绑定，且属于此账号；2-已绑定，不属于此账号；3-设备在服务器上查询不到）
}
