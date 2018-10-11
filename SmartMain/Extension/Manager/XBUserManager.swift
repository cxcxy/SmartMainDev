//
//  XBUserManager.swift
//  XBShinkansen
//
//  Created by mac on 2017/11/22.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit
import ObjectMapper
//MARK: 接受 -- user Model
class XBUserModel:  Mappable{

    var phone : String? // 手机号
    var profile : String? // 个人简介
    var securityLevel : Int?// 0=未设置支付密码，1=支付密码，2=支付密码+短信验证码（仅当前用户返回）
    var sex : Int?
    var identitycard: String? // 身份正号
    var truename : String? // 真实姓名
    var userid : Int?
    var username : String?
    var area : String?
    var status : Int?
    var totalBalance : Double?//总余额
    var balance : Double?//通用西币余额
    var voucherBalance : Double?//抵用券余额
    var friendCount : Int?

    required init?(map: Map){}
    
    func mapping(map: Map)
    {

        phone <- map["phone"]
        profile <- map["profile"]
        securityLevel <- map["securityLevel"]
        sex <- map["sex"]
        identitycard <- map["identitycard"]
        truename <- map["truename"]
        userid <- map["userid"]
        username <- map["username"]
        area    <- map["area"]
        status  <- map["status"]
        totalBalance    <- map["totalBalance"]
        balance    <- map["balance"]
        voucherBalance    <- map["voucherBalance"]
        friendCount    <- map["friendCount"]
    }
    
}
//MARK:登录状态  返回true 时 ，则说明， 未登陆状态
/**
 *   登录状态  返回true 时 ，则说明， 未登陆状态
 */
public func XBLoginStatus() -> Bool{
    
//    if XBTokenManager.accessToken == "" || XBUserManager.dispname == "" || XBUserManager.securitylevel == 0 {
//        XBHud.dismiss()
//        return true
//    }
    
    return false
}
let user_defaults = Defaults()
public extension DefaultsKey {
    //用户信息
    static let userName = Key<String>("userName")
    static let nickname = Key<String>("nickname")
    static let password = Key<String>("password")
    static let headImgUrl = Key<String>("headImgUrl")
    static let deviceId = Key<String>("deviceId")
    static let userDevices = Key<[String]>("userDevices")
    
    
    static let online   = Key<Bool>("online")
    
    // 设备信息
     static let dv_babyname   = Key<String>("babyname")
     static let dv_headimgurl   = Key<String>("headimgurl")
     static let dv_sex   = Key<String>("sex")
     static let dv_birthday   = Key<String>("birthday")
     static let dv_recordtime   = Key<String>("recordtime")
    
    
}
class XBDeviceBabyModel:  Mappable{
    
    var id : Int? //
    var deviceid : String? //
    var babyname : String?//
    var headimgurl : String?
    var sex: String? //
    var birthday : String? //
    var recordtime : String?
    var isCurrent: Bool = false // 是否是当前用户所选择的设备
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        
        id <- map["id"]
        deviceid <- map["deviceid"]
        babyname <- map["babyname"]
        headimgurl <- map["headimgurl"]
        sex <- map["sex"]
        birthday <- map["birthday"]
        recordtime <- map["recordtime"]
        
    }
    
}
extension XBUserManager { // 保存设备宝宝 信息
    static var dv_babyname:String {
        get{
            return user_defaults.get(for: .dv_babyname) ?? ""
        }
        set{
            user_defaults.set(newValue, for: .dv_babyname)
        }
    }
    static var dv_headimgurl:String {
        get{
            return user_defaults.get(for: .dv_headimgurl) ?? ""
        }
        set{
            user_defaults.set(newValue, for: .dv_babyname)
        }
    }
    static var dv_sex:String {
        get{
            return user_defaults.get(for: .dv_sex) ?? ""
        }
        set{
            user_defaults.set(newValue, for: .dv_sex)
        }
    }
    static var dv_birthday:String {
        get{
            return user_defaults.get(for: .dv_birthday) ?? ""
        }
        set{
            user_defaults.set(newValue, for: .dv_birthday)
        }
    }
    static var dv_recordtime:String {
        get{
            return user_defaults.get(for: .dv_recordtime) ?? ""
        }
        set{
            user_defaults.set(newValue, for: .dv_recordtime)
        }
    }
    // 保存当前设备的信息
    static func saveDeviceInfo(_ deviceModel: XBDeviceBabyModel) {
         user_defaults.set(deviceModel.babyname ?? "", for: .dv_babyname)
         user_defaults.set(deviceModel.sex ?? "", for: .dv_sex)
         user_defaults.set(deviceModel.birthday ?? "", for: .dv_birthday)
         user_defaults.set(deviceModel.headimgurl ?? "", for: .dv_headimgurl)
         user_defaults.set(deviceModel.recordtime ?? "", for: .dv_recordtime)
         user_defaults.set(deviceModel.deviceid ?? "", for: .deviceId)
         
    }
    // 清空当前设备信息
    static func clearDeviceInfo() {

        user_defaults.clear(.dv_babyname)
        user_defaults.clear(.dv_sex)
        user_defaults.clear(.dv_birthday)
        user_defaults.clear(.dv_headimgurl)
        user_defaults.clear(.dv_recordtime)
        user_defaults.clear(.deviceId)
    }
}
//TODO 保存用户信息
struct XBUserManager {
    
    static var userName:String {
        get{
            return user_defaults.get(for: .userName) ?? ""
        }
        set{
            user_defaults.set(newValue, for: .userName)
        }
    }
    
    static var nickname:String {
        get{
            return user_defaults.get(for: .nickname) ?? ""
        }
        set{
            user_defaults.set(newValue, for: .nickname)
        }
    }
    
    static var password:String {
        get{
            return user_defaults.get(for: .password) ?? ""
        }
        set{
            user_defaults.set(newValue, for: .password)
        }
    }
    
    static var device_Id:String {
        get{
            return user_defaults.get(for: .deviceId) ?? ""
        }
        set{
            user_defaults.set(newValue, for: .deviceId)
        }
    }
    
    static var userDevices:[String] {
        get{
            return user_defaults.get(for: .userDevices) ?? []
        }
        set{
            user_defaults.set(newValue, for: .userDevices)
        }
    }
    
    static var online:Bool { // 当前设备是否在线
        get{
            return user_defaults.get(for: .online) ?? false
        }
        set{
            user_defaults.set(newValue, for: .online)
        }
    }

    static func saveUserInfo(_ model: UserModel){

        user_defaults.set(model.username ?? "", for: .userName)
        user_defaults.set(model.password ?? "", for: .password)
        user_defaults.set(model.nickname ?? "", for: .nickname)
        user_defaults.set(model.headImgUrl ?? "", for: .headImgUrl)
        user_defaults.set(model.deviceId ?? [], for: .userDevices)
    }
    
    static func updateUserInfo(headImgUrl: String,nickname: String){
        
        user_defaults.set(nickname, for: .nickname)
        user_defaults.set(headImgUrl, for: .headImgUrl)
        
    }
    
    // 清空用户信息
    static func cleanUserInfo(){
        user_defaults.clear(.userName)
        user_defaults.clear(.nickname)
        user_defaults.clear(.password)
        user_defaults.clear(.headImgUrl)
        user_defaults.clear(.deviceId)
        user_defaults.clear(.userDevices)
        user_defaults.clear(.online)
        user_defaults.clear(.dv_babyname)
        user_defaults.clear(.dv_headimgurl)
        user_defaults.clear(.dv_sex)
        user_defaults.clear(.dv_birthday)
        user_defaults.clear(.dv_recordtime)
    }
    /**
     退出登录
     清空用户的各个信息
     */
    static func exitLogin(){
        cleanUserInfo()
    }
    
    
}

