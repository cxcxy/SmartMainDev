//
//  BSShareID.swift
//  BSMaster
//
//  Created by 陈旭 on 2017/10/18.
//  Copyright © 2017年 陈旭. All rights reserved.
//

import UIKit

//MARK:第三方Key
public struct XBThirdID {
    
    public struct AppStore {
        public static let appID       = ""
    }
    
}
public struct XBJpush {
    public static let appKey                    = XBUtil.getHermesConfiguration("JPushAppKey")
    public static let channel                   = "Publish channel"
    public static let apsForProduction:Bool     = XBUtil.getHermesConfiguration("JPushForProduction") == "0" ? false:true
}
public struct XBBugly {
//
    public static let appID       = XBUtil.getHermesConfiguration("BuglyAppId")
    public static let appKey      = XBUtil.getHermesConfiguration("BuglyAppKey")
}
