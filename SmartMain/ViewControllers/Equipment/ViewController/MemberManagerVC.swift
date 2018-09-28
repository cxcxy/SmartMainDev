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
                if item.username == XBUserManager.userName {
                    self.currentIsAdmin = true
                } else {
                    self.currentIsAdmin = false
                }
            }
        }
    }
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
        Net.requestWithTarget(.getFamilyMemberList(deviceId: testDeviceId), successClosure: { (result, code, msg) in
            print(result)
            if let arr = Mapper<FamilyMemberModel>().mapArray(JSONObject: JSON.init(parseJSON: result as! String).arrayObject) {
                    self.dataArr = arr
                
                    self.refreshStatus(status: arr.checkRefreshStatus(self.pageIndex))
                    self.collectionView.reloadData()
            }
        })
    }
    

    func configCollectionView()  {
        collectionView.cellId_register("MemberCVCell")
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberCVCell", for: indexPath)as! MemberCVCell
        cell.imgIcon.contentMode = .scaleAspectFit
        cell.imgIcon.set_Img_Url(dataArr[indexPath.row].headImgUrl)
        cell.lbName.set_text = dataArr[indexPath.row].username
        let model = dataArr[indexPath.row]
        if model.easeadmin == "1" {
            cell.viewAdmin.isHidden = false
        }else {
            cell.viewAdmin.isHidden = true
        }
        return cell
    }
    //最小item间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    //item 的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:150 ,height:172)
    }
    //item 对应的点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let model = dataArr[indexPath.row]
            if model.easeadmin == "1" {
                
                VCRouter.prentAlertAction(message: "是否解散群组？") {
                    self.clickOutAction(groupOwner: true, groupId: model.groupid ?? "")
                    
                }
               
            }else {
                
                VCRouter.prentAlertAction(message: "是否退出群组？") {
                    self.clickOutAction(groupOwner: false, groupId: model.groupid ?? "")
                }
                
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
