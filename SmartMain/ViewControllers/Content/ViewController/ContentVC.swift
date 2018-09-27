//
//  ContentVC.swift
//  SmartMain
//
//  Created by mac on 2018/9/4.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class ContentVC: XBBaseTableViewController {
    var dataArr: [ModulesResModel] = []
    var dataTrackArr: [EquipmentModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 80, right: 0)
        tableView.cellId_register("ContentHeaderCell")
        tableView.cellId_register("ContentShowCell")
        tableView.cellId_register("ContentShowThreeCell")
        tableView.mj_header = self.mj_header
    }
    override func setUI() {
        super.setUI()
        request()
    }
    override func request() {
        super.request()
        
        var params_task = [String: Any]()
        params_task["clientId"] = XBUserManager.device_Id
        params_task["tags"] = ["six"]
        Net.requestWithTarget(.contentModules(req: params_task), successClosure: { (result, code, message) in
            if let arr = Mapper<ModulesResModel>().mapArray(JSONObject:JSON(result)["modules"].arrayObject) {
               let filterArr = arr.filter({ (item) -> Bool in
                    if let contents = item.contents {
                        return contents.count > 0
                    }
                    return false
                })
                self.dataArr = filterArr
                self.endRefresh()
                self.tableView.reloadData()
            }
        })
    }
    func requestTrackList()  {
//        Net.requestWithTarget(.getTrackList(deviceId: XBUserManager.device_Id), successClosure: { (result, code, message) in
//            print(result)
//            if let arr = Mapper<EquipmentModel>().mapArray(JSONString: result as! String) {
//                self.endRefresh()
//                self.dataTrackArr = arr
//                self.tableView.reloadData()
//            }
//        })

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
extension ContentVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArr.count > 6 ? 7 : dataArr.count + 1
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentHeaderCell", for: indexPath) as! ContentHeaderCell
//            cell.dataArr = self.dataTrackArr
            return cell
        }
        if indexPath.row == 1 || indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentShowCell", for: indexPath) as! ContentShowCell
//            cell.collectionDataArr = ["1","2","3","4"]
            cell.dataModel = dataArr[indexPath.row - 1]
         
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentShowThreeCell", for: indexPath) as! ContentShowThreeCell
//        cell.collectionDataArr = ["1","2","3","4","1","2","3","4","1"]
        cell.dataModel = dataArr[indexPath.row - 1]
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        VCRouter.toContentSubVC()
        let vc = ContentSubVC()
        vc.clientId = XBUserManager.device_Id
//        vc.albumId =  model.id ?? ""
//        vc.modouleId = modouleId
        vc.title = "222"
        self.pushVC(vc)
    }
    
}
