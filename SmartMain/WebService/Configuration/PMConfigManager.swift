//
//  PMConfigManager.swift
//  XBPMDev
//
//  Created by mac on 2018/3/28.
//  Copyright © 2018年 mac-cx. All rights reserved.
//

import UIKit
/// 配置文件 Configuration 管理类， 取出对应的字段
class ConfigManager: NSObject {
    static let share = ConfigManager()
    var configInfo : [String: String] = [:]
    override init() {
        super.init()
        
        if let info = Bundle.main.infoDictionary, let plistPath = Bundle.main.path(forResource: "Configuration", ofType: "plist"){
            if  let configuration = info["Configuration"],let configDic = NSDictionary.init(contentsOfFile: plistPath) {
                 self.configInfo = configDic.object(forKey: configuration) as! [String : String]
             }
        }
    }
    /**
     *   获取服务器地址
     */
    class func getServiceUrl() -> String {
        return ConfigManager.share.configInfo["HermesUrl"]!
    }
    /**
     *   获取指定Key 的Value
     */
    class func getConfigInfo(_ withName:String) -> String {
        return ConfigManager.share.configInfo[withName]!
    }
    
}
