//
//  AlfredLockCode.swift
//  AlfredCore
//
//  Created by Tianbao Wang on 2020/12/16.
//

import UIKit
import HandyJSON

public class AlfredLockCode: ResultModel {
    @objc public var index: String?
    public var type: String?
    @objc public var value: String?
    @objc public var codeAttr: String? //密钥属性：永久密钥:00  策略密钥:01  胁迫密钥:02  管理员密钥:03  无权限密钥:04  一次性密钥:FE
    
    @objc public var scheduleid: String?         //时间计划ID, -1表示无计划
    public var scheduletype: String?
    @objc public var start: String?         //如果是模式3的话，则直接为UTC时间，单位为s，如果是模式2的话，则值为"8：30"
    @objc public var end: String?         //如果是模式3的话，则直接为UTC时间，单位为s，如果是模式2的话，则值类似为"23：30"，时间为24小时制
    @objc public var week: [Int]?        ////周日-周六，如果有配置，则为1，否则为0
    
    @objc public var did: String? //门锁did
    @objc public var name: String?
    @objc public var personid: String?
    
    //密钥类型
    @objc
    public var _type: AlfredLockCodeType {
        get {
            if type == "3" {
                return .LockCodeType_RFID
            } else if type == "4" {
                return .LockCodeType_Fingerprint
            }
            return .LockCodeType_PIN
        } set{}
    }
    
    //时间计划: 1 表示一直、无限制, 2 表示周计划, 3 表示临时、时间段
    @objc
    public var _scheduletype: AlfredLockCodeSchedule {
        get {
            if scheduletype == "2" {
                return .LockCodeSchedule_Weekly
            } else if scheduletype == "3" {
                return .LockCodeSchedule_Period
            }
            return .LockCodeSchedule_Always
        } set{}
    }
    
    //云端存储的是门锁m本地时间，time需要从云端，减去手机时区，控件自动会加上手机时区，这样time就是门锁时间
    public override func mapping(mapper: HelpingMapper) {
        // 指定 parent 字段用这个方法去解析
        mapper.specify(property: &start) { (rawString) -> (String?) in
            //显示11:09不需要转换
            if rawString.contains(":") {
                return rawString
            }
            
            var utcstart: String? = ""
            // 设置系统时区为本地时区
            let localZone = TimeZone.current
            // 计算本地时区与 GMT 时区的时间差
            let interval = localZone.secondsFromGMT()
            if rawString.count > 0 {
                utcstart = "\(Int(rawString)! - interval)"
            }
            return utcstart
        }
        
        mapper.specify(property: &end) { (rawString) -> (String?) in
            //显示11:09不需要转换
            if rawString.contains(":") {
                return rawString
            }
            var utcend: String? = ""
            // 设置系统时区为本地时区
            let localZone = TimeZone.current
            // 计算本地时区与 GMT 时区的时间差
            let interval = localZone.secondsFromGMT()
            if rawString.count > 0 {
                utcend = "\(Int(rawString)! - interval)"
            }
            return utcend
        }
    }
    
    //获取周计划数据模型
    @objc public static func getWeekScheduleModel(result: String) -> AlfredLockCode {
        let keyModel = AlfredLockCode()
        let scheduleId: UInt64 = BluetoothUtils.coverFromHexStr(toInt: (result as NSString).substring(with: NSRange(location: 0, length: 2)))
        let userId: UInt64 = BluetoothUtils.coverFromHexStr(toInt: (result as NSString).substring(with: NSRange(location: 2, length: 2)))
        var codetype: UInt64 = BluetoothUtils.coverFromHexStr(toInt: (result as NSString).substring(with: NSRange(location: 4, length: 2)))
        let daysmask = BluetoothUtils.getBinaryByHex((result as NSString).substring(with: NSRange(location: 6, length: 2)))
        let starH: String = String(format: "%02d", BluetoothUtils.coverFromHexStr(toInt: (result as NSString).substring(with: NSRange(location: 8, length: 2))))
        let starM: String = String(format: "%02d", BluetoothUtils.coverFromHexStr(toInt: (result as NSString).substring(with: NSRange(location: 10, length: 2))))
        let endH: String = String(format: "%02d", BluetoothUtils.coverFromHexStr(toInt: (result as NSString).substring(with: NSRange(location: 12, length: 2))))
        let endM: String = String(format: "%02d", BluetoothUtils.coverFromHexStr(toInt: (result as NSString).substring(with: NSRange(location: 14, length: 2))))

        var weeks = [Int]()
        if daysmask != nil {
            for i in 1...7 {
                weeks.insert(Int((daysmask! as NSString).substring(with: NSRange(location: i, length: 1)))!, at: 0)
            }
        }

        keyModel.scheduleid = "\(scheduleId)"
        keyModel.index = "\(userId)"
        //pinkey
        if codetype == 1 {
            codetype = 0
        }
        keyModel.type = "0"
        keyModel.scheduletype = "2"
//        keyModel._type = .LockCodeType_PIN
//        keyModel._scheduletype = .LockCodeSchedule_Weekly
        keyModel.week = weeks
        keyModel.start = starH + ":" + starM
        keyModel.end = endH + ":" + endM
        return keyModel
    }
    
    //获取年月日计划数据模型
    @objc public static func getYMDScheduleModel(result: String) -> AlfredLockCode {
        let keyModel = AlfredLockCode()
        let scheduleId: UInt64 = BluetoothUtils.coverFromHexStr(toInt: (result as NSString).substring(with: NSRange(location: 0, length: 2)))
        let userId: UInt64 = BluetoothUtils.coverFromHexStr(toInt: (result as NSString).substring(with: NSRange(location: 2, length: 2)))
        var codetype: UInt64 = BluetoothUtils.coverFromHexStr(toInt: (result as NSString).substring(with: NSRange(location: 4, length: 2)))
        let startime = (result as NSString).substring(with: NSRange(location: 6, length: 8))
        let endtime = (result as NSString).substring(with: NSRange(location: 14, length: 8))

        let starTime: UInt64 = BluetoothUtils.coverFromHexStr(toInt: BluetoothUtils.hexStringTrans(withSmallAndBig: startime))
        let endTime: UInt64 = BluetoothUtils.coverFromHexStr(toInt: BluetoothUtils.hexStringTrans(withSmallAndBig: endtime))

        //pinkey
        if codetype == 1 {
            codetype = 0
        }
        keyModel.start = "\(946684800 + starTime)"
        keyModel.end = "\(946684800 + endTime)"
        keyModel.scheduleid = "\(scheduleId)"
        keyModel.index = "\(userId)"
        keyModel.type = "0"
        keyModel.scheduletype = "3"
//        keyModel._type = .LockCodeType_PIN
//        keyModel._scheduletype = .LockCodeSchedule_Period
        return keyModel
    }
    
    //ML2获取key模型
    @objc public static func getKeyModel(result: String) -> AlfredLockCode {
        let keyModel = AlfredLockCode()
        //0x01：PIN密码 0x02：指纹 0x03：RFID卡片
        let codetype: UInt64 = BluetoothUtils.coverFromHexStr(toInt: (result as NSString).substring(with: NSRange(location: 12, length: 2)))
        let index: UInt64 = BluetoothUtils.coverFromHexStr(toInt: (result as NSString).substring(with: NSRange(location: 14, length: 2)))
        let attr: UInt64 = BluetoothUtils.coverFromHexStr(toInt: (result as NSString).substring(with: NSRange(location: 16, length: 2)))
        let scheduletype: UInt64 = BluetoothUtils.coverFromHexStr(toInt: (result as NSString).substring(with: NSRange(location: 18, length: 2)))
        //密钥属性：永久密钥：00 策略密钥：01 胁迫密钥：02 管理员密钥：03 无权限密钥：04 一次性密钥：FE
        if attr == 0 {
//            keyModel._scheduletype = .LockCodeSchedule_Always
            keyModel.scheduletype = "1"
        } else if attr == 1 {
            //策略类型：时间计划：00 周计划：01
            if scheduletype == 1 {
//                keyModel._scheduletype = .LockCodeSchedule_Weekly
                keyModel.scheduletype = "2"
                //周计划
                let daysmask = BluetoothUtils.getBinaryByHex((result as NSString).substring(with: NSRange(location: 20, length: 2)))
                let starH: String = "\(BluetoothUtils.coverFromHexStr(toInt: (result as NSString).substring(with: NSRange(location: 22, length: 2))))"
                let starM: String = "\(BluetoothUtils.coverFromHexStr(toInt: (result as NSString).substring(with: NSRange(location: 24, length: 2))))"
                let endH: String = "\(BluetoothUtils.coverFromHexStr(toInt: (result as NSString).substring(with: NSRange(location: 26, length: 2))))"
                let endM: String = "\(BluetoothUtils.coverFromHexStr(toInt: (result as NSString).substring(with: NSRange(location: 28, length: 2))))"

                var weeks = [Int]()
                if daysmask != nil {
                    for i in 1...7 {
                        weeks.insert(Int((daysmask! as NSString).substring(with: NSRange(location: i, length: 1)))!, at: 0)
                    }
                }
                
                keyModel.week = weeks
                keyModel.start = starH + ":" + starM
                keyModel.end = endH + ":" + endM
            } else if scheduletype == 0 {
//                keyModel._scheduletype = .LockCodeSchedule_Period
                keyModel.scheduletype = "3"
                //表示临时、时间段
                let startime = (result as NSString).substring(with: NSRange(location: 20, length: 8))
                let endtime = (result as NSString).substring(with: NSRange(location: 28, length: 8))

                let starTime: UInt64 = BluetoothUtils.coverFromHexStr(toInt: BluetoothUtils.hexStringTrans(withSmallAndBig: startime))
                let endTime: UInt64 = BluetoothUtils.coverFromHexStr(toInt: BluetoothUtils.hexStringTrans(withSmallAndBig: endtime))
                
                keyModel.start = "\(946684800 + starTime)"
                keyModel.end = "\(946684800 + endTime)"
            }
        }

        keyModel.scheduleid = "\(index)"

        if codetype == 1 {
            keyModel.type = "0"
//            keyModel._type = .LockCodeType_PIN
        } else if codetype == 2 {
            keyModel.type = "4"
//            keyModel._type = .LockCodeType_Fingerprint
        } else if codetype == 3 {
            keyModel.type = "3"
//            keyModel._type = .LockCodeType_RFID
        }
        keyModel.index = "\(index)"
        keyModel.codeAttr = "\(attr)"
        
        return keyModel
    }
    
    @objc public required init() {}
}
