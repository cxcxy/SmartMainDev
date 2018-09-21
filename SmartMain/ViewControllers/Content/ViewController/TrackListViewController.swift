//
//  TrackListViewController.swift
//  SmartMain
//
//  Created by mac on 2018/9/21.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class TrackListViewController: XBBaseTableViewController {

    var dataArr: [EquipmentModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.cellId_register("ContentSingCell")
        self.cofigMjHeader()
    }
    override func setUI() {
        super.setUI()
        tableView.contentInset = UIEdgeInsets.init(top: 10, left: 0, bottom: 80, right: 0)
        request()
    }
    override func request() {
        super.request()
        guard XBUserManager.device_Id != "" else {
            endRefresh()
            return
        }
        Net.requestWithTarget(.getTrackList(deviceId: XBUserManager.device_Id), successClosure: { (result, code, message) in
            if let arr = Mapper<EquipmentModel>().mapArray(JSONString: result as! String) {
                self.endRefresh()
                self.dataArr = arr
                self.tableView.reloadData()
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension TrackListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentSingCell", for: indexPath) as! ContentSingCell
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    // Header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? SMAllClassViewHeader ?? SMAllClassViewHeader(reuseIdentifier: "header")
         let trackCount = dataArr[section].trackCount ?? 0
        let count = "（" + trackCount.toString + "）"
        header.titleLabel.set_text = dataArr[section].name! + count
        header.section = section
        header.delegate = self
        
        return header
        
        
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView()
        v.frame = CGRect.init(x: 0, y: 0, w: tableView.w, h: 10)
        v.backgroundColor = UIColor.white
        return v
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}
extension TrackListViewController: SMAllClassViewHeaderDelegate {
    
    func toggleSection(_ header: SMAllClassViewHeader, section: Int) {
        let model = dataArr[section]
        VCRouter.toEquipmentSubListVC(trackListId: model.id ?? 0,navTitle: model.name)
    }
    
}
