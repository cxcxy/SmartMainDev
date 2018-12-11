//
//  ChatMainViewController.swift
//  SmartMain
//
//  Created by mac on 2018/9/18.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class ChatMainViewController: XBBaseViewController {
    var dataArr: [EMGroup] = []
    let globalQueue  = DispatchQueue.global()
    let group        = DispatchGroup()
    var devicesIds: [String] = [] {
        didSet {
            self.devicesInfo.remove_All()
            for devices in devicesIds.enumerated(){
                group.enter()// 标记
                
                DispatchQueue.global().async(group: group) {
                    
                    self.requestDevicesInfo(deviceId: devices.element)
                }
            }
            // 统一回调通知完成
            group.notify(queue: globalQueue) {
                XBHud.dismiss()
                self.reloadTableData()
            }
        }
    }
    var devicesInfo: [XBDeviceBabyModel] = []
    var conversations: [EMConversation] = [] // 获取群组回话信息
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

//        title = "群聊"
        // Do any additional setup after loading the view.
    }
    func requestDevicesInfo(deviceId: String) {
        Net.requestWithTarget(.getBabyInfo(deviceId: deviceId), successClosure: { (result, code, message) in
            if let obj = Net.filterStatus(jsonString: result) {
                if let model = Mapper<XBDeviceBabyModel>().map(JSONObject: obj.object) {
                    self.endRefresh()
                    self.devicesInfo.append(model)
                    self.group.leave()// 完成
                }
            }
        })
//        Net.requestWithTarget(.getEquimentInfo(deviceId: XBUserManager.device_Id), successClosure: { (result, code, message) in
//            if let model = Mapper<EquipmentInfoModel>().map(JSONString: result as! String) {
//                self.endRefresh()
//                self.devicesInfo.append(model)
//                self.group.leave()// 完成
//            }
//        })
    }
    func reloadTableData()  {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        request()
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
        tableView.backgroundColor = UIColor.init(hexString: "F2F2F2")
//        request()
        configChatMessage()
    }
    func configChatMessage()  {
        EMClient.shared().chatManager.add(self, delegateQueue: nil)
    }
    deinit {
        EMClient.shared()?.chatManager.remove(self)
    }
    override func request() {
        super.request()

        if let arr = EMClient.shared().groupManager.getJoinedGroups() as? [EMGroup] { //  获取 群组信息
            
            var groupArr = arr
            var devices_Id:[String] = []
            for group in groupArr.enumerated().reversed() {
//                print(group.element)
                if let descMap = group.element.description.json_Str()["descMap"].string  {
//                    print("--------")
//                     print(XBUserManager.userDevices.contains(descMap))
//                    print("--------")
                    if XBUserManager.userDevices.contains(descMap) {
                        devices_Id.append(descMap)
                    }else {
                        groupArr.remove(at: group.offset)
                    }
                }else {
                    groupArr.remove(at: group.offset)
                }
            }
            self.devicesIds = devices_Id
            self.dataArr = groupArr

        }
        
        if let conversations = EMClient.shared()?.chatManager.getAllConversations() as? [EMConversation] { // 如果能拿到群组回话信息 ，则获取群组回话信息co
            let conversations_Arr: [String] = dataArr.compactMap { (item) -> String in
                return item.groupId
            }
            var conversationsArr = conversations
            for group in conversations.enumerated().reversed() {
                if !conversations_Arr.contains(group.element.conversationId) {
                    conversationsArr.remove(at: group.offset)
                }
            }
            self.conversations = conversationsArr
        }
        self.endRefresh()
        self.loading = true
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension ChatMainViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let conversations = self.dataConversationArr {
//            return conversations.count
//        }else if let groupArr = self.dataArr {
//            return groupArr.count
//        }
        if self.conversations.count == 0 || self.dataArr.count > self.conversations.count{
            return self.dataArr.count
        }else {
            return self.conversations.count
        }
        return 0
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.conversations.count == 0 || self.dataArr.count > self.conversations.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMainCell", for: indexPath) as! ChatMainCell
            let m = dataArr[indexPath.row]
            cell.lbName.set_text = m.subject
            cell.viewMessage.isHidden = true
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMainCell", for: indexPath) as! ChatMainCell
            let m = conversations[indexPath.row]
            
            //            cell.lbName.set_text = m.conversationId
            if Int(m.unreadMessagesCount) > 0 {
                cell.viewMessage.isHidden = false
                cell.lbMessage.set_text = Int(m.unreadMessagesCount).toString
            }else {
                cell.viewMessage.isHidden = true
                cell.lbMessage.set_text = ""
            }
            
            if self.dataArr.count > 0 {
                let group_m = dataArr.get(at: indexPath.row)
                cell.lbName.set_text = group_m?.subject
            }else {
                cell.lbName.set_text = ""
            }
            if let lastMessage = m.latestMessage {
                cell.lbTime.set_text = NSDate.formattedTime(fromTimeInterval: lastMessage.timestamp )
                switch lastMessage.body.type {
                case EMMessageBodyTypeText:
                    let textBody: EMTextMessageBody = m.latestMessage.body as! EMTextMessageBody
                    let didReceiveText = EaseConvertToCommonEmoticonsHelper.convert(toSystemEmoticons: textBody.text)
                    cell.lbDes.set_text = didReceiveText
                    break
                case EMMessageBodyTypeVoice:
                    cell.lbDes.set_text = "[语音]"
                    break
                case EMMessageBodyTypeImage:
                    cell.lbDes.set_text = "[图片]"
                default:
                    cell.lbDes.set_text = ""
                    break
                }
            }
            if self.devicesInfo.count > indexPath.row {
                let deviceInfo = self.devicesInfo[indexPath.row]
                cell.imgPhoto.set_Img_Url(deviceInfo.headimgurl)
                cell.lbName.set_text = deviceInfo.babyname
            }
            return cell
        }
        

//        if m.type == EMConversationTypeGroupChat {
//            print("为群组")
//            cell.lbName.set_text = "群组" + m.conversationId
////            cell.lbTime.set_text = m.latestMessage.body.type.rawValue
//        }
//        if m.type == EMConversationTypeChat {
//            print("为单聊")
//            cell.lbName.set_text = "单聊" + m.conversationId
//        }
//        if m.latestMessage.body.type == EMMessageBodyTypeText {
//            let textBody: EMTextMessageBody = m.latestMessage.body as! EMTextMessageBody
//            cell.lbDes.set_text = textBody.text
//        }
        return UITableViewCell()
    }
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
//    {
//        let footer = ChatCreateView.loadFromNib()
//        footer.btnAdd.addAction { [weak self] in
//            guard let `self` = self else { return }
//            self.createGroupChat()
//        }
//        return footer
//    }
//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 105
//    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.conversations.count == 0 || self.dataArr.count > self.conversations.count{
            let m = dataArr[indexPath.row]
            let chatGroup = ChatGroupController.init(conversationChatter: m.groupId, conversationType: EMConversationTypeGroupChat)
            chatGroup?.groupName = m.subject
            self.pushVC(chatGroup!)
        }else {
            let m = conversations[indexPath.row]
            let chatGroup = ChatGroupController.init(conversationChatter: m.conversationId, conversationType: EMConversationTypeGroupChat)
            chatGroup?.groupName = m.description
            if self.dataArr.count > 0 {
                let group_m = dataArr.get(at: indexPath.row)
//                cell.lbName.set_text = group_m?.subject
                chatGroup?.groupName = group_m?.subject
            }
            self.pushVC(chatGroup!)
        }
//        if  conversations.count > 0 {
////            return conversations.count
//            let m = conversations[indexPath.row]
//            let chatGroup = ChatGroupController.init(conversationChatter: m.conversationId, conversationType: EMConversationTypeGroupChat)
//            chatGroup?.groupName = m.description
//            self.pushVC(chatGroup!)
//        }else if self.dataArr.count > 0 {
////            return groupArr.count
//            let m = dataArr[indexPath.row]
//            let chatGroup = ChatGroupController.init(conversationChatter: m.groupId, conversationType: EMConversationTypeGroupChat)
//            chatGroup?.groupName = m.subject
//            self.pushVC(chatGroup!)
//        }
        
        
        
//        if m.type == EMConversationTypeGroupChat {
//            let chatGroup = ChatGroupController.init(conversationChatter: m.groupId, conversationType: EMConversationTypeGroupChat)
//            chatGroup?.groupName = m.subject
//            self.pushVC(chatGroup!)
//        }
//        if m.type == EMConversationTypeChat {
//            print("为单聊")
//            let vc = EaseMessageViewController.init(conversationChatter: m.conversationId, conversationType: EMConversationTypeChat)
//            self.pushVC(vc!)
//        }
    }
}
extension ChatMainViewController {
    func createGroupChat()  {
        var error: EMError? = nil
        let setting = EMGroupOptions()
        setting.maxUsersCount = 500
        setting.style = EMGroupStylePrivateMemberCanInvite
        setting.isInviteNeedConfirm = false
        let group = EMClient.shared().groupManager.createGroup(withSubject: "群组名称11", description: "群组描述222", invitees: ["15981870363"], message: "邀请您加入群组", setting: setting, error: &error)
        if (error == nil) {
            let chatGroup = ChatGroupController.init(conversationChatter: group?.groupId, conversationType: EMConversationTypeGroupChat)
            self.pushVC(chatGroup!)
        }else {
            print(error)
        }
    }
}
extension ChatMainViewController: EMChatManagerDelegate {
    // 收到消息
    func messagesDidReceive(_ aMessages: [Any]!) {
        print("收到消息", aMessages)
        self.request()
    }
}
