//
//  TrackListViewController.swift
//  SmartMain
//
//  Created by mac on 2018/9/21.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class TrackListViewController: XBBaseTableViewController {
    var currentDeviceId: String?
    var dataArr: [EquipmentModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentNavigationHidden = true
        tableView.cellId_register("TrackListHomeCell")
        self.cofigMjHeader()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let currentDeviceId = currentDeviceId else {
            return
        }
        if currentDeviceId != XBUserManager.device_Id{  // 如果当前的设备ID有变化
            request()
        }
    }
    override func setUI() {
        super.setUI()
        
        _ = Noti(.refreshTrackList).takeUntil(self.rx.deallocated).subscribe(onNext: {[weak self] (value) in
            guard let `self` = self else { return }
            self.request()
        })
        
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 80, right: 0)
        request()
    }
    func starAnimationWithTableView(tableView: UITableView) {
        //        table
        if self.pageIndex == 1 {
            TableViewAnimationKit.show(with: .alpha, tableView: tableView)
        }
        
    }
    override func request() {
        super.request()
        self.currentDeviceId = XBUserManager.device_Id
        guard XBUserManager.device_Id != "" else {
            self.loading = true
            endRefresh()
            return
        }

        Net.requestWithTarget(.getTrackList(deviceId: XBUserManager.device_Id), successClosure: { (result, code, message) in
            if let arr = Mapper<EquipmentModel>().mapArray(JSONString: result as! String) {
                self.loading = true
                self.endRefresh()
                self.dataArr = arr
                self.tableView.reloadData()
                self.starAnimationWithTableView(tableView: self.tableView)
            }
        }) { (errorMsg) in
            if errorMsg == ERROR_TIMEOUT {
                self.loadingTimerOut = true
            } else {
                self.loading = true
            }
            self.endRefresh()
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension TrackListViewController {
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return dataArr.count
//    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArr.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackListHomeCell", for: indexPath) as! TrackListHomeCell
        
        let model = dataArr[indexPath.row]
        let trackCount = model.trackCount ?? 0
        let count = "共" + trackCount.toString + "首"
        cell.lbTitle.set_text = model.name
        
        cell.lbTatal.set_text = count
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArr[indexPath.row]
        VCRouter.toEquipmentSubListVC(trackListId: model.id ?? 0,navTitle: model.name,trackList: dataArr)
    }
    
//    // Header
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? SMAllClassViewHeader ?? SMAllClassViewHeader(reuseIdentifier: "header")
//         let trackCount = dataArr[section].trackCount ?? 0
//        let count = "（" + trackCount.toString + "）"
//        header.titleLabel.set_text = dataArr[section].name! + count
//        header.section = section
//        header.delegate = self
//
//        return header
//
//
//    }
//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 10
//    }
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let v = UIView()
//        v.frame = CGRect.init(x: 0, y: 0, w: tableView.w, h: 10)
//        v.backgroundColor = UIColor.white
//        return v
//    }
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 30
//    }
}
extension TrackListViewController: SMAllClassViewHeaderDelegate {
    
    func toggleSection(_ header: SMAllClassViewHeader, section: Int) {
        let model = dataArr[section]
        VCRouter.toEquipmentSubListVC(trackListId: model.id ?? 0,navTitle: model.name,trackList: dataArr)
    }
    
}
