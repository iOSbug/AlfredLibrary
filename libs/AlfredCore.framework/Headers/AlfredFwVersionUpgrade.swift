//
//  AlfredFwVersionUpgrade.swift
//  AlfredCore
//
//  Created by Tianbao Wang on 2020/11/19.
//

import UIKit

///固件升级
public class AlfredFwVersionUpgrade: ResultModel {
    @objc public var  success: Bool = false
    
    @objc public var  downloadUrl: String? // "https://fw-inl.alfred-iot.com/firmware/WVC/08.250/alfred_wb1_08250000109.bin",
    @objc public var  priority: String? //  "9",
    @objc public var  releaseNoteUrl: String? //  "https://fw-inl.alfred-iot.com/firmware/WVC/08.250/08.25000.01.09.md",
    @objc public var  version: String? //  "08.25000.01.09"
    
    @objc public var  deviceId: String?
}
