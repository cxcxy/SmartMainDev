//
//  HistoryViewController.swift
//  SmartMain
//
//  Created by mac on 2018/9/4.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class HistoryViewController: XBBaseViewController {
    
    @IBOutlet weak var tfSearch: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
     var viewModel = ContentViewModel()
    var trackList: [EquipmentModel] = [] // 预制列表数据model
    var dataArr: [ConetentLikeModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 80, right: 0)
        self.configTableView(tableView, register_cell: ["HistorySongCell","HistorySongContentCell"])
        self.tableView.mj_header = self.mj_header
        
    }
    override func setUI() {
        super.setUI()
        _ = Noti(.refreshDeviceHistory).takeUntil(self.rx.deallocated).subscribe(onNext: {[weak self] (value) in
            guard let `self` = self else { return }
            self.request()
        })
        request()
    }
    override func request() {
        super.request()
        guard let deviceId = user_defaults.get(for: .deviceId) else {
//            XBHud.showMsg("请登录")
            self.loading = true
            return
        }
        Net.requestWithTarget(.getHistoryList(deviceId: deviceId), successClosure: { (result, code, message) in
            print(result)
            if let arr = Mapper<ConetentLikeModel>().mapArray(JSONString: result as! String) {
                if self.pageIndex == 1 {
                    self.tableView.mj_footer = self.mj_footer
                    self.dataArr.removeAll()
                }
                self.loading = true
                self.dataArr += arr
                self.refreshStatus(status: arr.checkRefreshStatus(self.pageIndex))
                self.tableView.reloadData()
                self.starAnimationWithTableView(tableView: self.tableView)
            }
        })
    }
    func starAnimationWithTableView(tableView: UITableView) {
        //        table
        if self.pageIndex == 1 {
            TableViewAnimationKit.show(with: .moveSpring, tableView: tableView)
        }
        
    }
    func requestTrackList() {
        guard XBUserManager.device_Id != "" else {
            endRefresh()
            return
        }
        Net.requestWithTarget(.getTrackList(deviceId: XBUserManager.device_Id), successClosure: { (result, code, message) in
            print(result)
            if let arr = Mapper<EquipmentModel>().mapArray(JSONString: result as! String) {
                self.endRefresh()
                self.trackList = arr
                self.tableView.reloadData()
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func showTrackListAction()  {
        guard trackList.count > 0 else {
            return
        }
        let arr  = trackList.compactMap { (item) -> String in
            return item.name ?? ""
            } as [String]
        
        VCRouter.prentSheetAction(dataArr: arr) { (index) in
            let trackId = self.trackList[index].id ?? 0
            let trackName = self.trackList[index].name ?? ""
            self.requestAddSingWithList(listId: trackId,listName: trackName)
        }
    }
    /**
     *   删除点播历史
     */
    func requestDeleteDemand(trackId: Int?,secion: Int)  {
        
        var params_task = [String: Any]()
        params_task["deviceId"] = XBUserManager.device_Id
        params_task["trackId"]  = (trackId ?? 0).toString
        Net.requestWithTarget(.deleteDemand(req: params_task), successClosure: { (result, code, message) in
            print(result)
            if let str = result as? String {
                if str == "ok" {
                    self.dataArr.remove(at: secion)
                    self.tableView.reloadData()
                    XBHud.showMsg("删除点播成功")
                }else {
                    XBHud.showMsg("删除点播失败")
                }
            }
        })
        
    }
    /**
     *   增加歌曲到预制列表中
     */
    func requestAddSingWithList(listId: Int,listName: String)  {
//        guard let m = self.modelData,let headerInfo = self.headerInfo else {
//            XBHud.showMsg("所需信息不全")
//            return
//        }
//        let req_model = AddSongTrackReqModel()
//        if let arr = m.resId?.components(separatedBy: ":") {
//            if arr.count > 0 {
//                req_model.id = arr[1].toInt()
//            }
//        }
//        req_model.title = m.name
//        req_model.coverSmallUrl = ""
//        req_model.duration = m.length
//        req_model.albumTitle = headerInfo.name
//        req_model.albumCoverSmallUrl = headerInfo.imgSmall
//        req_model.url = m.content
//        req_model.downloadSize = 1
//        req_model.downloadUrl = m.content
//        Net.requestWithTarget(.addSongToList(deviceId: XBUserManager.device_Id, listId: listId, listName: listName, trackIds: [req_model]), successClosure: { (result, code, message) in
//            print(result)
//            if let str = result as? String {
//                if str == "ok" {
//                    XBHud.showMsg("加入成功")
//                }else if str == "duplicate" {
//                    XBHud.showMsg("歌单已经存在")
//                }
//            }
//        })
    }
}
extension HistoryViewController {
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
            let m  = dataArr[indexPath.section]
            cell.lbTitle.set_text = m.title
            cell.lbTime.set_text = XBUtil.getDetailTimeWithTimestamp(timeStamp: m.duration)
            cell.btnExtension.isSelected = m.isExpanded
            cell.btnExtension.addAction {[weak self] in
                guard let `self` = self else { return }
                self.clickExtensionAction(indexPath: indexPath)
            }
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistorySongContentCell", for: indexPath) as! HistorySongContentCell
//            let m  = dataArr[indexPath.section]
//            cell.viewAdd.addTapGesture { (sender) in
//
//            }
            cell.viewAdd.isHidden = true
            cell.viewLike.isHidden = true
             let m  = dataArr[indexPath.section]
            cell.viewDel.addTapGesture { (sender) in
                self.requestDeleteDemand(trackId: m.trackId,secion: indexPath.section)
            }
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard XBUserManager.device_Id != "" else {
            XBHud.showMsg("请先绑定设备")
            return
        }
        self.requestOnlineSing(trackId: dataArr[indexPath.section].trackId?.toString ?? "")
        
    }

    func clickExtensionAction(indexPath: IndexPath)  {
      
            let m  = dataArr[indexPath.section]
            m.isExpanded = !m.isExpanded
            tableView.reloadSections([indexPath.section], animationStyle: .automatic)

    }
    //MARK: 在线点播歌曲
    func requestOnlineSing(trackId: String)  {
        
        viewModel.requestOnlineSing(openId: user_defaults.get(for: .userName)!, trackId: trackId, deviceId: XBUserManager.device_Id) {
            
        }
    }
}
