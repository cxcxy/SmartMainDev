//
//  EquipmentListViewController.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/27.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class EquipmentListViewController: XBBaseViewController {
    let itemSpacing:CGFloat = 20 // item 间隔
    let itemWidth:CGFloat = ( MGScreenWidth - 20 - 20 - 20 ) / 2 // item 宽度
    @IBOutlet weak var collectionView: UICollectionView!
    var dataArr : [XBDeviceBabyModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setUI() {
        super.setUI()
        title = "切换设备"
        request()
        configCollectionView()
    }
    override func request() {
        super.request()
        Net.requestWithTarget(.getDeviceIds(userName: XBUserManager.userName), successClosure: { (result, code, message) in
            if let obj = Net.filterStatus(jsonString: result) {
                if let arr = Mapper<XBDeviceBabyModel>().mapArray(JSONObject: obj.object) {
                    for item in arr {
                        if item.deviceid == XBUserManager.device_Id {
                            item.isCurrent = true
                        }else {
                            item.isCurrent = false
                        }
                    }
                    self.dataArr = arr
                    self.collectionView.reloadData()
                }
            }
        })
    }
    func configCollectionView()  {
        
        collectionView.delegate     = self
        collectionView.dataSource   = self
        collectionView.cellId_register("DeviceChooseCell")
    }
    // 解绑设备
    func requestQuitDevice()  {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension EquipmentListViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeviceChooseCell", for: indexPath)as! DeviceChooseCell
//        let item = dataArr[indexPath.row]
        cell.model = dataArr.get(at: indexPath.row)
//        cell.btnDel.addAction { [weak self] in
//             guard let `self` = self else { return }
//             self.requestQuitDevice()
//        }
        cell.btnDel.isHidden = true
        return cell
    }
    //最小item间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    //item 的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:itemWidth,height:itemWidth)
    }
    //item 对应的点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let m = dataArr[indexPath.row]
        guard !m.isCurrent else {
            XBHud.showMsg("您当前使用的设备哦～")
            return
        }
        let out = XBLoginOutView.loadFromNib()
        out.btnOut.set_Title("确定")
        out.lbTitleDes.set_text = "确定切换设备吗？"
        out.sureBlock = { [weak self] in
            guard let `self` = self else { return }
            Noti_post(.refreshDeviceHistory)
            Noti_post(.refreshTrackList)
            XBUserManager.saveDeviceInfo(m)
            ScoketMQTTManager.share.subscribeToChannel(socket_clientId: m.deviceid ?? "")
            self.popToRootVC()
        }
        out.show()
    }
}
