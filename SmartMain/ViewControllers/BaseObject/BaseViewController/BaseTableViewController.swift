//
//  BaseTableViewController.swift
//  SmartMain
//
//  Created by mac on 2018/11/27.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class BaseTableViewController: XBBaseViewController {
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var dataDelegate: BaseTableViewDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func setUI() {
        super.setUI()
        dataDelegate.tableView = self.tableView
        
    }
    override func request() {
        super.request()
//        DeviceManager.isOnline { (isOnline, _) in
//            self.deviceOnline = isOnline
//        }
//        var params_task = [String: Any]()
//        params_task["trackListId"] = trackListId
//        params_task["currentPage"] = self.pageIndex
//        params_task["pageSize"] = XBPageSize
//        Net.requestWithTarget(.getTrackSubList(req: params_task), successClosure: { (result, code, message) in
//
//            if let arr = Mapper<EquipmentSingModel>().mapArray(JSONObject: JSON.init(parseJSON: result as! String)["tracks"].arrayObject) {
//                if self.pageIndex == 1 {
//                    self.dataArr.removeAll()
//                    self.tableView.mj_footer = self.mj_footer
//                }
//                self.dataArr += self.flatMapLikeList(arr: arr)
//                self.total = JSON.init(parseJSON: result as! String)["totalCount"].int
//                self.refreshStatus(status: arr.checkRefreshStatus(self.pageIndex))
//                self.scoketModel.sendGetTrack()
//                self.tableView.reloadData()
//                self.starAnimationWithTableView(tableView: self.tableView)
//            }
//        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
