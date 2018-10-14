//
//  ChatManager.swift
//  SmartMain
//
//  Created by mac on 2018/9/26.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
import UserNotifications
class ChatManager: NSObject {
    
    static let share = ChatManager()
    
    lazy var popWindow:UIWindow = {
        let w = UIApplication.shared.delegate as! AppDelegate
        return w.window!
    }()
    
    func init_ChatMessage(_ application: UIApplication, _ launchOptions: [UIApplicationLaunchOptionsKey: Any]?){
        let options = EMOptions.init(appkey: "1188180613253110#o9tm3wzgkwwrmakc5gddip54t5g")
        EMClient.shared().initializeSDK(with: options)
        EaseSDKHelper.share().hyphenateApplication(application,
                                                   didFinishLaunchingWithOptions: launchOptions,
                                                   appkey: "1188180613253110#o9tm3wzgkwwrmakc5gddip54t5g",
                                                   apnsCertName: "developer",
                                                   otherConfig: [kSDKConfigEnableConsoleLogger: false])
        if #available(iOS 10, *) {
            application.registerForRemoteNotifications()
           
            let types: UIUserNotificationType =
                UIUserNotificationType.init(rawValue: UNAuthorizationOptions.alert.rawValue |
                    UNAuthorizationOptions.sound.rawValue |
                    UNAuthorizationOptions.badge.rawValue
                )
            
            let settiongs = UIUserNotificationSettings.init(types: types, categories: nil)
            application.registerUserNotificationSettings(settiongs)
            
//            let entity = JPUSHRegisterEntity()
//            entity.types = NSInteger(UNAuthorizationOptions.alert.rawValue) |
//                NSInteger(UNAuthorizationOptions.sound.rawValue) |
//                NSInteger(UNAuthorizationOptions.badge.rawValue)
//            JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
            
            
        } else if #available(iOS 8, *) {
            // 可以自定义 categories
//            JPUSHService.register(
//                forRemoteNotificationTypes: UIUserNotificationType.badge.rawValue |
//                    UIUserNotificationType.sound.rawValue |
//                    UIUserNotificationType.alert.rawValue,
//                categories: nil)
        }
        
        EMClient.shared()?.add(self, delegateQueue: nil)

        EMClient.shared()?.chatManager?.add(self, delegateQueue: nil)

        setPushShowDetail()
    }
    //MARK: 设置推送通知 为详情展示
    func setPushShowDetail()  {
        
        let options = EMClient.shared()?.pushOptions
        options?.displayStyle = EMPushDisplayStyleMessageSummary
        EMClient.shared()?.updatePushOptionsToServer()
    }
    
    func loginEMClient(username: String,password: String)  {
        if let isAutoLogin = EMClient.shared()?.options.isAutoLogin {
            if isAutoLogin {
                self.asyncGetMyGroupsFromServer()
                return
            }
            EMClient.shared().login(withUsername: username, password: password) { (aUserName, aError) in
                if (aError == nil) {
                    print("登录成功",aUserName ?? "未获取到姓名")
                    EMClient.shared()?.options.isAutoLogin = true // 设置为自动登录
                    self.asyncGetMyGroupsFromServer()
                }else {
                    print("登录失败")
                }
            }
        }
    }
    func asyncGetMyGroupsFromServer() {
        DispatchQueue.global().async {
            var error: EMError? = nil
            EMClient.shared().groupManager.getJoinedGroupsFromServer(withPage: 0, pageSize: -1, completion: { (_, _) in
                
            })
            DispatchQueue.main.async {
                
                // 更新UI操作
                
            }
            
        }
    }
    func asyncLoadDBData() {
        DispatchQueue.global().async {
            EMClient.shared().migrateDatabaseToLatestSDK()
            DispatchQueue.main.async {
                
                // 更新UI操作
                
            }
            
        }
    }
    /**
     *   异步获取对话列表
     */
    func asyncConversationFromDB()  {
        DispatchQueue.global().async {
            if let arr = EMClient.shared().chatManager.getAllConversations() as? [EMConversation]  {
                
                for (index, value) in arr.enumerated() {
                    if (value.latestMessage == nil) {
                        EMClient.shared().chatManager.deleteConversation(value.conversationId, isDeleteMessages: false, completion: {_,_ in
        
                        })
                    }
                }
            }
            DispatchQueue.main.async {
                
                // 更新UI操作
            
            }
            
        }
    }
}
extension ChatManager: EMClientDelegate {
    // 当前登录账号在其它设备登录时会接收到此回调
    func userAccountDidLoginFromOtherDevice() {
        VCRouter.prentAlertAction(message: "当前帐号在异地登录") {
            print("确认")
            if (EMClient.shared()?.logout(true)) == nil {
                print("退出登录成功")
            }
            XBUserManager.cleanUserInfo()
            XBUserManager.clearDeviceInfo()
            let sv = UIStoryboard.getVC("Main", identifier:"LoginNav") as! XBBaseNavigation
            self.popWindow.rootViewController = sv
        }
    }
    func autoLoginDidCompleteWithError(_ aError: EMError!) {
        print("自动登录，",aError)
    }
}
extension ChatManager: EMChatManagerDelegate {
    func messagesDidReceive(_ aMessages: [Any]!) {
        if let messages = aMessages as? [EMMessage] {
            let state = UIApplication.shared.applicationState
            for item in messages {
                let fromNick = item.from ?? ""
                var bodyText = ""
                switch item.body.type {
                case EMMessageBodyTypeText:
                    let textBody: EMTextMessageBody = item.body as! EMTextMessageBody
                    let didReceiveText = EaseConvertToCommonEmoticonsHelper.convert(toSystemEmoticons: textBody.text)
                    bodyText = didReceiveText ?? ""
                    
                    break
                case EMMessageBodyTypeVoice:
                    bodyText = "[语音]"
                    break
                case EMMessageBodyTypeImage:
                    bodyText = "[图片]"
                default:
                    bodyText = ""
                    break
                }
                if state == .background { // app 在后台
                    //设置推送内容
                    if #available(iOS 10.0, *) {
                        let content = UNMutableNotificationContent()
                        content.title = "您收到一条新消息"
                        content.body = fromNick + ":" + bodyText
                        //设置通知触发器
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
                        //设置请求标识符
                        let requestIdentifier = "com.jihao.app"
                        //设置一个通知请求
                        let request = UNNotificationRequest(identifier: requestIdentifier,
                                                            content: content, trigger: trigger)
                        
                        //将通知请求添加到发送中心
                        UNUserNotificationCenter.current().add(request) { error in
                            if error == nil {
                                print("Time Interval Notification scheduled: \(requestIdentifier)")
                            }
                        }
                    }
                }
                
                if state == .active { // app 在前台
                    
//                    let alertBody = "电池电量通知"
//                    let localNotify = UILocalNotification()
//                    localNotify.alertBody = alertBody
//                    localNotify.soundName = UILocalNotificationDefaultSoundName
//                    localNotify.userInfo = ["battery": 100]
//                    UIApplication.shared.presentLocalNotificationNow(localNotify)

                }
                
            }


        }
        print(aMessages)
       
        
    }
}
