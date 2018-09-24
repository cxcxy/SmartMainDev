//
//  XBBaseModel.swift
//  XBShinkansen
//
//  Created by mac on 2017/11/15.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit
import ObjectMapper
class XBBaseModel: NSObject {

}

/**
 *   封装一层 Mappable， 直接使用NSObject 放在请求体-resdata里面，映射不到json ，
 *   所有请求的model体，都继承此类
 */
class XBDataModel: Mappable {
    required init?(map: Map) {
        
    }
    init() {
        
    }
    func mapping(map: Map) {
    }
}

class XBSocketValueModel: Mappable {
    
    var cmd         : String?
    var value       : Int?
    var key         : String?

    required init?(map: Map) {
        
    }
    init() {
        
    }
    func mapping(map: Map) {
        cmd                         <- map["cmd"]
        value                       <- map["value"]
        key                         <- map["key"]
    }
}

class XBSocketModel: Mappable {
    var cmd        :   String?
    var value: String?
    var key : String?
    var trackListId : Int?
    var trackId : Int?
    var url : String?
    var downloadUrl : String?
    required init?(map: Map) {
        
    }
    init() {
        
    }
    func mapping(map: Map) {
        cmd                         <- map["cmd"]
        value                         <- map["value"]
        key                         <- map["key"]
        trackListId <- map["trackListId"]
        trackId <- map["trackId"]
        url <- map["url"]
        downloadUrl <- map["downloadUrl"]
    }
}
/**
 *   前后端约定的请求服务端报文格式 ， 主要参数为 resdata -> XBDataModel
 */
class XBBaseReqModel:NSObject, Mappable {

//    var privatefield    :   String? = XBUserAgentManager.userAgentInfo + "timeInterval--" + String(XBUtil.getCurrentTimerInterval(false)) //客户端生成的唯一序号
    var reqtime         :   String? = Date.init().toString(format: "yyyy-MM-dd HH:mm:ss")//响应数据时间
    var version         :   String? = "2.0"//返回代码
//    var accesstoken     :   String  = XBTokenManager.accessToken //Token
    var reqdata         :   XBDataModel? //请求的数据内容
    
    required init?(map: Map) {
        
    }
    override init() {
        
    }
    func mapping(map: Map) {
        
//        privatefield                        <- map["privatefield"]
        reqtime                             <- map["reqtime"]
        version                             <- map["version"]
//        accesstoken                         <- map["accesstoken"]
        reqdata                             <- map["reqdata"]
        
    }

}
/**
 *   前后端约定的返回数据结构
 */
class XBBaseResModel: Mappable {
    
    var resdata:AnyObject?      // 若返回无数据，returnObject字段也得带上,可为空值
    var code: Int?              // 返回代码
    var message: String?        // 返回消息

    
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        resdata             <-    map["data"]
        code                <-    map["result"]
        message             <-    map["msg"]

    }
}
/**
 *   服务端返回报文格式
 */
class XBResponseModel: XBBaseModel {

}



/**
 *   请求服务端  分页 格式
 */
class XBRequestPageModel: XBDataModel {
    var curpageno           : Int?    // 当前页码
    var pagesize            : Int = XBPageSize //每页条数
    
    override func mapping(map: Map) {
        curpageno <- map["curpageno"]
        pagesize <- map["pagesize"]
    }
    
}

class XBFilePlaceholderModel:NSObject {
    var imgUrl              :String?
    var imgPlacehold        :String = ""
    
    init(imgUrl:String? = nil,
         imgPlacehold:String) {
        super.init()
        self.imgUrl         = imgUrl
        self.imgPlacehold   = imgPlacehold
    }
}

//MARK: 接收 -- 附件信息
//class XBImgInfoResModel: FileInfo {
//    var id : Int?//附件ID,attachid,无的时候传0
//    var audio_url : String?  // 本地录音地址
//    var image : UIImage?
//    var file_type   : XBFileFormat?   //   1 获取附件token， 2 获取用户头像token
//    
//    
//    var placeHolder:XBFilePlaceholderModel = XBFilePlaceholderModel.init(imgPlacehold: "icon_shangchuanwj1")
//    override func mapping(map: Map) {
//        super.mapping(map: map)
//        
//    }
//}


// 左边title 右边 内容   右边 有 右箭头
class XBStyleCellModel:NSObject {
    var title:String    = ""
    var content:String  = ""
    var isRight:Bool    = false
    var imgIcon:String  = ""
    var isSwitchOpen:Bool?
    var cellType:Int    = 0
    var extraDic = [String: String]()
    var isHidden : Bool = false
    init(title:String = "",
         imgIcon:String = "",
         content:String = "",
         isRight:Bool = false,
         isSwitchOpen:Bool? = nil,
         cellType:Int = 0,
         extraDic:[String: String] = [String: String](),
         isHidden: Bool = false) {
        self.title = title
        self.content = content
        self.isRight = isRight
        self.imgIcon = imgIcon
        self.isSwitchOpen = isSwitchOpen
        self.cellType = cellType
        self.extraDic = extraDic
        self.isHidden = isHidden
    }
}

/**
 *   前后端约定的返回数据结构
 */
//class XBSavePhoneModel: Mappable {

//    var phoneArr: [XBContactsModel]?        // 响应时间
//    
//    required init?(map: Map) {
//    }
//    init() {
//        
//    }
//    func mapping(map: Map) {
//        
//        phoneArr             <-    map["phoneArr"]
//
//    }
//}


