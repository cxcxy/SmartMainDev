//
//  SearchViewController.swift
//  SmartMain
//
//  Created by mac on 2018/9/4.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
class SearchSectionModel: NSObject {
    var sectionType: String = ""
    var sectionArr: [ConetentSingModel] = []
}
class SearchViewController: XBBaseViewController {
    //    var dataArr: [ConetentLikeModel] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var viewSearchTop: UIView!
    
    var trackList: [EquipmentModel] = [] // 预制列表 数组
    
    var headerInfo:ConetentSingAlbumModel?
    var dataArr: [ConetentSingModel] = []
    var viewModel = ContentViewModel()
    
    var resourceArr:[ConetentSingModel]      = []
    var resourceAlbum: [ConetentSingModel]   = []

    let playerLayer:AVPlayerLayer = AVPlayerLayer.init()
    var player:AVPlayer = AVPlayer.init()
    
    var sectionArr: [SearchSectionModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func setUI() {
        super.setUI()
        self.view.backgroundColor = UIColor.white
        self.currentNavigationHidden        = true
        viewSearchTop.setCornerRadius(radius: 10)
        textField.becomeFirstResponder()
        configPlay()
        self.configTableView(tableView, register_cell: ["ContentSingCell",
                                                        "HistorySongCell",
                                                        "HistorySongContentCell"])
        self.textField.delegate = self
        requestTrackList()
    }
    func configPlay()  {
        
        playerLayer.frame = CGRect.init(x: 10, y: 30, w: self.view.bounds.size.width - 20, h: 200)
        // 设置画面缩放模式
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        // 在视图上添加播放器
        self.view.layer.addSublayer(playerLayer)
        
    }
    /// 搜索资源
    override func request()  {
        super.request()
      
        var params_task = [String: Any]()
        params_task["clientId"] = XBUserManager.device_Id
        params_task["keywords"] = [self.textField.text]
        params_task["page"]     = 1
        params_task["ranges"] = ["resource"]
        Net.requestWithTarget(.getSearchResource(req: params_task), successClosure: { (result, code, message) in
            if let arr = Mapper<ConetentSingModel>().mapArray(JSONObject:JSON(result)["resources"].arrayObject) {
                if self.pageIndex == 1 {
                    self.tableView.mj_footer = self.mj_footer
                    self.resourceArr.removeAll()
                }
                self.resourceArr += self.flatMapLikeList(arr: arr)
                
                let sectionItem = SearchSectionModel()
                sectionItem.sectionType = "resource"
                sectionItem.sectionArr =  self.resourceArr
                self.sectionArr.append(sectionItem)
                self.requestResourceAlbum()
//                self.sectionArr += [["resource": self.resourceArr]]
            }
            if let topModel = Mapper<ConetentSingAlbumModel>().map(JSONObject:JSON(result)["resourcesPager"].object) {
                self.headerInfo = topModel
            }
//            self.tableView.reloadData()
        })
    }
    /// 搜索专辑
    func requestResourceAlbum()  {
        var params_album = [String: Any]()
        params_album["clientId"] = XBUserManager.device_Id
        params_album["keywords"] = [self.textField.text]
        params_album["page"]     = 1
        params_album["ranges"] = ["album"]
        Net.requestWithTarget(.getSearchResource(req: params_album), successClosure: { (result, code, message) in
            if let arr = Mapper<ConetentSingModel>().mapArray(JSONObject:JSON(result)["albums"].arrayObject) {
                if self.pageIndex == 1 {
                    self.tableView.mj_footer = self.mj_footer
                    self.resourceAlbum.removeAll()
                }
                self.resourceAlbum = arr

                let sectionItem = SearchSectionModel()
                sectionItem.sectionType = "album"
                sectionItem.sectionArr =  self.resourceAlbum
                self.sectionArr.append(sectionItem)
            }
            if let topModel = Mapper<ConetentSingAlbumModel>().map(JSONObject:JSON(result)["albumsPager"].object) {
                self.headerInfo = topModel
            }
            self.tableView.reloadData()
        })
    }
    func flatMapLikeList(arr: [ConetentSingModel]) -> [ConetentSingModel] {
        for item in arr {
            for likeitem in userLikeList {
                //                if let ids = item.resId?.components(separatedBy: ":") {
                //                    if ids.count > 0 {
                if likeitem.trackId == item.trackId {
                    item.isLike = true
                    continue
                }
                //                    }
                //                }
            }
        }
        return arr
    }
    @IBAction func clickCancelAction(_ sender: Any) {
        self.popVC()
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
        // Dispose of any resources that can be recreated.
    }
    
}
extension SearchViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
//        if resourceArr.count > 0 && resourceAlbum.count > 0 {
//            return 2
//        }
//        if resourceArr.count > 0 || resourceAlbum.count > 0 {
//            return 1
//        }
        return sectionArr.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            let m  = resourceArr[section]
            return m.isExpanded ? 2 : 1
        }
        if section == 1 {
            return self.resourceAlbum.count
        }
       return 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HistorySongCell", for: indexPath) as! HistorySongCell
                let m  = resourceArr[indexPath.section]
                cell.lbTitle.set_text = m.name
                cell.lbTime.set_text = XBUtil.getDetailTimeWithTimestamp(timeStamp: m.length)
                cell.btnExtension.isSelected = m.isExpanded
                cell.btnExtension.addAction {[weak self] in
                    guard let `self` = self else { return }
                    self.clickExtensionAction(indexPath: indexPath)
                }
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HistorySongContentCell", for: indexPath) as! HistorySongContentCell
                cell.viewDel.isHidden = true
                let m  = resourceArr[indexPath.section]
                cell.viewAdd.addTapGesture {[weak self] (sender) in
                    guard let `self` = self else { return }
                    self.clickSongsToTrackList(isAll: false,songModel: m)
                }
                cell.isLike = m.isLike
                cell.viewLike.addTapGesture {[weak self]  (sender) in
                    guard let `self` = self else { return }
                    if m.isLike {
                        self.requestCancelSong(songId: m.trackId)
                    }else {
                        self.requestLikeSing(songId: m.trackId, duration: m.length ?? 0, title: m.name ?? "")
                    }
                }
                
                cell.viewAudition.addTapGesture {[weak self]  (sender) in
                    guard let `self` = self else { return }
                    self.playVoice(model: m)
                    
                }
                cell.lbAudition.set_text = m.isAudition ? "暂停" : "试听"
                cell.viewAudition.isHidden = false
                return cell
            }
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistorySongCell", for: indexPath) as! HistorySongCell
            let m  = resourceAlbum[indexPath.section]
            cell.lbTitle.set_text = m.name
            cell.lbTime.set_text = XBUtil.getDetailTimeWithTimestamp(timeStamp: m.length)
            cell.btnExtension.isSelected = m.isExpanded
            cell.btnExtension.addAction {[weak self] in
                guard let `self` = self else { return }
                self.clickExtensionAction(indexPath: indexPath)
            }
            return cell
        }
       
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = TrackListHeaderView.loadFromNib()
        
//        let m = dataRxArr.value[section]
//
//        switch m.model {
//        case .resource:
//            v.lbTotal.set_text = "相关资源"
//        case .resourceAlbum:
//            v.lbTotal.set_text = "相关专辑"
//        }
        
        v.btnDefault.isHidden = true
        v.viewDefault.isHidden = true
        return v
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard XBUserManager.device_Id != "" else {
            XBHud.showMsg("请先绑定设备")
            return
        }
        self.requestOnlineSing(trackId: dataArr[indexPath.row].resId ?? "")
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
                if item.trackId == songId {
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
                if item.trackId == songId {
                    item.isLike = false
                }
            })
            self.tableView.reloadData()
        }
    }
    //MARK: 点击添加全部
    func clickSongsToTrackList(isAll: Bool,songModel: ConetentSingModel? = nil)  {
        guard XBUserManager.device_Id != "" else {
            XBHud.showMsg("请先绑定设备")
            return
        }
        guard self.trackList.count > 0 else {
            XBHud.showMsg("当前机器无歌单")
            return
        }
        let v = PlaySongListView.loadFromNib()
        v.lbTitleDes.set_text = "添加至"
        v.listViewType = .trackList_song
        v.trackArr = self.trackList
        v.getTrackListIdBlock = {[weak self] (trackId, trackName) in
            guard let `self` = self else { return }
            v.hide()
            
            self.requestAddSingWithList(trackId: trackId, songModel: songModel, trackName: trackName)
            
            
        }
        v.show()
    }
    /**
     *   增加歌曲到预制列表中 添加单个歌曲
     */
    func requestAddSingWithList(trackId: Int,songModel: ConetentSingModel? = nil ,trackName: String)  {
        guard let m = songModel else {
            XBHud.showMsg("所需信息不全")
            return
        }
        let req_model = AddSongTrackReqModel()
        req_model.id = m.trackId
        req_model.title = m.name
        req_model.coverSmallUrl = ""
        req_model.duration = m.length
        req_model.albumTitle = self.headerInfo?.name ?? ""
        req_model.albumCoverSmallUrl = self.headerInfo?.imgSmall ?? ""
        req_model.url = m.content
        req_model.downloadSize = 1
        req_model.downloadUrl = m.content
        Net.requestWithTarget(.addSongToList(deviceId: XBUserManager.device_Id, trackId: trackId, trackName: trackName, trackIds: [req_model]), successClosure: { (result, code, message) in
            print(result)
            if let str = result as? String {
                if str == "ok" {
                    XBHud.showMsg("加入成功")
                }else if str == "duplicate" {
                    XBHud.showMsg("歌单已经存在")
                }
            }
        })
    }
    func clickExtensionAction(indexPath: IndexPath)  {
        if indexPath.row == 0 {
            let m  = dataArr[indexPath.section]
            m.isExpanded = !m.isExpanded
            tableView.reloadSections([indexPath.section], animationStyle: .automatic)
        }
        if indexPath.row == 1 {
            let m  = dataArr[indexPath.section]
            //            self.requestCancleLikeSing(trackId: m.trackId?.toString, section: indexPath.section)
        }
    }
    //MARK: 点击试听
    func playVoice(model: ConetentSingModel)  {
        guard let urlTask =  URL.init(string: model.content ?? "") else {
            XBLog("歌曲地址有误")
            return
        }
        if model.isAudition {
            player.pause()
            
        }else {
            let playerItem:AVPlayerItem = AVPlayerItem.init(url: urlTask)
            self.player = AVPlayer(playerItem: playerItem)
            playerLayer.player = player
            
            // 开始播放
            player.play()
        }
        model.isAudition = !model.isAudition
        dataArr.forEach { (item) in
            if item.trackId != model.trackId {
                item.isAudition = false
            }
        }
        
        self.tableView.reloadData()
        
    }
    //MARK: 在线点播歌曲
    func requestOnlineSing(trackId: String)  {
        let arr = trackId.components(separatedBy: ":")
        guard arr.count > 1 else {
            return
        }
        viewModel.requestOnlineSing(openId: user_defaults.get(for: .userName)!, trackId: arr[1], deviceId: XBUserManager.device_Id) {
            
        }
    }
    /**
     *   取消收藏歌曲
     */
    func requestCancleLikeSing(trackId: String?,section: Int)  {
        
        var params_task = [String: Any]()
        params_task["openId"] = XBUserManager.userName
        params_task["trackId"]  = trackId
        Net.requestWithTarget(.deleteLikeSing(req: params_task), successClosure: { (result, code, message) in
            print(result)
            if let str = result as? String {
                if str == "ok" {
                    XBHud.showMsg("取消收藏成功")
                    self.dataArr.remove(at: section)
                    self.tableView.reloadData()
                }else {
                    XBHud.showMsg("取消收藏失败")
                }
            }
        })
    }
}
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.textField {
            self.request()
        }
        return true
    }
    
}
