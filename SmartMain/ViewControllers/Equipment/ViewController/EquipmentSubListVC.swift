//
//  ContentSingsVC.swift
//  SmartMain
//
//  Created by mac on 2018/9/5.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class EquipmentSubListVC: XBBaseTableViewController {
    var trackListId: Int! // 列表id
    var trackList: [EquipmentModel] = []
    var dataArr: [EquipmentSingModel] = []
    var headerInfo:ConetentSingAlbumModel?
    var total: Int?
    var viewModel = ContentViewModel()
    var viewDeviceModel = EquimentViewModel()
    var deviceOnline:Bool = false
    var scoketModel = ScoketMQTTManager.share
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func setUI() {
        super.setUI()
        self.registerCells(register_cells: ["ContentSingCell",
                                            "HistorySongCell",
                                            "HistorySongContentCell"])
        self.tableView.mj_header = self.mj_header
        
        request()
        configCurrentSongsId()
//        requestTrackList()
        ScoketMQTTManager.share.getSetDefaultMessage.asObservable().subscribe { [weak self] in
            guard let `self` = self else { return }
            print("getSetDefaultMessage ===：", $0.element ?? "")
            if let model = Mapper<GetTrackListDefault>().map(JSONString: $0.element!) {
                self.requestSetDefault(model: model)
            }
        }.disposed(by: rx_disposeBag)
    }
    func configCurrentSongsId()  {
        scoketModel.getPalyingSingsId.asObservable().subscribe { [weak self] in
            guard let `self` = self else { return }
            print("getPalyingSingsId ===：", $0.element ?? 0)
            
            self.mapSongsArrPlayingStatus(songId: $0.element ?? 0)
            }.disposed(by: rx_disposeBag)
    }
    override func request() {
        super.request()
        DeviceManager.isOnline { (isOnline, _) in
            self.deviceOnline = isOnline
        }
        var params_task = [String: Any]()
        params_task["trackListId"] = trackListId
        params_task["currentPage"] = self.pageIndex
        params_task["pageSize"] = XBPageSize
        Net.requestWithTarget(.getTrackSubList(req: params_task), successClosure: { (result, code, message) in
            
            if let arr = Mapper<EquipmentSingModel>().mapArray(JSONObject: JSON.init(parseJSON: result as! String)["tracks"].arrayObject) {
                if self.pageIndex == 1 {
                    self.dataArr.removeAll()
                    self.tableView.mj_footer = self.mj_footer
                }
                self.dataArr += self.flatMapLikeList(arr: arr)
                self.total = JSON.init(parseJSON: result as! String)["totalCount"].int
                self.refreshStatus(status: arr.checkRefreshStatus(self.pageIndex))
                self.scoketModel.sendGetTrack()
                self.tableView.reloadData()
                self.starAnimationWithTableView(tableView: self.tableView)
            }
        })
    }
    
    func mapSongsArrPlayingStatus(songId: Int)  {
        self.dataArr.forEachEnumerated { (index, item) in
//            if let arr = item.resId?.components(separatedBy: ":") {
//                if arr.count > 0 {
                    if let song_Id = item.id {
                        if song_Id == songId {
                            item.isPlay = true
                        }else {
                            item.isPlay = false
                        }
                    }
//                }
//            }
        }
        self.tableView.reloadData()
    }
    func flatMapLikeList(arr: [EquipmentSingModel]) -> [EquipmentSingModel] {
        for item in arr {
            for likeitem in userLikeList {
                //                if let ids = item.resId?.components(separatedBy: ":") {
                //                    if ids.count > 0 {
                if likeitem.trackId == item.id {
                    item.isLike = true
                    continue
                }
                //                    }
                //                }
            }
        }
        return arr
    }
    func starAnimationWithTableView(tableView: UITableView) {
  
        if self.pageIndex == 1 {
            TableViewAnimationKit.show(with: .moveSpring, tableView: tableView)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK: 发送MQTT -- 恢复默认列表， 获取到 改 列表的原始列表 ids
    func sendTopicSetDefault()  {
        
        DeviceManager.isOnline { (isOnline, _)  in
            if isOnline {
                ScoketMQTTManager.share.sendSetDefault(trackListId: self.trackListId)
            } else {
                XBHud.showMsg("当前设备不在线")
            }
        }
//        DeviceManager.isOnline(isCheckDevices: <#T##Bool#>, closure: <#T##(Bool) -> ()#>)
        
    }
    // 获取 预制列表
//    func requestTrackList() {
//        guard XBUserManager.device_Id != "" else {
//            endRefresh()
//            return
//        }
//        Net.requestWithTarget(.getTrackList(deviceId: XBUserManager.device_Id), successClosure: { (result, code, message) in
//            print(result)
//            if let arr = Mapper<EquipmentModel>().mapArray(JSONString: result as! String) {
//                self.endRefresh()
//                self.trackList = arr
//                self.tableView.reloadData()
//            }
//        })
//    }
    // 恢复默认列表
    func requestSetDefault(model: GetTrackListDefault)  {
        guard let trackIds = model.trackIds else {
            return
        }
        Net.requestWithTarget(.setTrackListDefult(trackListId: trackListId, deviceId: XBUserManager.device_Id, trackIds: trackIds), successClosure: { (result, code, message) in
            if let str = result as? String {
                if str == "ok" {
                    XBHud.showMsg("恢复成功")
                    XBDelay.start(delay: 1, closure: {
                         self.request()
                    })
                   
                }
            }
        })
        
    }
}
extension EquipmentSubListVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let m  = dataArr[section]
        return m.isExpanded ? 2 : 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 50
        }
        return XBMin
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else {
            return nil
        }
        let v = TrackListHeaderView.loadFromNib()
        v.btnDefault.addAction {[weak self] in
            guard let `self` = self else { return }
            self.sendTopicSetDefault()
        }
        if let total = self.total {
            v.lbTotal.set_text = "共" + total.toString + "首"
        }else {
            v.lbTotal.set_text = ""
        }
        return v
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistorySongCell", for: indexPath) as! HistorySongCell
            let m  = dataArr[indexPath.section]
            cell.lbTitle.set_text = m.title
            cell.lbTime.set_text = XBUtil.getDetailTimeWithTimestamp(timeStamp: m.duration)
            cell.btnExtension.isSelected = m.isExpanded
            cell.iconType = m.isPlay ? .songList_pause : .songList_play
            cell.btnExtension.addAction {[weak self] in
                guard let `self` = self else { return }
                self.clickExtensionAction(indexPath: indexPath)
            }
            cell.imgIcon.addTapGesture {[weak self] (sender) in
                guard let `self` = self else { return }
                if m.isPlay { // 当前正在播放， 跳转播放器页面
//                    VCRouter.toPlayVC()
                }else {
                    self.requestOnlineSing(trackId: m.id?.toString ?? "")
                }
                
            }
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistorySongContentCell", for: indexPath) as! HistorySongContentCell
            let m  = dataArr[indexPath.section]
            cell.viewAdd.isHidden = true
            cell.viewLike.addTapGesture {[weak self]  (sender) in
                guard let `self` = self else { return }
                if m.isLike {
                    self.requestCancelSong(songId: m.id)
                }else {
//                    self.requestLikeSing(songId: m.trackId, duration: m.length ?? 0, title: m.name ?? "")
                    self.requestLikeSing(songId: m.id, duration: m.duration ?? 0, title: m.title ?? "")
                }
//                self.requestLikeSing(songId: m.id, duration: m.duration ?? 0, title: m.title ?? "")
            }
            cell.viewDel.addTapGesture {[weak self] (sender) in
                guard let `self` = self else { return }
                self.requestDeleteSingWithList(trackId: m.id?.toString ?? "")
            }
            cell.isLike = m.isLike
            return cell
        }

    }
 
    /**
     *   从预制列表中删除
     */
    func requestDeleteSingWithList(trackId: String)  {
        Net.requestWithTarget(.removeSingsList(deviceId: XBUserManager.device_Id, listId: self.trackListId, trackIds: [trackId]), successClosure: { (result, code, message) in
            print(result)
            if let str = result as? String {
                if str == "ok" {
                    XBHud.showMsg("删除成功")
                }else {
                    XBHud.showMsg("删除失败")
                }
            }
        })
    }
    /**
     *   收藏歌曲
     */
    func requestLikeSing(songId: Int?,duration: Int, title: String)  {
        guard let songId = songId else {
            XBHud.showMsg("当前歌曲ID错误")
            return
        }

        viewModel.requestLikeSing(songId: songId, duration: duration, title: title) {
            self.dataArr.forEachEnumerated({ (index, item) in
                if item.id == songId {
                    item.isLike = true
                }
            })
            self.tableView.reloadData()
        }
        
    }
    //MARK: 取消收藏歌曲
    func requestCancelSong(songId: Int?)  {
        guard let songId = songId else {
            XBHud.showMsg("当前歌曲ID错误")
            return
        }
        viewModel.requestCancleLikeSing(trackId: songId) { [weak self] in
            guard let `self` = self else { return }
            self.dataArr.forEachEnumerated({ (index, item) in
                if item.id == songId {
                    item.isLike = false
                }
            })
            self.tableView.reloadData()
        }
    }
    func clickExtensionAction(indexPath: IndexPath)  {
        
        if indexPath.row == 0 {
            let m  = dataArr[indexPath.section]
            m.isExpanded = !m.isExpanded
            tableView.reloadSections([indexPath.section], animationStyle: .automatic)
        }
        if indexPath.row == 1 {
            let m  = dataArr[indexPath.section]
  
        }
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard self.deviceOnline else {
            XBHud.showMsg("当前设备不在线")
            return
        }
        self.requestSingDetail(trackId: dataArr[indexPath.row].id ?? 0)
    }
    
    //MARK: 获取歌曲详情
    func requestSingDetail(trackId: Int)   {
        Net.requestWithTarget(.getSingDetail(trackId: trackId), successClosure: { (result, code, message) in
            guard let result = result as? String else {
                return
            }
            if let model = Mapper<SingDetailModel>().map(JSONString: result) {
                self.sendTopicSingDetail(singModel: model)
            }
        })
    }
    // 发送预制列表点播 MQTT
    func sendTopicSingDetail(singModel: SingDetailModel)  {
        ScoketMQTTManager.share.sendTrackListPlay(trackListId: trackListId, singModel: singModel)
    }
    //MARK: 在线点播
    func requestOnlineSing(trackId: String)  {
        
        viewModel.requestOnlineSing(openId: user_defaults.get(for: .userName)!, trackId: trackId, deviceId: XBUserManager.device_Id) {
            
        }
    }
}


