//
//  LikeViewController.swift
//  SmartMain
//
//  Created by mac on 2018/9/4.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class LikeViewController: XBBaseTableViewController {
    var dataArr: [ConetentLikeModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.cellId_register("HistorySongCell")
        tableView.cellId_register("HistorySongContentCell")
        self.cofigMjHeader()
    }
    override func setUI() {
        super.setUI()
        request()
    }
    override func request() {
        super.request()
        guard let phone = user_defaults.get(for: .userName) else {
            XBHud.showMsg("请登录")
            return
        }
        Net.requestWithTarget(.getLikeList(openId: phone), successClosure: { (result, code, message) in
            print(result)
            if let arr = Mapper<ConetentLikeModel>().mapArray(JSONString: result as! String) {
                if self.pageIndex == 1 {
                    self.cofigMjFooter()
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
extension LikeViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let m  = dataArr[section]
        return m.isExpanded ? 2 : 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistorySongCell", for: indexPath) as! HistorySongCell
            let m  = dataArr[indexPath.row]
            cell.lbTitle.set_text = m.title
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistorySongContentCell", for: indexPath) as! HistorySongContentCell
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let m  = dataArr[indexPath.section]
        m.isExpanded = !m.isExpanded
        tableView.reloadSections([indexPath.section], animationStyle: .automatic)
        
    }
    
}
