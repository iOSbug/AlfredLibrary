//
//  AlfredLockRecord.swift
//  AlfredCore
//
//  Created by Tianbao Wang on 2020/11/20.
//

import UIKit
import HandyJSON

public class AlfredLockRecords: ResultModel {
    @objc public var logs: [AlfredLockRecord]?
    @objc public var lasttime: String?
}

public class AlfredLockRecord: ResultModel {
    @objc public var name: String?
    @objc public var time: String?
    @objc public var type: String?
    @objc public var index: String?
    @objc public var lockevent: String?
    
    @objc public var recordID: AlfredLockRecordID {
        get {
            return AlfredLockRecordID(rawValue: UInt(Int(lockevent ?? "0") ?? 0)) ?? .Unknown
        }set{}
    }
    
    public override func mapping(mapper: HelpingMapper) {
        // 指定 parent 字段用这个方法去解析
        mapper.specify(property: &time) { (rawString) -> (String?) in
            var utcTime: String? = ""
            // 设置系统时区为本地时区
            let localZone = TimeZone.current
            // 计算本地时区与 GMT 时区的时间差
            let interval = localZone.secondsFromGMT()
            if rawString.count > 0 {
                utcTime = "\(Int(rawString)! - interval)"
            }
            return utcTime
        }
    }
    
    //app开门上报
    @objc
    public static func getCurrentRecord(record: String) -> AlfredLockRecord? {
        let timestr = (record as NSString).substring(with: NSRange(location: 16, length: 8))
        let resultTime: UInt64 = BluetoothUtils.coverFromHexStr(toInt: BluetoothUtils.hexStringTrans(withSmallAndBig: timestr))
        
        let userid: UInt64 = BluetoothUtils.coverFromHexStr(toInt: (record as NSString).substring(with: NSRange(location: 14, length: 2)))
        
        let sourceStr = (record as NSString).substring(with: NSRange(location: 10, length: 2))

        let codeStr = (record as NSString).substring(with: NSRange(location: 12, length: 2))
        
        //app开门
        if (sourceStr == "ff" && userid == 103 || Int(sourceStr) == 8 || sourceStr == "67") && Int(codeStr) == 2 {
            let log = AlfredLockRecord()
            log.time = "\(946684800 + resultTime)"
            log.index = "\(userid)"
            log.type = "\(userid)"
            return log
        }
        return nil
    }
    
    //app开门，0x1a,获取门锁记录（新）
    @objc
    public static func getNewLockLog(_ logstr: String) -> AlfredLockRecord? {
        let eventid = Int(BluetoothUtils.coverFromHexStr(toInt: (logstr as NSString).substring(with: NSRange(location: 8, length: 2))))
        let type1 = Int(BluetoothUtils.coverFromHexStr(toInt: (logstr as NSString).substring(with: NSRange(location: 10, length: 2))))
        let index1 = Int(BluetoothUtils.coverFromHexStr(toInt: (logstr as NSString).substring(with: NSRange(location: 12, length: 2))))
        
        let timestr = (logstr as NSString).substring(with: NSRange(location: 18, length: 8))
        let resultTime: UInt64 = BluetoothUtils.coverFromHexStr(toInt: BluetoothUtils.hexStringTrans(withSmallAndBig: timestr))
        
        //大于24小时，开门记录时间不正确，抛弃掉
        if Int(946684800 + resultTime) >= Int((Date().timeIntervalSince1970) + 24*60*60) {
            return nil
        }
        if eventid == 0 || eventid == 255 {
            return nil
        }
        
        let log = AlfredLockRecord()
        log.time = "\(946684800 + resultTime)"
        log.type = "\(type1)"
        log.index = "\(index1)"
        log.lockevent = "\(eventid)"
        return log
    }
    
    public static func getCurrentRecordNotApp(record: String) -> AlfredLockRecord? {
        let timestr = (record as NSString).substring(with: NSRange(location: 20, length: 8))
        let resultTime: UInt64 = BluetoothUtils.coverFromHexStr(toInt: BluetoothUtils.hexStringTrans(withSmallAndBig: timestr))
        let userid = Int(BluetoothUtils.coverFromHexStr(toInt: (record as NSString).substring(with: NSRange(location: 18, length: 2))))
        let sourceStr = (record as NSString).substring(with: NSRange(location: 14, length: 2))
        let codeStr = (record as NSString).substring(with: NSRange(location: 16, length: 2))
        //app开门,过滤掉,自动开锁不过滤,z-wave开门也是app开门不过滤0x69
        if (sourceStr == "ff" && userid == 103 || (Int(sourceStr) == 8 && userid != 104)) && Int(codeStr) == 2 {
            if userid != 105 {
                return nil
            }
        }
        //大于24小时，开门记录时间不正确，抛弃掉
        if Int(946684800 + resultTime) >= Int((Date().timeIntervalSince1970) + 24*60*60) {
            return nil
        }
        if (sourceStr == "02" && userid != 100) {
            return nil
        }
        let log = AlfredLockRecord()
        log.time = "\(946684800 + resultTime)"
        log.index = "\(userid)"
        if sourceStr.count > 1 {
            log.type = (sourceStr as NSString).substring(from: 1)
        }
        if userid == 105 {
            log.type = "\(userid)"
        }
        
        return log
    }
    
    
    //获取门锁记录（新）0x19
    public static func getLockAllLog(_ logstr: String) -> AlfredLockRecord? {
        let eventid = Int(BluetoothUtils.coverFromHexStr(toInt: (logstr as NSString).substring(with: NSRange(location: 20, length: 2))))
        let type1 = Int(BluetoothUtils.coverFromHexStr(toInt: (logstr as NSString).substring(with: NSRange(location: 22, length: 2))))
        let index1 = Int(BluetoothUtils.coverFromHexStr(toInt: (logstr as NSString).substring(with: NSRange(location: 24, length: 2))))
        
        let timestr = (logstr as NSString).substring(with: NSRange(location: 30, length: 8))
        let resultTime: UInt64 = BluetoothUtils.coverFromHexStr(toInt: BluetoothUtils.hexStringTrans(withSmallAndBig: timestr))
        
        //大于24小时，开门记录时间不正确，抛弃掉
        if Int(946684800 + resultTime) >= Int((Date().timeIntervalSince1970) + 24*60*60) {
            return nil
        }
        if eventid == 0 || eventid == 255 {
            return nil
        }
        
        let log = AlfredLockRecord()
        log.time = "\(946684800 + resultTime)"
        log.type = "\(type1)"
        log.index = "\(index1)"
        log.lockevent = "\(eventid)"
        return log
    }
    

}
