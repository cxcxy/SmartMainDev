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
                } else {
                    self.currentIsAdmin = false
                }
            }
        }
    }
     let itemWidth:CGFloat = ( MGScreenWidth - 20 - 20 - 20 ) / 2 // item 宽度
    @IBOutlet weak var collectionView: UICollectionView!
    
    var currentIsAdmin: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setUI() {
        super.setUI()
        title = "家庭成员"
        configCollectionView()
        request()
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
            }
        })
    }
    

    func configCollectionView()  {
        collectionView.cellId_register("DeviceChooseCell")
        collectionView.dataSource = self
        collectionView.delegate = self
   
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
        }else {
            cell.lbCurrent.isHidden = true
            cell.lbCurrent.set_text = ""
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
        guard currentIsAdmin else {
            return
        }
            let model = dataArr[indexPath.row]
            self.managerGroup(easeadmin: model.easeadmin ?? "", groupId: model.groupid ?? "")
    }
    func managerGroup(easeadmin: String,groupId: String)  {
        
        if easeadmin == "1" {

            let out = XBLoginOutView.loadFromNib()
            out.btnOut.set_Title("确定")
            out.lbTitleDes.set_text = "是否解散群组？"
            out.sureBlock = { [weak self] in
                guard let `self` = self else { return }
                 self.clickOutAction(groupOwner: true, groupId: groupId)
            }
            out.show()

            
        }else {
            
            let out = XBLoginOutView.loadFromNib()
            out.btnOut.set_Title("确定")
            out.lbTitleDes.set_text = "是否退出群组？"
            out.sureBlock = { [weak self] in
                guard let `self` = self else { return }
                self.clickOutAction(groupOwner: false, groupId: groupId)
            }
            out.show()
            
        }
    }
    func clickOutAction(groupOwner: Bool,groupId: String)  {
        if groupOwner {
            var params_task = [String: Any]()
            params_task["username"] = XBUserManager.userName
            params_task["deviceid"] = XBUserManager.device_Id
            params_task["easeadmin"] = 1
            params_task["groupid"] = groupId
            Net.requestWithTarget(.quitGroup(byAdmin: true, req: params_task), successClosure: { (result, code, message) in
                if let str = result as? String {
                    print(str)
                    XBHud.showMsg("解散成功")
                    self.popToRootVC()
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
                    self.popToRootVC()
                }
            })
        }
    }
}
