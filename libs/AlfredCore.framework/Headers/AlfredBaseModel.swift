//
//  AlfredBaseModel.swift
//  AlfredCore
//
//  Created by Tianbao Wang on 2020/11/19.
//

import HandyJSON

public protocol NetDecodable: HandyJSON {
    
    static func parse(json: Any) -> (Self?, NetErrorModel?)
}

extension NetDecodable {
    
    public static func parse(json: Any) -> (Self?, NetErrorModel?) {
        
        if let ret = json as? [String: Any] {
            if ret["status"] as? String == "ok" {
                
                let result = ret["result"] as? [String: Any]
                let res = self.deserialize(from: result)
                
                return (res, nil)
                
            } else if ret["ok"] as? NSNumber == 1 {
                
                return (nil, nil)
            } else {
                
                let errorM = NetErrorModel(ret["code"] as? Int,
                                        eMessage: ret["message"] as? String)
                return (nil, errorM)
            }
        }
        
        let error = NetErrorModel(-1, eMessage: "Server model is nil")
        return (nil, error)
    }
    
    public static func parseArr(json: Any) -> ([Self]?, NetErrorModel?) {
        
        if let ret = json as? [String: Any] {
            if ret["status"] as? String == "ok" {
                
                let result = ret["result"] as? NSArray
                let res = JSONDeserializer<Self>.deserializeModelArrayFrom(array: result) as? [Self]
                
                return (res, nil)
                
            } else if ret["ok"] as? NSNumber == 1 {

                return (nil, nil)
            } else {

                let errorM = NetErrorModel(ret["code"] as? Int,
                                        eMessage: ret["message"] as? String)
                return (nil, errorM)
            }
        }

        let error = NetErrorModel(-1, eMessage: "Server model is nil")
        return (nil, error)
    }
}

open class ResultModel: NSObject, NetDecodable {

    public override required init() {
        super.init()
    }

    open func mapping(mapper: HelpingMapper) {}
}
