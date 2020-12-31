//
//  AlfredBridgeHotspot.swift
//  AlfredCore
//
//  Created by Tianbao Wang on 2020/11/25.
//

import UIKit

public class AlfredBridgeHotspot: ResultModel {
    @objc public var ssid: String?  //ssid
    @objc public var open: Bool = false  //open 0 - 加密的SSID 1 - 开放的SSID
    @objc public var signal: Int = 30 // signal
    @objc public var i: String?  //index
}
