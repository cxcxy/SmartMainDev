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
        self.title = "微聊"
        self.configTableView(tableView, register_cell: ["ContentSingCell"])
        self.tableView.mj_header = self.mj_header
        request()
    }
    override func request() {
        super.request()
//        self.dataArr = EMClient.shared().chatManager.getAllConversations() as! [EMConversation]
        print(dataArr)
        self.endRefresh()
        self.tableView.reloadData()
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
extension ChatMainViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArr.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentSingCell", for: indexPath) as! ContentSingCell
//        cell.likeModelData = dataArr[indexPath.row]
//        cell.lbLineNumber.set_text = (indexPath.row + 1).toString
        let m = dataArr[indexPath.row]
        if m.type == EMConversationTypeGroupChat {
            print("为群组")
            cell.lbTitle.set_text = "群组" + m.conversationId
//            cell.lbTime.set_text = m.latestMessage.body.type.rawValue
        }
        if m.type == EMConversationTypeChat {
            print("为单聊")
            cell.lbTitle.set_text = "单聊" + m.conversationId
        }
        if m.latestMessage.body.type == EMMessageBodyTypeText {
            let textBody: EMTextMessageBody = m.latestMessage.body as! EMTextMessageBody
            cell.lbTime.set_text = textBody.text
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let m = dataArr[indexPath.row]
        if m.type == EMConversationTypeGroupChat {
            let chatGroup = EaseMessageViewController.init(conversationChatter: m.conversationId, conversationType: EMConversationTypeGroupChat)
            self.pushVC(chatGroup!)
        }
        if m.type == EMConversationTypeChat {
            print("为单聊")
            let vc = EaseMessageViewController.init(conversationChatter: m.conversationId, conversationType: EMConversationTypeChat)
            self.pushVC(vc!)
        }
    }
    
}
