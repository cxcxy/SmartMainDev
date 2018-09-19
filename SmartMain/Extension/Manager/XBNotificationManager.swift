//
//  XBNotificationManager.swift
//  XBPMDev
//
//  Created by mac on 2018/4/12.
//  Copyright © 2018年 mac-cx. All rights reserved.
//

import UIKit
/**
 *   注册通知
 */
public func Noti(_ name: XBNotificationName, object: AnyObject? = nil) -> Observable<Notification> {
    
    return NotificationCenter.default.rx.notification(Notification.Name(rawValue: name.rawValue), object: object)
    
}

/**
 *   发送通知
 */
public func Noti_post(_ name: XBNotificationName, object: AnyObject? = nil){
    
    NotificationCenter.postNotificationNameOnMainThread(name.rawValue, object: object)
    
}


public enum XBNotificationName: String {
    /// 登录成功
    case loginSuccess           = "loginSuccess"
    /// 刷新个人资料用户信息
    case refreshUserData        = "refreshUserData"
    /// 刷新设备信息
    case refreshEquipmentInfo        = "refreshEquipmentInfo"
    case refreshMsgDetail       = "refreshMsgDetail"
    /// 退出登录
    case logout                 = "Noti_Logout"
    /// textFiled value changed
    case tf_valuechanged        = "UITextFieldTextDidChangeNotification"
    
    case refreshMsgList         = "refreshMsgList"
    case getVoucherList         = "getVoucherList"
    case getMyCompanyList       = "getMyCompanyList"
    case getAuthorizerList      = "getAuthorizerList"
    case getCompanyDetail       = "getCompanyDetail"
    case getAccountDetail       = "getAccountDetail"
    case getMerchantsDetai      = "getMerchantsDetai"
    case refreshSafeMessage     = "refreshSafeMessage"

}


public extension NotificationCenter{
    
    static func postNotificationOnMainThread(_ notification:Notification){
        DispatchQueue.main.async { () -> Void in
            NotificationCenter.default.post(notification)
        }
    }
    static  func postNotificationNameOnMainThread(_ aName:String,object:Any?){
        let not = Notification(name: Notification.Name(rawValue: aName), object: object)
        postNotificationOnMainThread(not)
    }
    static func postNotificationNameOnMainThread(_ aName:String,object:AnyObject?,userInfo:[AnyHashable: Any]?){
        let not = Notification(name: Notification.Name(rawValue: aName), object: object, userInfo: userInfo)
        postNotificationOnMainThread(not)
    }
}
