//
//  GroupAddViewController.swift
//  SmartMain
//
//  Created by mac on 2018/9/26.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class GroupAddViewController: XBBaseTableViewController {
    var groupId: String!
    var groupName: String!
    var groupList: [String] = []
    var groupOwner: Bool  = false
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func setUI() {
        super.setUI()
        title = "微聊组信息"
        tableView.cellId_register("GroupItemCell")
        self.view.backgroundColor = UIColor.init(hexString: "F2F2F2")
        tableView.backgroundColor = UIColor.init(hexString: "F2F2F2")
        self.cofigMjHeader()
        _ = Noti(.refreshGroupInfo).takeUntil(self.rx.deallocated).subscribe(onNext: {[weak self] (value) in
            guard let `self` = self else { return }
            self.request()
        })
        request()
    }
    override func request() {
        super.request()

        EMClient.shared().groupManager.getGroupSpecificationFromServer(withId: groupId) {[weak self] (emGroup, error) in
            guard let `self` = self,let emGroup = emGroup else { return }
//            self.groupName = emGroup.description
            print(emGroup.members)
            print(emGroup.occupants)
            if emGroup.owner == XBUserManager.userName {
                self.groupOwner = true
            }else {
                self.groupOwner = false
            }
            if let list = emGroup.occupants as? [String] {
                self.groupList = list
                self.tableView.reloadData()
            }
        }
//        EMClient.shared().groupManager.getGroupMemberListFromServer(withId: groupId, cursor: "", pageSize: 0) {[weak self]  (cursorResult, error) in
//            guard let `self` = self,let cursorResult = cursorResult else { return }
//            if let list = cursorResult.list as? [String] {
//                self.groupList = list
//                self.tableView.reloadData()
//            }
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func clickOutAction()  {
        if groupOwner {
//            EMClient.shared().groupManager.destroyGroup(groupId) {[weak self] (error) in
//                guard let `self` = self else { return }
//                if error == nil {
//                    XBHud.showMsg("解散成功")
//                    self.popToRootVC()
//                }
//            }
            var params_task = [String: Any]()
            params_task["username"] = XBUserManager.userName
            params_task["deviceid"] = XBUserManager.device_Id
            params_task["easeadmin"] = 1
            params_task["groupid"] = groupId
            Net.requestWithTarget(.quitGroup(byAdmin: true, req: params_task), successClosure: { (result, code, message) in
                if let str = result as? String {
                        print(str)
                    XBHud.showMsg("解散成功")
                }
            })
        } else {
            var params_task = [String: Any]()
            params_task["username"] = XBUserManager.userName
            params_task["deviceid"] = XBUserManager.device_Id
            params_task["easeadmin"] = 0
            params_task["groupid"] = groupId
            Net.requestWithTarget(.quitGroup(byAdmin: false, req: params_task), successClosure: { (result, code, message) in
                if let str = result as? String {
                    print(str)
                    XBHud.showMsg("退出成功")
                }
            })
//            EMClient.shared().groupManager.leaveGroup(groupId) { [weak self] (error) in
//                guard let `self` = self else { return }
//                if error == nil {
//                    XBHud.showMsg("退出成功")
//                    self.popToRootVC()
//                }
//            }
        }
    }
    func updateGroupNick(nick: String)  {
        EMClient.shared().groupManager.updateGroupSubject(nick, forGroup: self.groupId) { (emGroup, error) in
            if error == nil {
                print("修改成功")
                self.groupName = nick
            }
        }
    }
    func toAddGroupMemberAction()  {
        let vc = GroupAddMemberController()
        vc.groupId = self.groupId
        self.pushVC(vc)
    }
}
extension GroupAddViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupItemCell", for: indexPath) as! GroupItemCell
            cell.contentArr = self.groupList
            cell.btnAdd.addAction { [weak self] in
                guard let `self` = self else { return }
                self.toAddGroupMemberAction()
            }
            cell.lbDes.set_text = "微聊组成员"
            cell.groupId        = self.groupId
            cell.groupOwner     = self.groupOwner
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupItemCell", for: indexPath) as! GroupItemCell
            cell.lbDes.set_text = "微聊组设备"
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let footer = ChatCreateView.loadFromNib()
        footer.lbTitle.set_text = "微聊组昵称"
        footer.tfName.text = self.groupName
        footer.btnAdd.set_Title("修改")
        footer.btnAdd.addAction { [weak self] in
            guard let `self` = self else { return }
            self.updateGroupNick(nick: footer.tfName.text!)
        }
        return footer
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 105
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        let v = UIView()
        v.frame = CGRect.init(x: 0, y: 0, w: MGScreenWidth, h: 65)
        let b               = UIButton(type: .custom)
        b.frame             = CGRect(x: 15, y: 15, width: MGScreenWidth - 30, height: 35)
        b.titleLabel!.font  =  UIFont.systemFont(ofSize: 14)
        b.backgroundColor = viewColor
        b.addAction { [weak self]in
            guard let `self` = self else { return }
            self.clickOutAction()
        }
        b.setCornerRadius(radius: 15)
        if groupOwner {
            b.set_Title("解散群聊组")
        }else {
            b.set_Title("退出群聊组")
        }
        
        v.addSubview(b)

        return v
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 65
    }
}
