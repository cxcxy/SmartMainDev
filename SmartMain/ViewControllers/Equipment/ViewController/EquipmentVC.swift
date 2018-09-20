//
//  EquipmentVC.swift
//  SmartMain
//
//  Created by mac on 2018/9/4.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class EquipmentVC: XBBaseTableViewController {
    var dataArr: [EquipmentModel] = []
    let drawerViewController = DrawerViewController()
//    var mqttSession: MQTTSession!
    let scoketModel = ScoketMQTTManager.share
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的设备"
        makeItemNavRight()
        self.currentNavigationColor = MGRgb(0, g: 145, b: 222)
        self.currentNavigationTitleColor = UIColor.white
        tableView.cellId_register("EquipmentListCell")
    }
    func makeItemNavRight()  {
        //MARK: 点击添加商家
        makeCustomerImageNavigationItem("icon_tianjia", left: false) {
            VCRouter.qrCodeScanVC()
        }
        //MARK: 点击添加商家
        makeCustomerImageNavigationItem("icon_tianjia", left: true) {
            VCRouter.qrCodeScanVC()
        }
        makeCustomerNavigationItem("音乐", left: true) {
//            let vc = SmartPlayerViewController()
//            self.pushVC(vc)
            self.maskAnimationFromLeft()
        }
    }
    func maskAnimationFromLeft() {
      
        self.cw_showDrawerViewController(drawerViewController,
                                         animationType: .mask,
                                         configuration: CWLateralSlideConfiguration())
    }
    override func setUI() {
        super.setUI()
        self.cofigMjHeader()
        request()
        _ = Noti(.refreshEquipmentInfo).takeUntil(self.rx.deallocated).subscribe(onNext: {[weak self] (value) in
            guard let `self` = self else { return }
            self.request()
        })
        checkEquipmentOnline()
    }
    
    func checkEquipmentOnline() {
        
        Net.requestWithTarget(.getEquimentInfo(deviceId: XBUserManager.device_Id), successClosure: { (result, code, message) in
            if let model = Mapper<EquipmentInfoModel>().map(JSONString: result as! String) {
                
                if model.online == 1 {
                    print("当前设备在线")
                    XBUserManager.online = true
                }else {
                    print("当前设备不在线00")
                    XBUserManager.online = false
                }
                
            }else {
                print("当前设备不在线")
                XBUserManager.online = false
            }
        })

        
    }
    override func request() {
        super.request()
        guard XBUserManager.device_Id != "" else {
            endRefresh()
            return
        }
        Net.requestWithTarget(.getTrackList(deviceId: XBUserManager.device_Id), successClosure: { (result, code, message) in
            print(result)
            if let arr = Mapper<EquipmentModel>().mapArray(JSONString: result as! String) {
                self.endRefresh()
                self.dataArr = arr
                self.tableView.reloadData()
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
extension EquipmentVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArr.count
        
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return dataArr.count == 0 ? XBMin : 310
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = EquipmentTopView.loadFromNib()
        v.addTapGesture { (sender) in
            VCRouter.toEquipmentSettingVC()
        }
        return dataArr.count == 0 ? nil : v
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EquipmentListCell", for: indexPath) as! EquipmentListCell
        cell.lbTitle.set_text = dataArr[indexPath.row].name
        let trackCount = dataArr[indexPath.row].trackCount ?? 0
        cell.lbNumber.set_text = "共" + trackCount.toString + "首"
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        VCRouter.toEquipmentSubListVC(trackListId: dataArr[indexPath.row].id ?? 0,navTitle: dataArr[indexPath.row].name)
    }
    override func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
      return  NSAttributedString(string: "暂无绑定设备",
                           attributes:[NSAttributedStringKey.foregroundColor:MGRgb(25, g: 28, b: 39),
                                       NSAttributedStringKey.font:UIFont.systemFont(ofSize: 17)])

    }
    
}
