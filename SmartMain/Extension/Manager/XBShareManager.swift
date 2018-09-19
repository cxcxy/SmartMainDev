////
////  XBShareManager.swift
////  XBPMDev
////
////  Created by mac on 2018/4/23.
////  Copyright © 2018年 mac-cx. All rights reserved.
////
//
//import UIKit
//import Foundation
//
//public typealias ShareSuccessClosure                = () -> ()
//public typealias ShareFailClosure                   = (_ e:Swift.Error) -> ()
//
//public class XBShareManager {
//    
////    public static func is_wx_installed() -> Bool{
////        return WXApi.isWXAppInstalled()
////    }
////    public static func is_qq_installed() -> Bool{
////        return QQApiInterface.isWeiboAppInstalled()
////    }
////    public static func is_weibo_installed() -> Bool{
////        return WeiboSDK.isQQInstalled()
////    }
//    public static func manual_init() {
//        
//        if let umm = UMSocialManager.default() {
//            //打开日志
//            umm.openLog(true)
//            // 获取友盟social版本号
//            print("UMeng social version: \(UMSocialGlobal.umSocialSDKVersion())")
//            
//            
//            //设置友盟appkey
//            umm.umSocialAppkey      = "5ad987b4f29d98589a0000a5"
//            
//            //设置微信的appKey和appSecret
//            umm.setPlaform(UMSocialPlatformType.wechatSession,
//                           appKey:      ConfigManager.getConfigInfo("WXAppKey"),
//                           appSecret:   ConfigManager.getConfigInfo("WXAppSecret"),
//                           redirectURL: "www.96369.net")
//            
//            //设置QQ的appKey和appSecret
//            umm.setPlaform(UMSocialPlatformType.QQ,
//                           appKey:      ConfigManager.getConfigInfo("QQAppKey"),
//                           appSecret:   ConfigManager.getConfigInfo("QQAppSecret"),
//                           redirectURL: "www.96369.net")
//            //设置QQ的appKey和appSecret
//            umm.setPlaform(UMSocialPlatformType.qzone,
//                           appKey:      ConfigManager.getConfigInfo("QQAppKey"),
//                           appSecret:   ConfigManager.getConfigInfo("QQAppSecret"),
//                           redirectURL: "www.96369.net")
//            //设置微博的appKey和appSecret
//            umm.setPlaform(UMSocialPlatformType.sina,
//                           appKey:      ConfigManager.getConfigInfo("WeiboAppKey"),
//                           appSecret:   ConfigManager.getConfigInfo("WeiboSecret"),
//                           redirectURL: "www.96369.net")
//            
//        }else{
//            print(">>>> WowShare Init Fail!")
//        }
//    }
//    static let vc = UIApplication.currentViewController()
//    
//    public static func handle_open_url(_ url:URL ) -> Bool {
//        let result = UMSocialManager.default().handleOpen(url)
//        return result
//    }
//    public static func share_WechatImg(shareImage:Any!,
//                                       successClosure:@escaping ShareSuccessClosure,
//                                       failClosure:@escaping ShareFailClosure){
//        let messageObject                       = UMSocialMessageObject()
//        let shareObject:UMShareImageObject      = UMShareImageObject.init()
//        shareObject.shareImage                  = shareImage
//        messageObject.shareObject               = shareObject
//    
//        UMSocialManager.default().share(to: UMSocialPlatformType.wechatSession, messageObject: messageObject, currentViewController: vc) { (shareResponse, error) in
//            if let e = error as NSError? {
//                if e.code == 2008 {
//                    XBHud.showWarnMsg("未安装微信")
//                }
//                failClosure(e)
//            }else{
//                successClosure()
//            }
//        }
//    }
//    
//    public static func share_WechatFriendsImg(shareImage:Any!,
//                                              successClosure: @escaping ShareSuccessClosure,
//                                              failClosure: @escaping ShareFailClosure){
//        let messageObject                       = UMSocialMessageObject()
//        let shareObject:UMShareImageObject    = UMShareImageObject.init()
//        shareObject.shareImage = shareImage
//        messageObject.shareObject               = shareObject
//        
//        UMSocialManager.default().share(to: UMSocialPlatformType.wechatTimeLine, messageObject: messageObject, currentViewController: vc) { (shareResponse, error) in
//            if let e = error as NSError? {
//                if e.code == 2008 {
//                    XBHud.showWarnMsg("未安装微信")
//                }
//                failClosure(e)
//            }else{
//                successClosure()
//            }
//        }
//    }
//    public static func share_friends(
//        _ title:String = "西本采购经理人",
//        shareText:String?,
//        url:String?,
//        shareImage:Any!,
//        toType:UMSocialPlatformType?,
//        successClosure:@escaping ShareSuccessClosure,
//        failClosure:@escaping ShareFailClosure
//        )
//    {
//        let messageObject                       = UMSocialMessageObject()
//        let shareObject:UMShareWebpageObject    = UMShareWebpageObject.init()
//        shareObject.title                       = title       //显不显示有各个平台定
//        shareObject.descr                       = shareText   //显不显示有各个平台定
//        shareObject.thumbImage                  = shareImage  //缩略图，显不显示有各个平台定
//        shareObject.webpageUrl                  = url
//        messageObject.shareObject               = shareObject
//        
////        if !UMSocialManager.default().isInstall(toType!) {
////            if toType == UMSocialPlatformType.wechatSession || toType == UMSocialPlatformType.wechatTimeLine {
////                XBHud.showWarnMsg("未安装微信")
////            }else if toType == UMSocialPlatformType.QQ {
////                XBHud.showWarnMsg("未安装QQ")
////            }else {
////                XBHud.showWarnMsg("未安装微博")
////            }
////            return
////        }
//
//        UMSocialManager.default().share(
//            to: toType!,
//            messageObject: messageObject,
//            currentViewController: vc,
//            completion: { (shareResponse, error) -> Void in
//                
//                if let e = error as NSError? {
//                    if e.code == 2008 {
//                        if toType == UMSocialPlatformType.wechatSession || toType == UMSocialPlatformType.wechatTimeLine {
//                            XBHud.showWarnMsg("未安装微信")
//                        }else if toType == UMSocialPlatformType.QQ {
//                            XBHud.showWarnMsg("未安装QQ")
//                        }else {
//                            XBHud.showWarnMsg("未安装微博")
//                        }
//                    }
//                    failClosure(e)
//                }else{
//                    successClosure()
//                }
//        })
//    }
//    
//    
//    
//    public static func share_text(
//        _ title:String = "西本采购经理人",
//        shareText:String?,
//        url:String?,
//        shareImage:Any!,
//        successClosure:@escaping ShareSuccessClosure,
//        failClosure:@escaping ShareFailClosure
//        )
//    {
//        
//        let messageObject                       = UMSocialMessageObject()
//        let shareObject:UMShareWebpageObject    = UMShareWebpageObject.init()
//        shareObject.title                       = title       //显不显示有各个平台定
//        shareObject.descr                       = shareText   //显不显示有各个平台定
//        shareObject.thumbImage                  = shareImage  //缩略图，显不显示有各个平台定
//        shareObject.webpageUrl                  = url
//        messageObject.shareObject               = shareObject
//        
//        UMSocialManager.default().share(
//            to: UMSocialPlatformType.wechatSession,
//            messageObject: messageObject,
//            currentViewController: vc,
//            completion: { (shareResponse, error) -> Void in
//                print(error.debugDescription)
//                //var message: String = ""
//                if let e = error {
//                    failClosure(e )
//                }else{
//                    successClosure()
//                }                
//        })
//    }
//    
//    
//    public static func getAuthWithUserInfoFromWechat(  success_handler: @escaping (Any?) -> Void ){
//        UMSocialManager.default().getUserInfo(with: UMSocialPlatformType.wechatSession, currentViewController: nil) { (result, error) in
//            if error != nil {
//                print("Share Fail with error ：%@", error)
//            }else{
//                let user: UMSocialUserInfoResponse = result as! UMSocialUserInfoResponse
//                success_handler(user.originalResponse)
//            }
//        }
//    }
//    
//    public static func cancle(  success_handler: @escaping (Any?) -> Void ){
//        UMSocialManager.default().cancelAuth(with: UMSocialPlatformType.wechatSession) { (result, error) in
//            if error != nil {
//                print("Share Fail with error ：%@", error)
//            }else{
//                
//                success_handler("sucess")
//            }
//        }
//    }
//    
//}
