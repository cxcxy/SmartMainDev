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
        self.title = "聊天啦"
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
        
    }
    override func sendTextMessage(_ text: String!) {
        print(text)
        super.sendTextMessage(text)

    }
}
