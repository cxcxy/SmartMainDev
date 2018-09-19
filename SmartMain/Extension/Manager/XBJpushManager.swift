////
////  XBJpushManager.swift
////  XBShinkansen
////
////  Created by mac on 2017/12/13.
////  Copyright © 2017年 mac. All rights reserved.
////
//
//import UIKit
//import UserNotifications
//let JpushAppKey                    = XBUtil.getHermesConfiguration("JPushAppKey")
//let JpushApsForProduction:Bool     = XBUtil.getHermesConfiguration("JPushForProduction") == "0" ? false:true
///**
// *   极光管理类
// */
//class XBJpushManager: NSObject,UIApplicationDelegate, JPUSHRegisterDelegate {
//    static let callBackSEL = Selector(("tagsAliasCallBack:tags:alias:")) //
//    static let share = XBJpushManager()
//    func init_JPushMessage(_ launchOptions: [UIApplicationLaunchOptionsKey: Any]?){
//        if #available(iOS 10, *) {
//            let entity = JPUSHRegisterEntity()
//            entity.types = NSInteger(UNAuthorizationOptions.alert.rawValue) |
//                NSInteger(UNAuthorizationOptions.sound.rawValue) |
//                NSInteger(UNAuthorizationOptions.badge.rawValue)
//            JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
//            
//        } else if #available(iOS 8, *) {
//            // 可以自定义 categories
//            JPUSHService.register(
//                forRemoteNotificationTypes: UIUserNotificationType.badge.rawValue |
//                    UIUserNotificationType.sound.rawValue |
//                    UIUserNotificationType.alert.rawValue,
//                categories: nil)
//        } else {
//            // ios 8 以前 categories 必须为nil
//            JPUSHService.register(
//                forRemoteNotificationTypes: UIRemoteNotificationType.badge.rawValue |
//                    UIRemoteNotificationType.sound.rawValue |
//                    UIRemoteNotificationType.alert.rawValue,
//                categories: nil)
//        }
//        JPUSHService.setup(withOption: launchOptions,
//                           appKey: JpushAppKey,
//                           channel: "Publish channel",
//                           apsForProduction: JpushApsForProduction)
//        
//    }
//    /**
//     *   使用 用户Id 作为 别名，进行推送相关逻辑
//     */
//    class func setUserAlias(userId: String?)  {
//        guard let userId = userId else {
//            XBLog("userId 为null")
//            return
//        }
//        
//        JPUSHService.setAlias(userId, completion: { (iResCode, iAlias, seq) in
//            if iResCode == 0 {
//                XBLog("设置别名成功")
//            }
//        }, seq: 0)
//        
//    }
//    /**
//     *   使用 用户Id 作为 别名，退出登录时，删除Alias 别名
//     */
//    class func deleteUserAlias()  {
//        
//        JPUSHService.deleteAlias({ (iResCode, iAlias, seq) in
//            if iResCode == 0 {
//                XBLog("删除别名成功")
//            }
//        }, seq: 0)
//        
//    }
//
//    // App 在前台， 接受通知操作
//    @available(iOS 10.0, *)
//    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
//        
////            let userInfo = notification.request.content.userInfo
//        
//        // 应用在前台操作时， 是否弹出 通知框  可以选择
//        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
//        
//        
//        //
//        //    let request = notification.request // 收到推送的请求
//        //    let content = request.content // 收到推送的消息内容
//        //
//        //    let badge = content.badge // 推送消息的角标
//        //    let body = content.body   // 推送消息体
//        //    let sound = content.sound // 推送消息的声音
//        //    let subtitle = content.subtitle // 推送消息的副标题
//        //    let title = content.title // 推送消息的标题
//    }
//    // App 从后台通过点击通知栏通知唤醒， 拿到通知的相关信息
//    @available(iOS 10.0, *)
//    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
//        let userInfo = response.notification.request.content.userInfo
//        if response.notification.request.trigger is UNPushNotificationTrigger {
//  
//            //应用处于后台时的远程推送接受
//            self.pushController(userInfo: userInfo)
//      
//        }else{
//            //应用处于后台时的本地推送接受
//        }
//        //    let request = response.notification.request // 收到推送的请求
//        //    let content = request.content // 收到推送的消息内容
//        //    let badge = content.badge // 推送消息的角标
//        //    let body = content.body   // 推送消息体
//        //    let sound = content.sound // 推送消息的声音
//        //    let subtitle = content.subtitle // 推送消息的副标题
//        //    let title = content.title // 推送消息的标题
//    }
//    /// 推送相关跳转设置
//    func pushController(userInfo: [AnyHashable : Any])  {
//        if let dic = userInfo as? [String : AnyObject]{
//            if let  biztype = (dic["biztype"] as? String) {
////                switch biztype {
////                case "1": // 档案审批 跳转 消息列表
//                    VCRouter.toMessageListVC()
////                    break
////                default:
////                    break
////                }
//            }
//        }
//    }
//}
