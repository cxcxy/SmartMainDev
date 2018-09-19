//
//  ContentSubVC.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/4.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class ContentSubVC: XBBaseTableViewController {
    var clientId: String!
    var albumId: String?
    var modouleId: String?
    var dataArr: [ModulesConetentModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func setUI() {
        super.setUI()
        self.currentNavigationColor = UIColor.white
        self.currentNavigationTitleColor = UIColor.black
        tableView.cellId_register("ContentSubShowCell")
        self.cofigMJRefresh()
        request()
    }
    override func request() {
        super.request()
        var params_task = [String: Any]()
        params_task["clientId"] = clientId
        params_task["moduleId"] = modouleId
        params_task["albumId"] = albumId
        params_task["page"] = self.pageIndex
        params_task["count"] = XBPageSize
        Net.requestWithTarget(.contentsub(req: params_task), successClosure: { (result, code, message) in
            if let arr = Mapper<ModulesConetentModel>().mapArray(JSONObject:JSON(result)["categories"].arrayObject) {
                if self.pageIndex == 1 {
                    self.dataArr.removeAll()
                }
                self.dataArr += arr
                self.refreshStatus(status: arr.checkRefreshStatus(self.pageIndex))
                self.tableView.reloadData()
            }
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension ContentSubVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArr.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentSubShowCell", for: indexPath) as! ContentSubShowCell
        cell.lbTitle.set_text = dataArr[indexPath.row].name
        cell.imgIcon.set_Img_Url(dataArr[indexPath.row].imgSmall)
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        VCRouter.toContentSubVC()
        let model = dataArr[indexPath.row]
        if model.albumType == 2 {
            VCRouter.toContentSubVC(clientId: XBUserManager.device_Id, albumId: model.id ?? "", navTitle: model.name)
        }else {
            VCRouter.toContentSingsVC(clientId: XBUserManager.device_Id, albumId: model.id ?? "")
        }
    }
    
}
