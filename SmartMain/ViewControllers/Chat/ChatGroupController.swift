//
//  ChatGroupController.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/25.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class ChatGroupController: EaseMessageViewController {
    var groupName: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "聊天"
        self.setCustomerBack()
        self.setRightItem()
        let chatView = self.chatToolbar as? EaseChatToolbar
        chatView?.inputViewRightItems = []


    }
    //MARK: 返回按钮
    func setCustomerBack(_ backIconName:String = "icon_fanhui") {
  
        let img = UIImage.init(named: backIconName)?.withRenderingMode(.alwaysOriginal) // 使用原图渲染方式
        let item = UIBarButtonItem(image: img, style:.plain, target: self, action:#selector(navBack))
        navigationItem.leftBarButtonItem = item
        
    }
    //MARK: 右侧按钮
    func setRightItem() {
        
        let img = UIImage.init(named: "icon_tianjia")?.withRenderingMode(.alwaysOriginal) // 使用原图渲染方式
        let item = UIBarButtonItem(image: img, style:.plain, target: self, action:#selector(navRightItemBack))
        self.rightItems = [item]
        navigationItem.rightBarButtonItem = item
        
    }
    @objc func navRightItemBack() {
        let vc = GroupAddViewController.init(style: .grouped)
        vc.groupId = self.conversation.conversationId
        vc.groupName = self.groupName
        self.pushVC(vc)
        
    }
    @objc func navBack() {
        _ = navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func messageStatusDidChange(_ aMessage: EMMessage!, error aError: EMError!) {
        
    }
}
extension ChatGroupController: EaseMessageViewControllerDelegate,EaseMessageViewControllerDataSource {
    override func sendVoiceMessage(withLocalPath localPath: String!, duration: Int) {
        print(localPath)
        super.sendVoiceMessage(withLocalPath: localPath, duration: duration)
        
        guard XBUserManager.device_Id != "" else {
            return
        }
        
        let fileManager = FileManager.default

        if (fileManager.fileExists(atPath: localPath)){
            Net.requestWithTarget(.sendVoiceDevice(username: XBUserManager.userName, groupId: self.conversation.conversationId, nickname: XBUserManager.userName, body: localPath),isShowLoding: false, successClosure: { (result, code, message) in
                if let str = result as? String {
                    print(str)
                }
            })
        
        }
    }
    override func sendTextMessage(_ text: String!) {
        print(text)
        super.sendTextMessage(text)
        guard XBUserManager.device_Id != "" else {
            return
        }
//        sendVoiceDevice
        var params_task = [String: Any]()
        params_task["username"] = XBUserManager.userName
        params_task["nickname"] = XBUserManager.userName // 暂定qq 不能中文， 用户的nickname 可能为中文
        params_task["groupId"] = self.conversation.conversationId
        params_task["content"] = text
        Net.requestWithTarget(.sendTextDevice(req: params_task),isShowLoding: false, successClosure: { (result, code, message) in
            
            if let str = result as? String {
                if str == "ok" {
                    print("发送成功")
//                    XBHud.showMsg("注册成功")
//                    closure()
                }else {
                     print("发送失败")
//                    XBHud.showMsg("注册失败")
                }
            }
            
        })

    }
}
