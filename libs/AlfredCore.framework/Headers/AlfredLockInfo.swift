//
//  AlfredLockInfo.swift
//  AlfredCore
//
//  Created by Tianbao Wang on 2020/12/18.
//

import UIKit

public class AlfredLockInfo: ResultModel {
    //门锁功能 LockFun
    var isPwdUnlock: Bool = false     //bit0: 密码开锁功能 =0:不支持 =1:支持
    var isRfidUnlock: Bool = false    //bit1: RFID卡开锁功能 =0:不支持 =1:支持
    var isFingerUnlock: Bool = false  //bit2: 指纹开锁功能 =0:不支持 =1:支持
    var isRemoteUnlock: Bool = false  //bit3: 远程开锁功能 =0:不支持 =1:支持
    var isArming: Bool = false       //bit4: 一键布防功能 =0:不支持 =1:支持
    var isRtc: Bool = false         //bit5:RTC 时钟 =0:不支持 =1:支持
    var isIrisRec: Bool = false      //bit6:虹膜识别开锁功能 =0:不支持 =1:支持
    var isVoiceRec: Bool = false    //bit7:声音识别开锁功能 =0:不支持 =1:支持
    var isOneButtonUnlock: Bool = false  //bit8:一键开锁功能 =0:不支持 =1:支持
    var isAutoMode: Bool = false  //bit9:自动模式 =0:不支持 =1:支持
    var isDoorMagnet: Bool = false  //bit10:门磁 =0:不支持 =1:支持
    var isFingerVein: Bool = false  //bit11:指静脉 =0:不支持 =1:支持
    var isFaceRecognition: Bool = false  //bit12:人脸识别 =0:不支持 =1:支持
    var isSafeMode: Bool = false  //bit13:安全模式 =0:不支持=1:支持
    var isAntilock: Bool = false  //bit14:反锁=0:不支持=1:支持

    //门锁状态 LockState
    var lockTongueState: String? //bit0:锁斜舌状态 =0:Lock =1:Unlock – 阻塞(Blocked)
    @objc public var mainLockTongueState: String? //bit1:主锁舌(联动锁舌)状态 =0:Lock =1:Unlock
    @objc public var antilockState: String? //bit2:反锁(独立锁舌)状态 =0:Lock =1:Unlock
    @objc public var doorState: String? //bit3:门状态 =0:Lock =1:Unlock
    @objc public var doorMagnetState: String? // bit4:门磁状态 =0:Close =1:Open
    @objc public var safeModeState: String? // bit5:安全模式 =0:不启用或不支持 =1:启用安全模式
    @objc public var adminPwdState: String? //bit6:默认管理密码 =0:出厂密码 =1:已修改
    @objc public var autoState: String? // bit7:手自动模式(LockFun:bit10=1) =0:手动 =1:自动
    @objc public var armingState: String? // bit8:布防状态(LockFun:bit4=1) =0:未布防 =1:已布防
    @objc public var powersave: String? // bit9:蓝牙开关状态=0:OFF  =1:ON
    @objc public var soundVolume: AlfredLockVoice = .LockVoice_Loud //音量
    @objc public var language: String? //锁语言 ISO 639-1 标准 zh:中文(默认) en:英语
    @objc public var battery: String?   //锁电量 0~100%
    @objc public var batterytime: String?   //锁电量时间
    @objc public var timeSeconds: UInt64 = 0 //锁时间 时间秒计数。以 2000-01-01 00:00:00(本地时间)为起 点开始计数

    @objc
    public static func getLockInfo(_ info: String) -> AlfredLockInfo? {
        let model = AlfredLockInfo()
        
        //LockFun
        let lockFun = (info as NSString).substring(to: 8)
        //高位转低位
        if let slockFun = BluetoothUtils.hexStringTrans(withSmallAndBig: lockFun) {
            //十六进制转换为二进制,低位在右边，高位在左边
            let lockfun1 = (slockFun as NSString).substring(with: NSRange(location: 6, length: 2))
            if let binLockfun1 = BluetoothUtils.getBinaryByHex(lockfun1) {
                for (i,str) in binLockfun1.enumerated() {
                    let isSupport = (str == "1")
                    switch i {
                    case 7:
                        model.isPwdUnlock = isSupport
                    case 6:
                        model.isRfidUnlock = isSupport
                    case 5:
                        model.isFingerUnlock = isSupport
                    case 4:
                        model.isRemoteUnlock = isSupport
                    case 3:
                        model.isArming = isSupport
                    case 2:
                        model.isRtc = isSupport
                    case 1:
                        model.isIrisRec = isSupport
                    case 0:
                        model.isVoiceRec = isSupport
                    default:
                        break
                    }
                }
            }
            
            let lockfun2 = (slockFun as NSString).substring(with: NSRange(location: 4, length: 2))
            if let binLockfun2 = BluetoothUtils.getBinaryByHex(lockfun2) {
                for (i,str) in binLockfun2.enumerated() {
                    let isSupport = (str == "1")
                    switch i {
                    case 7:
                        model.isOneButtonUnlock = isSupport
                    case 6:
                        model.isAutoMode = isSupport
                    case 5:
                        model.isDoorMagnet = isSupport
                    case 4:
                        model.isFingerVein = isSupport
                    case 3:
                        model.isFaceRecognition = isSupport
                    case 2:
                        model.isSafeMode = isSupport
                    case 1:
                        model.isAntilock = isSupport
                    default:
                        break
                    }
                }
            }
        }
        
        //LockState
        let lockState = (info as NSString).substring(with: NSRange(location: 8, length: 8))
        if let slockState = BluetoothUtils.hexStringTrans(withSmallAndBig: lockState) {
            //十六进制转换为二进制
            let lockstate1 = (slockState as NSString).substring(with: NSRange(location: 6, length: 2))
            if let binLockstate1 = BluetoothUtils.getBinaryByHex(lockstate1) {
                for (i,str) in binLockstate1.enumerated() {
                    switch i {
                    case 7:
                        model.lockTongueState = "\(str)"
                    case 6:
                        model.mainLockTongueState = "\(str)"
                    case 5:
                        model.antilockState = "\(str)"
                    case 4:
                        model.doorState = "\(str)"
                    case 3:
                        model.doorMagnetState = "\(str)"
                    case 2:
                        model.safeModeState = "\(str)"
                    case 1:
                        model.adminPwdState = "\(str)"
                    case 0:
                        model.autoState = "\(str)"
                    default:
                        break
                    }
                }
            }
            
            let lockstate2 = (slockState as NSString).substring(with: NSRange(location: 4, length: 2))
            if let binLockstate2 = BluetoothUtils.getBinaryByHex(lockstate2) {
                model.armingState = (binLockstate2 as NSString).substring(with: NSRange(location: 7, length: 1))
                
                //蓝牙状态开关 0是关闭，1是开启
                let bluetoothOpen = (binLockstate2 as NSString).substring(with: NSRange(location: 6, length: 1))
                if bluetoothOpen == "0" {
                    model.powersave = "1"
                } else {
                    model.powersave = "0"
                }
            }
        }
        
        //SoundVolume
        let soundVolume = (info as NSString).substring(with: NSRange(location: 16, length: 2))
        if soundVolume == "00" {
            //0x00:Silent Mode 静音
            model.soundVolume = .LockVoice_Mute
        } else if soundVolume == "01" {
            //0x01:Low Volume 低音量
            model.soundVolume = .LockVoice_Sofly
        } else if soundVolume == "02" {
            //0x02:High Volume 高音量
            model.soundVolume = .LockVoice_Loud
        }

        //language
        let language = (info as NSString).substring(with: NSRange(location: 18, length: 4))
        if let languageData = NSStringToDataUtils.convertHexStr(toData: language) {
            model.language = String(data: languageData, encoding: .ascii)
        }

        //battery
        let battery = (info as NSString).substring(with: NSRange(location: 22, length: 2))
        let bina = BluetoothUtils.getBinaryByHex(battery)
        let newBina = "0" + (bina! as NSString).substring(from: 1)
        var batteryI = BluetoothUtils.getDecimalByBinary(newBina)
        if batteryI == 0 {
            batteryI = 1
        } else if batteryI > 100 {
            batteryI = 100
        }
        model.battery = "\(batteryI)"
        model.batterytime = "\(Date().timeIntervalSince1970)"
        
        //TimeSeconds
        let timeSeconds = (info as NSString).substring(with: NSRange(location: 24, length: 8))
        let resultTime: UInt64 = BluetoothUtils.coverFromHexStr(toInt: BluetoothUtils.hexStringTrans(withSmallAndBig: timeSeconds))
        model.timeSeconds = 946684800 + resultTime

        return model
    }

    required init() {}
}
