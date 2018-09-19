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
    static let userName = Key<String>("userName")
    static let deviceId = Key<String>("deviceId")
    static let online   = Key<Bool>("online")
}
//TODO
struct XBUserManager {
    static var userName:String {
        get{
            return user_defaults.get(for: .userName) ?? ""
        }
        set{
            user_defaults.set(newValue, for: .userName)
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
    static var online:Bool { // 当前设备是否在线
        get{
            return user_defaults.get(for: .online) ?? false
        }
        set{
            user_defaults.set(newValue, for: .online)
        }
    }
//     保存用户信息
    static func saveUserInfo(_ phone: String){
//        XBJpushManager.setUserAlias(userId: model?.userid?.toString)
//        default.set
        user_defaults.set(phone, for: .userName)
        
        // 保存当前登录的用户信息， 用户退出登录时， 显示登录界面
//        Noti_post(.refreshUserData,object: model)
//        MGDefault.synchronize()

    }
    static func saveDeviceId(_ saveDeviceId: String){
        //        XBJpushManager.setUserAlias(userId: model?.userid?.toString)
        //        default.set
        user_defaults.set(saveDeviceId, for: .deviceId)
        
        // 保存当前登录的用户信息， 用户退出登录时， 显示登录界面
        //        Noti_post(.refreshUserData,object: model)
        //        MGDefault.synchronize()
        
    }
    // 清空用户信息
    static func cleanUserInfo(){
        user_defaults.clear(.userName)
        user_defaults.clear(.deviceId)
//        XBJpushManager.deleteUserAlias()
       
//        Noti_post(.refreshUserData)
//        MGDefault.synchronize()
        
    }
    /**
     退出登录
     清空用户的各个信息
     */
    static func exitLogin(){
        cleanUserInfo()
    }
    
    
}

