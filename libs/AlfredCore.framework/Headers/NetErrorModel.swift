//
//  ErrorModel.swift
//  AlfredCore
//
//  Created by Tianbao Wang on 2020/11/18.
//

import UIKit

public class NetErrorModel: NSObject {
    @objc
    public var eCode: Int = -1
    @objc
    public var eMessage: String?
    
    public init(_ eCode: Int?, eMessage: String?) {
        self.eCode = eCode ?? -1
        self.eMessage = eMessage ?? "server internal error"
    }
    
    @objc
    public override init() {
        super.init()
    }
}
