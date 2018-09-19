//
//  XBAddressManager.swift
//  XBPMDev
//
//  Created by mac on 2018/4/13.
//  Copyright © 2018年 mac-cx. All rights reserved.
//

import UIKit
import ObjectMapper
struct XBAddressModel:Mappable {
    
    
    var name: String?
    var city: [XBAddressCityModel]?

    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        name                <- map["name"]
        city                <- map["city"]

    }
    
}
struct XBAddressCityModel:Mappable {
    
    
    var name: String?
    var area: [String]?
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        name                <- map["name"]
        area                <- map["area"]
        
    }
    
}


class XBAddressManager: NSObject {
    /**
     *   解析City数据，
     */
     func loadJsonObjectMapper() -> [XBAddressModel]? {
        if let path = Bundle.main.path(forResource: "city", ofType: "json") {
            do {
                let json_str = try String(contentsOf: URL(fileURLWithPath: path), encoding: String.Encoding.utf8)
                if let dataFromString   = json_str.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                    let json            = JSON(dataFromString)
                     let a               = json["province"].arrayObject
                    if let arr = Mapper<XBAddressModel>().mapArray(JSONObject: a) {
                         return arr
                    }
                   return nil
                    
                }
            }
            catch let _ {
                // Error handling
                return nil
            }

        }
        return nil
    }
    
}
