//
//  AlfredTimeConfig.swift
//  AlfredCore
//
//  Created by Tianbao Wang on 2020/11/19.
//

import UIKit

public class AlfredTimeZone: ResultModel {
    @objc public var version: String?
    @objc public var timeZones: [AlfredTimeConfig]?
    @objc public var tzDistricts: [TzDistrictModel]?
}

///网关时区
public class AlfredTimeConfig: ResultModel {
    @objc public var tzName: String?
    @objc public var tzValue: String?
    @objc public var dst: String?
    @objc public var tzGmt: String?
    @objc public var tzUtc: String?
    @objc public var tzString: String?
    @objc public var en: String?

    @objc public var tzDistrict: String?
}


public class TzDistrictModel: ResultModel {
    @objc public var tzName: String?
    @objc public var tzUtc: String?
    @objc public var en: String?
    @objc public var zh: String?
    @objc public var fr: String?
    @objc public var de: String?
    @objc public var es: String?
    @objc public var pt: String?
    @objc public var ja: String?
    @objc public var po: String?
}
