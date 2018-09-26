//
//  ChatManager.swift
//  SmartMain
//
//  Created by mac on 2018/9/26.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class ChatManager: NSObject {
    
    static let share = ChatManager()
    
    func init_ChatMessage(_ application: UIApplication, _ launchOptions: [UIApplicationLaunchOptionsKey: Any]?){
        let options = EMOptions.init(appkey: "1188180613253110#o9tm3wzgkwwrmakc5gddip54t5g")
        EMClient.shared().initializeSDK(with: options)
        EaseSDKHelper.share().hyphenateApplication(application,
                                                   didFinishLaunchingWithOptions: launchOptions,
                                                   appkey: "1188180613253110#o9tm3wzgkwwrmakc5gddip54t5g",
                                                   apnsCertName: "",
                                                   otherConfig: [kSDKConfigEnableConsoleLogger: false])
        loginEMClient()
        
    }
    
    func loginEMClient()  {
        EMClient.shared().login(withUsername: XBUserManager.userName, password: "123456") { (aUserName, aError) in
            if (aError == nil) {
                print("登录成功",aUserName ?? "未获取到姓名")
                self.asyncGetMyGroupsFromServer()
            }else {
                print("登录失败")
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
extension ChatManager {
    
}
