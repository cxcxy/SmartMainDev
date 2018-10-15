//
//  MemberManagerVC.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/4.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class MemberManagerVC: XBBaseViewController {
    var dataArr: [FamilyMemberModel] = [] {
        didSet{
            for item in dataArr {
                if item.easeadmin == "1" && item.username == XBUserManager.userName { // 判断当前用户是否是管理员
                    self.currentIsAdmin = true
                    
                    break
                }
            }
        }
    }
     let itemWidth:CGFloat = ( MGScreenWidth - 20 - 20 - 20 ) / 2 // item 宽度
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnBottom: UIButton!
    @IBOutlet weak var btnBootomLayout: NSLayoutConstraint!
    
    var currentIsAdmin: Bool = false {
        didSet {
            self.configBottomBtnTitle(isAdmin: currentIsAdmin)
        }
    }
    
    var editStatus: Bool = false {
        didSet {
            self.editStatusChangeAction(status: editStatus)
        }
    }
    var groupId: String?
    var viewModel = LoginViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setUI() {
        super.setUI()
        title = "设备成员"
        configCollectionView()
        request()
        makeCustomerNavigationItem("编辑", left: false) {
            self.editStatus = true
        }
        self.btnBottom.radius_ll()
        self.configBottomBtnTitle(isAdmin: currentIsAdmin)
    }
    func configBottomBtnTitle(isAdmin: Bool)  {
        self.btnBottom.set_Title(isAdmin ? "解散该群组" : "退出该群组")
    }
    func editStatusChangeAction(status: Bool)  {
        if status {
            makeCustomerNavigationItem("取消", left: false) {
                self.editStatus = false
            }
            
        }else {
            makeCustomerNavigationItem("编辑", left: false) {
                self.editStatus = true
            }
        }
        
        self.btnBootomAnimation(status: status)
    }
    func btnBootomAnimation(status: Bool) {
        btnBootomLayout.constant = status ? 15 : -58
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            if let strongSelf = self {
                strongSelf.view.layoutIfNeeded()
                strongSelf.collectionView.reloadData()
            }
        })
    }
    
    @IBAction func clickBottomAction(_ sender: Any) {
        guard let groupId = self.groupId else {
            return
        }
        self.managerGroup(easeadmin: self.currentIsAdmin ? "1" : "0", username: XBUserManager.userName, groupId: groupId)
    }
    override func request() {
        super.request()
        guard XBUserManager.device_Id != "" else {
            return
        }
        Net.requestWithTarget(.getFamilyMemberList(deviceId: XBUserManager.device_Id), successClosure: { (result, code, msg) in
            print(result)
            if let arr = Mapper<FamilyMemberModel>().mapArray(JSONObject: JSON.init(parseJSON: result as! String).arrayObject) {
                    self.dataArr = arr
                    self.refreshStatus(status: arr.checkRefreshStatus(self.pageIndex))
                    self.collectionView.reloadData()
                    self.groupId = arr.get(at: 0)?.groupid
            }
        })
    }
    

    func configCollectionView()  {
        collectionView.cellId_register("DeviceChooseCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
   
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
extension MemberManagerVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeviceChooseCell", for: indexPath)as! DeviceChooseCell
//        cell.imgIcon.contentMode = .scaleAspectFit
        cell.imgPhoto.set_Img_Url(dataArr[indexPath.row].headImgUrl)
        cell.lbName.set_text = dataArr[indexPath.row].nickname
      
        let model = dataArr[indexPath.row]
        if model.easeadmin == "1" {
            cell.lbCurrent.isHidden = false
            cell.lbCurrent.set_text = "管理员"
            cell.btnDel.isHidden = true
        }else {
            cell.lbCurrent.isHidden = true
            cell.lbCurrent.set_text = ""
            if currentIsAdmin {
                cell.btnDel.isHidden =  !self.editStatus
            }else {
                 cell.btnDel.isHidden = true
            }
            
        }
        cell.btnDel.addAction {[weak self] in // 管理员进行删除成员操作
            guard let `self` = self else { return }
            self.clickItemWithDelte(indexPath: indexPath)
        }
        return cell
    }
    //最小item间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    //item 的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:itemWidth ,height:itemWidth)
    }
    //item 对应的点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    func clickItemWithDelte(indexPath: IndexPath)  {
        let model = dataArr[indexPath.row]
        if model.easeadmin == "1" && currentIsAdmin == false {
            return
        }
        
        self.managerGroup(easeadmin: model.easeadmin ?? "",username: model.username ?? "", groupId: model.groupid ?? "")
    }
    func managerGroup(easeadmin: String, username: String,groupId: String)  {
        let out = XBLoginOutView.loadFromNib()
        out.btnOut.set_Title("确定")
        var actionType:Int = 0
        if currentIsAdmin && username == XBUserManager.userName{ // 当前用户为管理员 切当前点击的是自己
            out.lbTitleDes.set_text = "是否解散群组？"
            actionType = 1

        } else if currentIsAdmin && username != XBUserManager.userName {// 当前用户为管理员 切当前点击的不是自己
            out.lbTitleDes.set_text = "是否将用户移出群组？"
            actionType = 0
            
        } else { // 当前是家庭成员
            out.lbTitleDes.set_text = "是否要退出群组？"
            actionType = 2
        }
        out.sureBlock = { [weak self] in
            guard let `self` = self else { return }
            self.clickOutAction(easeadmin: easeadmin, username: username, groupId: groupId, actionType: actionType)
        }
         out.show()
    }
    func clickOutAction(easeadmin: String,username: String,groupId: String, actionType: Int)  {
        
        var params_task = [String: Any]()
            params_task["username"] = username
            params_task["deviceid"] = XBUserManager.device_Id
            params_task["easeadmin"] = easeadmin
            params_task["groupid"]  = groupId
            Net.requestWithTarget(.quitGroup(byAdmin: currentIsAdmin, req: params_task), successClosure: { (result, code, message) in
                if let str = result as? String {
                    print(str)
                    XBHud.showMsg("操作成功")
                    if actionType == 0 { // 管理员移除成员
                        XBDelay.start(delay: 1, closure: {
                            self.editStatus = false
                            self.request()
                        })
                    }
                    if actionType == 1 { // 管理员解散群组 ！！！ 解散完之后，移除 用户设备ID
                        
                        self.viewModel.requestGetUserInfo(mobile: XBUserManager.userName) { [weak self] in
                            guard let `self` = self else { return }
//                            self.cofigDeviceInfo()
                            self.popToRootVC()
                        }
                    }
                    if actionType == 2 { // 用户主动退出群组
                        self.popToRootVC()
                        self.viewModel.requestGetUserInfo(mobile: XBUserManager.userName) { [weak self] in
                            guard let `self` = self else { return }
//                            self.cofigDeviceInfo()
                            self.popToRootVC()
                        }
                    }
                    
                    
                }
            })
        
    }
}
