//
//  ChatViewController.swift
//  SmartMain
//
//  Created by mac on 2018/9/7.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class ChatViewController: XBBaseViewController {

    @IBOutlet weak var lbGroupName: UILabel!
    @IBOutlet weak var tfName: UITextField!
    
    @IBOutlet weak var tfJoinName: UITextField!
    
    @IBOutlet weak var tfGroupName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "微聊"
    }
    @IBAction func clickCreateGroupAction(_ sender: Any) {
//        EMError *error = nil;
//        EMGroupOptions *setting = [[EMGroupOptions alloc] init];
//        setting.maxUsersCount = 500;
//        setting.style = EMGroupStylePublicOpenJoin;// 创建不同类型的群组，这里需要才传入不同的类型
//        EMGroup *group = [[EMClient sharedClient].groupManager createGroupWithSubject:@"群组名称" description:@"群组描述" invitees:@[@"6001",@"6002"] message:@"邀请您加入群组" setting:setting error:&error];
//        if(!error){
//            NSLog(@"创建成功 -- %@",group);
//        }
        var error: EMError? = nil
        let setting = EMGroupOptions()
        setting.maxUsersCount = 500
        setting.style = EMGroupStylePrivateMemberCanInvite
        setting.isInviteNeedConfirm = false
        let group = EMClient.shared().groupManager.createGroup(withSubject: "群组名称11", description: "群组描述222", invitees: ["15981870363","17621969367"], message: "邀请您加入群组", setting: setting, error: &error)
        if (error == nil) {
               print("创建成功",group)
            self.lbGroupName.set_text = group?.groupId
            self.tfGroupName.text = group?.groupId
        }
    }
    @IBAction func clickSingAction(_ sender: Any) {
        let dui_emId = tfName.text! //要聊的对方的环信id
        let vc = EaseMessageViewController.init(conversationChatter: dui_emId, conversationType: EMConversationTypeChat)
        self.pushVC(vc!)
    }
    
    @IBAction func clickGroupVCAction(_ sender: Any) {
//        EaseMessageViewController *chatController = [[EaseMessageViewController alloc] initWithConversationChatter:@"groupId" conversationType:EMConversationTypeGroupChat];
        let chatGroup = EaseMessageViewController.init(conversationChatter: lbGroupName.text!, conversationType: EMConversationTypeGroupChat)
        self.pushVC(chatGroup!)
    }
    @IBAction func clickAddGroupAction(_ sender: Any) {
        var error: EMError? = nil
//        [[EMClient sharedClient].groupManager addOccupants:@[@"user1"] toGroup:@"groupId" welcomeMessage:@"message" error:&error];
        EMClient.shared().groupManager.addOccupants([tfJoinName.text!], toGroup: lbGroupName.text!, welcomeMessage: "欢迎进入群组哈哈哈", error: &error)
        if (error == nil) {
            print("加入成功",tfJoinName.text!)
            let chatGroup = EaseMessageViewController.init(conversationChatter: lbGroupName.text!, conversationType: EMConversationTypeGroupChat)
            self.pushVC(chatGroup!)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let vc = easem
//        let vc = easemessage

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
