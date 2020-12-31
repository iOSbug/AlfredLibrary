//
//  AlfredLock.swift
//  AlfredNetManager
//
//  Created by Tianbao Wang on 2020/11/19.
//

import UIKit
import HandyJSON

public class AlfredLock: ResultModel {
    @objc public var _id: String!
    @objc public var unavailable: Bool = false //设备数据是否可用，默认可用
    @objc public var deviceid: String?
    @objc public var mode: String?
    @objc public var imode: String?
    @objc public var umode: String?
    @objc public var mac: String?
    @objc public var xsn: String?
    @objc public var type: String?
    @objc public var doorsensor: String? //门磁状态
    @objc public var extend: AlfredLockExtendModel?
    
    @objc public var connectBridge: Bool = false //是否关联网关,默认未关联网关，显示蓝牙
    @objc public var connectState: AlfredLockConnectState = .LockConnectState_Unconnect //门锁在线状态，默认离线
    @objc public var lockState: AlfredLockStatus = .LockState_Locked //门锁状态,默认上锁
    @objc public var lockInfo: AlfredLockInfo? //一次性获取门锁信息（开关门状态，电量，布防，反锁等）
    @objc public var ability: AlfredLockAbilityModel? //能力级
    @objc public var gatewayLockBleSignal: String? //在有网关的情况下，网关探测门锁蓝牙信号量
}


//设备信息
public class AlfredLockExtendModel: ResultModel {
    @objc public var name: String?
    @objc public var password1: String?
    @objc public var password2: String?
    @objc public var bluuids: [AlfredInfoBluuidsModel]? //外设uuids
    @objc public var keys: [AlfredLockCode]?
    
    @objc public var systemId: String?
    @objc public var modelnum: String?
    @objc public var fwversion: String?
    @objc public var hardversion: String?
    @objc public var softversion: String?
    @objc public var bluetoothname: String? //蓝牙名称
    
    @objc public var wfwversion: String? //Wi-Filock Wi-Fi
    @objc public var whardversion: String? //Wi-Filock Wi-Fi
    @objc public var wmode: String? //Wi-Filock Wi-Fi
    @objc public var wsn: String? //Wi-Filock Wi-Fi
    
    @objc public var mfwversion: String? //Wi-Filock 人脸模组
    @objc public var mhardversion: String? //Wi-Filock 人脸模组
    @objc public var mmode: String? //Wi-Filock 人脸模组
    @objc public var msn: String? //Wi-Filock 人脸模组
    @objc public var mtype: String? //Wi-Filock 人脸模组类型
    
    @objc public var latitude: String?
    @objc public var longitude: String?  //经纬度
    @objc public var autounlockradius: String? //半径范围
    @objc public var autounlockenable: String? //自动开锁开关 0关，1开
    @objc public var autounlocktimeout: String? = "5"//自动开锁超时时间(默认5分钟)
    @objc public var powersave: String? //节电模式 0关，1开
    @objc public var insidelock: String?
    @objc public var leavemode: String?
    @objc public var autolock: String?
    @objc public var language: String?
    @objc public var voice: String?
    @objc public var admincodes: String? //1管理员密码已修改 0未修改
    @objc public var safemode: String? //安全模式 1开启，0未开启
    @objc public var infrared: String? //红外
    @objc public var vibratewarning: String? //保险柜震动告警

    @objc public var battery: String?    //电量
    @objc public var batterytime: String?//电量上报的时间
    @objc public var timezone: String? //门锁时区
    
    @objc public var philipscompatible: String? //只为philips兼容处理，1代表旧产品 0代表新产品
    @objc public var platform: String? //1: TI 2: PSOC6 3: stm32wb
    
    @objc public var pushenable: String? //单个门锁推送开关
    @objc public var hijack: String? //胁迫功能的开关,1为开，0为关
    
    @objc public var maxpinkey: String?          //pinkey最大个数
    @objc public var maxfingerprint: String?     //指纹最大个数
    @objc public var maxaccesscard: String?      //卡片最大个数
    @objc public var maxschedule: String?        //时间计划最大个数
    
    //使用blowfish解密
    public override func mapping(mapper: HelpingMapper) {
        // 指定 parent 字段用这个方法去解析
        mapper.specify(property: &password1) { (rawString) -> (String?) in
            var returnPassword1: String = ""
            if let blowFishDecodingPassword1 = NSStringToBlowfishUtils.blowFishDecoding(withKey: BlowFishKey, andStr: rawString) {
                if blowFishDecodingPassword1.contains("\0") {
                    returnPassword1 = (blowFishDecodingPassword1 as NSString).replacingOccurrences(of: "\0", with: "")
                } else {
                    returnPassword1 = blowFishDecodingPassword1
                }
            }
            
            return returnPassword1
        }
        
        mapper.specify(property: &password2) { (rawString) -> (String?) in
            var returnPassword2: String = ""
            if let blowFishDecodingPassword2 = NSStringToBlowfishUtils.blowFishDecoding(withKey: BlowFishKey, andStr: rawString){
                if blowFishDecodingPassword2.contains("\0") {
                    returnPassword2 = (blowFishDecodingPassword2 as NSString).replacingOccurrences(of: "\0", with: "")
                } else {
                    returnPassword2 = blowFishDecodingPassword2
                }
            }
            return returnPassword2
        }
        
        mapper.specify(property: &latitude) { (rawString) -> (String?) in
            var returnLatitude: String = ""
            if let blowFishDecodingLatitude = NSStringToBlowfishUtils.blowFishDecoding(withKey: BlowFishKey, andStr: rawString) {
                if blowFishDecodingLatitude.contains("\0") {
                    returnLatitude = (blowFishDecodingLatitude as NSString).replacingOccurrences(of: "\0", with: "")
                } else {
                    returnLatitude = blowFishDecodingLatitude
                }
            }
            return returnLatitude
        }
        
        mapper.specify(property: &longitude) { (rawString) -> (String?) in
            var returnLongitude: String = ""
            if let blowFishDecodingLongitude = NSStringToBlowfishUtils.blowFishDecoding(withKey: BlowFishKey, andStr: rawString) {
                if blowFishDecodingLongitude.contains("\0") {
                    returnLongitude = (blowFishDecodingLongitude as NSString).replacingOccurrences(of: "\0", with: "")
                } else {
                    returnLongitude = blowFishDecodingLongitude
                }
            }
            return returnLongitude
        }
    }
    
    required init() {}
}

//能力级
public class AlfredLockAbilityModel: ResultModel {
    @objc public var RFID: AbilityModel?      //RFID卡开锁
    @objc public var autolock: AbilityModel?   //自动关锁
    var autounlock: AbilityModel?  //自动开锁
    @objc public var bluetooth: AbilityModel?  //蓝牙开关
    var faceid: AbilityModel?     //人脸开锁
    @objc public var fingerprint: AbilityModel?  //指纹开锁
    var infrared: AbilityModel?    //红外开关
    @objc public var insidelock: AbilityModel?  //反锁
    @objc public var language: AbilityModel?   //语言 "zh"、"en"、"fr"、"es"、"pt"
    @objc public var leavemode: AbilityModel?  //布防
    var machinery: AbilityModel?  //机械钥匙
    var mode: String?
    var password: AbilityModel?   //密码开锁
    @objc public var safemode: AbilityModel?  //安全模式
    var vein: AbilityModel?      //指静脉开锁
    @objc public var voice: AbilityModel? //语音 0x00：静音 0x01:  低音量 0x02:  高音量
    var admincodes: AbilityModel? //修改管理员密码
    var vibratewarning: AbilityModel? //保险柜震动报警
    var hijack: AbilityModel? //胁迫密码
    
    required init() {}
}

public class AbilityModel: ResultModel {
    @objc public var enable: String? //0/1
    var range: String? // "0,1";
    var value: String? //0/1
    
    required init() {}
}

//Wi-Filock netconfig
class WiFiLockNetworkConfigModel: ResultModel {
    var WIFI: String?
    var channel: String?
    var rpassword: String?
    var ssid: String?
    var wifiSignal: String? // 门锁连接wifi的信号量（即Wi-Fi的信号强度）
    
    required init() {}
}


//钥匙
 public class AlfredInfoBluuidsModel: ResultModel {
    @objc public var bluuid: String?  //外设uuid，门锁
    @objc public var puuid: String?   //手机的udid
}
