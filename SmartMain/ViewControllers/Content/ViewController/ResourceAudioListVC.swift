//
//  ContentSingsVC.swift
//  SmartMain
//
//  Created by mac on 2018/9/5.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class ResourceAudioListVC: XBBaseViewController {
    
    var clientId: String! // 当前设备ID
    var albumId: String! // 当前歌曲列表 ID
    var dataArr: [ResourceAudioListModel] = []
    var trackList: [EquipmentModel] = [] // 预制列表 数组
    var headerInfo:ConetentSingAlbumModel?
    
    @IBOutlet weak var btnAddAll: UIButton!
    @IBOutlet weak var lbTopDes: UILabel!
    @IBOutlet weak var lbTopTotal: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgTop: UIImageView!
    
    var topDes: String? = nil
    var topTotal: String? = nil
    var topImg: String? = nil
    
    var viewModel   = ContentViewModel()
    var scoketModel = ScoketMQTTManager.share
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.currentNavigationNone = true
    }
    override func setUI() {
        super.setUI()
        self.configTableView(tableView, register_cell: ["ContentSingCell",
                                                        "HistorySongCell",
                                                        "HistorySongContentCell"])
        self.tableView.mj_header = self.mj_header
        imgTop.addBorder(width: 2.0, color: UIColor.white)
        btnAddAll.addBorder(width: 0.5, color: UIColor.white)
        btnAddAll.setCornerRadius(radius: 10)
        imgTop.setCornerRadius(radius: 8)
        request()
        requestTrackList()
        configCurrentSongsId()
        configTopHeadeaInfo()
        makeCustomerImageNavigationItem("icon_music_white", left: false) { [weak self] in
            guard let `self` = self else { return }
            VCRouter.toPlayVC()
        }
    }
    //MARK: 配置顶部信息
    func configTopHeadeaInfo()  {
        lbTopDes.set_text = topDes
        lbTopTotal.set_text =  "共" + (topTotal ?? "") + "首"
        imgTop.set_Img_Url(topImg)
    }
    func configCurrentSongsId()  {
        scoketModel.getPalyingSingsId.asObservable().subscribe { [weak self] in
            guard let `self` = self else { return }
            print("getPalyingSingsId ===：", $0.element ?? 0)
            
            self.mapSongsArrPlayingStatus(songId: $0.element ?? 0)
            }.disposed(by: rx_disposeBag)
    }
    
    func mapSongsArrPlayingStatus(songId: Int)  {
        self.dataArr.forEachEnumerated { (index, item) in
                if let song_Id = item.id {
                        if song_Id == songId {
                            item.isPlay = true
                        }else {
                            item.isPlay = false
                        }
                }

        }
        self.tableView.reloadData()
    }
    
    override func request() {
        super.request()
        
        var params_task = [String: Any]()
//        params_task["clientId"] = clientId
        params_task["albumId"] = albumId
        params_task["page"] = self.pageIndex
        params_task["size"] = XBPageSize
        params_task["direction"] = "asc"
        params_task["scope"] = "PUBLIC"
        viewModel.requestResourceAudioList(req: params_task).subscribe(onNext: { (audioList) in
            self.endRefresh()
            if self.pageIndex == 1 {
                self.tableView.mj_footer = self.mj_footer
                self.dataArr.removeAll()
            }
            self.dataArr += audioList
            self.refreshStatus(status: audioList.checkRefreshStatus(self.pageIndex))
            self.tableView.reloadData()
        }, onError: { (error) in
            
        }).disposed(by: rx_disposeBag)
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
    
    @IBAction func clickAllAction(_ sender: Any) {
        self.clickSongsToTrackList(isAll: true)
    }
    
    //MARK: 添加列表内全部歌曲 到 预制列表中
    func requestAddSingsTrackList(trackId: Int) {
        var params_task = [String: Any]()
        params_task["deviceId"] = XBUserManager.device_Id
        params_task["id"] = trackId
        params_task["name"] = self.headerInfo?.name ?? ""
        params_task["list"] = self.dataArr.toJSON()
        Net.requestWithTarget(.addSingsToTrack(req: params_task), successClosure: { (result, code, message) in
            if let str = result as? String {
                if str == "ok" {
                    XBHud.showMsg("添加成功")
                    XBDelay.start(delay: 1, closure: {
                        self.requestTrackList()
                    })
                }else {
                    XBHud.showMsg("添加失败")
                }
            }
        })
    }
    /**
     *   增加歌曲到预制列表中 添加单个歌曲
     */
    func requestAddSingWithList(trackId: Int,songModel: ResourceAudioListModel? = nil ,trackName: String)  {
        guard let m = songModel else {
            XBHud.showMsg("所需信息不全")
            return
        }
        let req_model = AddSongTrackReqModel()
   
        req_model.id = songModel?.id

        req_model.title                 = m.name
        req_model.coverSmallUrl         = m.picCover
        req_model.duration              = m.duration
        req_model.albumTitle            = self.topDes
        req_model.albumCoverSmallUrl    = self.topImg
//        req_model.url = m.content
        req_model.downloadSize          = 0
        req_model.downloadUrl           = m.downloadUrl
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
    //MARK: 点击添加全部
    func clickSongsToTrackList(isAll: Bool,songModel: ResourceAudioListModel? = nil)  {
        guard XBUserManager.device_Id != "" else {
            XBHud.showMsg("请先绑定设备")
            return
        }
//        guard self.trackList.count > 0 else {
//            XBHud.showMsg("当前机器无歌单")
//            return
//        }
        let v = PlaySongListView.loadFromNib()
        v.lbTitleDes.set_text = "添加至"
        v.listViewType = .trackList_song
//        v.trackArr = self.trackList
        v.getTrackListIdBlock = {[weak self] (trackId, trackName) in
            guard let `self` = self else { return }
            v.hide()
            if isAll {
                self.requestAddSingsTrackList(trackId: trackId)
            } else {
                self.requestAddSingWithList(trackId: trackId, songModel: songModel, trackName: trackName)
            }
            
        }
        v.show()
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
 
        }
    }
}
extension ResourceAudioListVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let m  = dataArr[section]
        return m.isExpanded ? 2 : 1
    }
    //    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 50
    //    }
    //    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        let v = ContentSingHaderView.loadFromNib()
    //        if let total = headerInfo?.total {
    //            v.lbTotal.set_text = "共" + total.toString + "首"
    //        }else {
    //            v.lbTotal.set_text = ""
    //        }
    //        v.btnAddAll.addAction { [weak self]in
    //            guard let `self` = self else { return }
    //            self.clickAddAllSongsToTrackList()
    //        }
    //        return v
    //    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistorySongCell", for: indexPath) as! HistorySongCell
            let m  = dataArr[indexPath.section]
            cell.lbTitle.set_text = m.name
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
                    VCRouter.toPlayVC()
                }else {
                    self.requestOnlineSing(trackId: m.id?.toString ?? "")
                }
                
            }
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistorySongContentCell", for: indexPath) as! HistorySongContentCell
            
            cell.viewDel.isHidden = true
            let m  = dataArr[indexPath.section]
            cell.viewAdd.addTapGesture {[weak self] (sender) in
                guard let `self` = self else { return }
                self.clickSongsToTrackList(isAll: false,songModel: m)
            }
            
            cell.viewLike.addTapGesture {[weak self]  (sender) in
                guard let `self` = self else { return }
                self.requestLikeSing(songId: m.id, duration: m.duration ?? 0, title: m.name ?? "")

            }
            return cell
        }
        
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentSingCell", for: indexPath) as! ContentSingCell
        //
        //        cell.modelData = dataArr[indexPath.row]
        //        cell.headerInfo = self.headerInfo
        //        cell.lbLineNumber.set_text = (indexPath.row + 1).toString
        //        cell.setArr = ["添加到播单","收藏"]
        //        cell.trackList = self.trackList
        //
        //        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard XBUserManager.device_Id != "" else {
            XBHud.showMsg("请先绑定设备")
            return
        }
        //        self.requestOnlineSing(trackId: dataArr[indexPath.row].resId ?? "")
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
    //MARK: 在线点播歌曲
    func requestOnlineSing(trackId: String)  {
        guard XBUserManager.device_Id != "" else {
            XBHud.showMsg("请先绑定设备")
            return
        }
        
        let arr = trackId.components(separatedBy: ":")
        guard arr.count > 1 else {
            return
        }
        viewModel.requestOnlineSing(openId: XBUserManager.userName, trackId: arr[1], deviceId: XBUserManager.device_Id) {
            VCRouter.toPlayVC()
        }
    }
}
