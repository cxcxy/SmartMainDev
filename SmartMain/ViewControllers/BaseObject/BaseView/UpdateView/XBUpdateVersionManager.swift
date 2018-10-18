//
//  XBUpdateVersionManager.swift
//  XBShinkansen
//
//  Created by mac on 2017/12/21.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit
import ObjectMapper
enum XBUpdateVersionType {
    /**
     *   当前为最新的版本   ==
     */
    case latestVersion
    /**
     *   当前版本落后，需要更新 <
     */
    case oldVersion
    /**
     *   当前版本大于后台服务器版本，说明，在appstroe 审核中  >
     */
    case underReview
    
}
//MARK:管理员为部门授权人的部门信息
class XBUpdateVersionModel: Mappable {
    
    var isupdate    : Int?         // 1=强制更新，2=非强制更新
    var version     : String?      // 版本号   显示在UI上面的版本号
    var remark      : [String]?    // 更新内容
    var iosurl      : String?      // ios 更新地址
    var androidurl  : String?
    var building    : Int?         // 内部人员使用版本号，用此来判断是否要提示更新
    required init?(map: Map) {
        
    }
    init() {
        
    }
    func mapping(map: Map) {
        
        isupdate    <- map["isUpdate"]
        version     <- map["version"]
        remark      <- map["remark"]
        iosurl      <- map["iosUrl"]
        androidurl  <- map["androidUrl"]
        building    <- map["building"]
        
    }
}

class XBUpdateVersionManager: NSObject {
    
   class func checkUpdateVersion(closure: @escaping (XBUpdateVersionType,XBUpdateVersionModel) -> ())  {
    
    Net.requestWithTarget(.getAppVersion(),isShowLoding: false,isDissmissLoding: false, successClosure: { (result, code, message) in
        if let obj = Net.filterStatus(jsonString: result) {
            if let detail_model = Mapper<XBUpdateVersionModel>().map(JSONObject: obj.object) {
                let appSum          = detail_model.building ?? 1000000 // 取服务器的 buiding
                let currentSum      = ez.appBuild?.toInt()  ?? 1000000 // 取本地的 buiding
                
                if currentSum == appSum {// 说明是最新版
                    closure(.latestVersion, detail_model)
                }else if currentSum < appSum { // 说明需要更新
                    closure(.oldVersion, detail_model)
                }else {// 说明当前的版本大于 AppStore 版本， 即，目前正在审核中
                    closure(.underReview, detail_model)
                }
            }
        }

    })
    }
}
