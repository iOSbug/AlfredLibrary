//
//  AlfredDeviceList.swift
//  AlfredCore
//
//  Created by Tianbao Wang on 2020/12/15.
//

import UIKit

public class AlfredDeviceList: ResultModel {
    public var conDevices: [ConDevice]?
    public var devGenerals: [DevGeneral]?
}

public class ConDevice: ResultModel {
    @objc public var deviceId: String?   //设备id
    var mac: String?        //设备mac
    @objc public var deviceType: String?        //设备类型，1-普通摄像头，2-门锁，3-电池摄像头，4-可视门铃，8-网关
    @objc public var aliasName: String?  //设备别名
    @objc public var conType: String?    //和账户的关联类型，0-绑定，1-分享，2-子设备
    @objc public var conStatus: String?  //当前的关联状态，0-无效，1-有效
    var conTs: String?      //创建关联的时间戳
}

public class DevGeneral: ResultModel {
    @objc public var deviceId: String?
    var deviceType: String?
    var deviceMode: String?
    var vendorCode: String?
    var accessPubKey: String?
    var accessPriKey: String?
    var context: String?
    @objc public var slaves: [String]?  //子设备
    var master: String?   //父设备
}
