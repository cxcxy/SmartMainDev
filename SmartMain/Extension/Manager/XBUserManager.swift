//
//  XBUserManager.swift
//  XBShinkansen
//
//  Created by mac on 2017/11/22.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit
import ObjectMapper

class XBUserPhotoManager: NSObject {
    ///保存 登录过的用户的头像信息
    static var photoDic:Dictionary<String, String>{
        get{
            return ((MGDefault.object(forKey: "XBUserPhotoManager") as? Dictionary<String, String>)) ?? [:]
        }
        set{
            MGDefault.set(newValue, forKey:"XBUserPhotoManager")
            MGDefault.synchronize()
        }
    }
    ///保存 登录过的用户的头像 image
    static var photoImgDic:Dictionary<String, UIImage>{
        get{
            return ((MGDefault.object(forKey: "XBUserPhotoImgManager") as? Dictionary<String, UIImage>)) ?? [:]
        }
        set{
            MGDefault.set(newValue, forKey:"XBUserPhotoImgManager")
            MGDefault.synchronize()
        }
    }
}

//MARK: 接受 -- user Model
class UserModel: XBDataModel {
    
    var id:Int?
    var username: String?
    var password: String?
    var nickname: String?
    var headImgUrl: String?
    var deviceId: [String]?
    
    override func mapping(map: Map) {
        
        id             <-    map["id"]
        username             <-    map["username"]
        password          <-    map["password"]
        nickname            <-    map["nickname"]
        headImgUrl            <-    map["headImgUrl"]
        deviceId            <-    map["deviceId"]
    }
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
    var onLine: Bool = false
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
        onLine <- map["onLine"]
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
            user_defaults.set(newValue, for: .dv_headimgurl)
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

         XBUserManager.device_Id = deviceModel.deviceid ?? ""
         // 修改 当前 所链接的MQTT deviceid
        
    }
    // 清空当前设备信息
    static func clearDeviceInfo() {
        ScoketMQTTManager.share.unSubscribeToChannel(socket_clientId: XBUserManager.device_Id)
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
            ScoketMQTTManager.share.subscribeToChannel(socket_clientId: newValue)
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
        user_defaults.set(model.deviceId ?? [], for: .userDevices) // 更新用户所绑定的 devices
        
        
        
        if XBUserManager.userDevices.contains(XBUserManager.device_Id) { // 看当前用户所使用的 deviceId 是否 存在于 用户 所有绑定的 devices 里面
            
        } else {
            if XBUserManager.userDevices.count != 0 {
             XBUserManager.device_Id = XBUserManager.userDevices[0] // 给当前deviceId 第一个
                // 修改 当前 所链接的MQTT deviceid
             ScoketMQTTManager.share.subscribeToChannel(socket_clientId: XBUserManager.device_Id)
            }else {
                XBUserManager.device_Id = ""
            }
        }
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

