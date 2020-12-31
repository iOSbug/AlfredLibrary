//
//  AlfredBridge.swift
//  AlfredNetManager
//
//  Created by Tianbao Wang on 2020/11/19.
//

import UIKit

public class AlfredBridges: ResultModel {
    @objc public var infos: [AlfredBridge]?
}

public class AlfredBridge: ResultModel {
    @objc public var did: String?
    @objc public var dtype: String?
    @objc public var info: AlfredBridgeInfo?
    @objc public var slaves: [String]? //子设备id
}


public class AlfredBridgeInfo: ResultModel {
    @objc public var base: AlfredBridgeInfoBase?
    @objc public var networkConfig: AlfredBridgeInfoNetworkConfig?
    @objc public var timeConfig: AlfredTimeConfig?
    @objc public var newFwversion: AlfredFwVersionUpgrade?
    @objc public var capability: AlfredBridgeCapabilityModel?
}


public class AlfredBridgeInfoBase: ResultModel {
    @objc public var aliasName: String?
    @objc public var deviceId: String?
    @objc public var deviceType: String?
    @objc public var deviceMode: String?
    @objc public var fwVersion: String?
    @objc public var newFwVersion: String? //ROM新版本,若与fwVersion不一致,则新ROM
    @objc public var onlineStatus: String?// 离线 - 1, 在线 - 2, 升级中 - 4, 休眠中 -8
    @objc public var remoteAddr: String?
    @objc public var vendorCode: String?
    
//    var devconfig: CameraSummaryModel? //分发url
}


public class AlfredBridgeInfoNetworkConfig: ResultModel {
    @objc public var channel: String?
    @objc public var  ethMac: String?
    @objc public var  localDirectProbeUrl: String?
    @objc public var  localIp: String?
    @objc public var  localIpMask: String?
    @objc public var  netLinkType: String? // WIFI;
    @objc public var  ssid: String?
    @objc public var  wanIp: String?
    @objc public var  wlanMac: String?
    @objc public var  wifiSignal: String? // -46   门锁连接wifi的信号量（即Wi-Fi的信号强度）
}

public class AlfredBridgeCapabilityModel: ResultModel {
    @objc public var diagnose: String?
    @objc public var localStorageTypes: String?
    @objc public var networkConfig: String?
    @objc public var privLiveStream: String?
    @objc public var timeZoneVersion: String?
    @objc public var newtz: String?
}


public class AlfredBridgeBindStatus: ResultModel {
    @objc public var  deviceId: String?
    @objc public var  retCode: String? //0绑定成功 1绑定中 7被别人绑定
}
