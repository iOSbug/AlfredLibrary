//
//  CacheManager.swift
//  AlfredNetManager
//
//  Created by Tianbao Wang on 2020/12/15.
//

import UIKit
import HandyJSON

public class CacheManager: NSObject {
    @objc public static let shared = CacheManager()

    @objc public var lockList = [AlfredLock]()      //门锁数据
    @objc public var bridgeList = [AlfredBridge]() //网关数据
    
    @objc public func clear() {
        lockList.removeAll()
        bridgeList.removeAll()
    }
    
    //解绑某一个设备
    @objc public func unbindDevice(deviceId: String) {
        for (i,lock) in self.lockList.enumerated() {
            if lock.deviceid == deviceId {
                self.lockList.remove(at: i)
                break
            }
        }
        for (i,gateway) in self.bridgeList.enumerated() {
            if gateway.did == deviceId {
                self.bridgeList.remove(at: i)
                break
            }
        }

    }
    
    //根据门锁deviceid获取门锁
    @objc public func getLockDevice(_ deviceId: String?) -> AlfredLock? {
        for lock in self.lockList {
            if lock.deviceid == deviceId {
                return lock
            }
        }
        return nil
    }
    
    //获取门锁绑定的网关数据
    @objc public func getLockBindGateway(_ device: AlfredLock?) -> AlfredBridge? {
        for gate in CacheManager.shared.bridgeList {
            if let slaves = gate.slaves {
                if let deviceId = device?.deviceid {
                    if slaves.contains(deviceId) {
                        return gate
                    }
                }
            }
        }
        return nil
    }
    
    //根据网关id获取网关数据
    @objc public func getMygatewayByGatewayDid(_ did: String?) -> AlfredBridge? {
        for gate in CacheManager.shared.bridgeList {
            if did == gate.did {
                return gate
            }
        }
        return nil
    }
    
    //获取门锁绑定的网关数据
    @objc public func getMygatewayByLockId(_ deviceId: String?) -> AlfredBridge? {
        for gate in CacheManager.shared.bridgeList {
            if let slaves = gate.slaves {
                if let deviceId = deviceId {
                    if slaves.contains(deviceId) {
                        return gate
                    }
                }
            }
        }
        return nil
    }
    
    //根据网关id获取所有下挂门锁list
    @objc public func getMyLocksByGatewayDid(_ did: String?) -> [AlfredLock] {
        var locklist = [AlfredLock]()
        for gate in CacheManager.shared.bridgeList {
            if did == gate.did, let slaves = gate.slaves {
                for deviceId in slaves {
                    if let dev = getLockDevice(deviceId) {
                        locklist.append(dev)
                    }
                }
                break
            }
        }
        return locklist
    }
    
    //保存网关时区
    @objc public func saveGatewayTimezone(_ gatewayId: String, _ timezones: AlfredTimeZone) {
        let key = "saveGatewayTimezone" + gatewayId
        UserDefaults.standard.set(timezones.toJSON(), forKey: key)
    }
    
    @objc public func getGatewayTimezone(_ gatewayId: String) -> AlfredTimeZone? {
        let key = "saveGatewayTimezone" + gatewayId
        if let timezonesDic = UserDefaults.standard.object(forKey: key) as? [String: Any] {
            if let timezones = JSONDeserializer<AlfredTimeZone>.deserializeFrom(dict: timezonesDic) {
                return timezones
            }
        }
        return nil
    }
}
