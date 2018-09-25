//
//  ChatMainViewController.swift
//  SmartMain
//
//  Created by mac on 2018/9/18.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class ChatMainViewController: XBBaseViewController {
    var dataArr: [EMConversation] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

//        title = "群聊"
        // Do any additional setup after loading the view.
    }
    @IBAction func clickCreateVCAction(_ sender: Any) {
        let vc = ChatViewController()
        self.pushVC(vc)
    }
    override func setUI() {
        super.setUI()
        self.title = "聊天群组"
        self.configTableView(tableView, register_cell: ["ChatMainCell"])
        self.tableView.mj_header = self.mj_header
        self.tableView.backgroundColor = MGRgb(242, g: 242, b: 242)
        request()
    }
    override func request() {
        super.request()
        if let arr = EMClient.shared().chatManager.getAllConversations() as? [EMConversation] {
            self.dataArr = arr
        }

        self.endRefresh()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension ChatMainViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArr.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMainCell", for: indexPath) as! ChatMainCell
        let m = dataArr[indexPath.row]
        if m.type == EMConversationTypeGroupChat {
            print("为群组")
            cell.lbName.set_text = "群组" + m.conversationId
//            cell.lbTime.set_text = m.latestMessage.body.type.rawValue
        }
        if m.type == EMConversationTypeChat {
            print("为单聊")
            cell.lbName.set_text = "单聊" + m.conversationId
        }
        if m.latestMessage.body.type == EMMessageBodyTypeText {
            let textBody: EMTextMessageBody = m.latestMessage.body as! EMTextMessageBody
            cell.lbDes.set_text = textBody.text
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        let footer = ChatCreateView.loadFromNib()
        footer.btnAdd.addAction { [weak self] in
            guard let `self` = self else { return }
            self.createGroupChat()
        }
        return footer
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 105
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let m = dataArr[indexPath.row]
        if m.type == EMConversationTypeGroupChat {
            let chatGroup = ChatGroupController.init(conversationChatter: m.conversationId, conversationType: EMConversationTypeGroupChat)
            self.pushVC(chatGroup!)
        }
        if m.type == EMConversationTypeChat {
            print("为单聊")
            let vc = EaseMessageViewController.init(conversationChatter: m.conversationId, conversationType: EMConversationTypeChat)
            self.pushVC(vc!)
        }
    }
}
extension ChatMainViewController {
    func createGroupChat()  {
        var error: EMError? = nil
        let setting = EMGroupOptions()
        setting.maxUsersCount = 500
        setting.style = EMGroupStylePrivateMemberCanInvite
        setting.isInviteNeedConfirm = false
        let group = EMClient.shared().groupManager.createGroup(withSubject: "群组名称11", description: "群组描述222", invitees: ["17621969367"], message: "邀请您加入群组", setting: setting, error: &error)
        if (error == nil) {
            let chatGroup = ChatGroupController.init(conversationChatter: group?.groupId, conversationType: EMConversationTypeGroupChat)
            self.pushVC(chatGroup!)
        }
    }
}
