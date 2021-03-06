//
//  ContentSingsVC.swift
//  SmartMain
//
//  Created by mac on 2018/9/5.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class SearchSongsViewController: XBBaseViewController {
    var clientId: String! // 当前设备ID
    var albumId: String! // 当前歌曲列表 ID
    
    var dataArrFromSearch : [ConetentSingModel] = [] { // 从搜索传进来
        didSet {
            self.tableView.mj_footer = self.mj_footer
            self.dataArr.removeAll()
            self.dataArr = self.dataArrFromSearch
            self.refreshStatus(status: dataArrFromSearch.checkRefreshStatus(self.pageIndex,paseSize: 20))
        }
    }
    var dataDelegate: BaseTableViewDelegate = BaseTableViewDelegate()
    var dataArr: [ConetentSingModel] = [] {
        didSet {
            self.configDelegateArr()
        }
    }
    var trackList: [EquipmentModel] = [] // 预制列表 数组
    var headerInfo:ConetentSingAlbumModel? {
        didSet {
            guard let m = headerInfo else {
                return
            }
            self.setTopViewInfo(total: m.total?.toString ?? "")
        }
    }
    
    @IBOutlet weak var headerView: UIView!
    var viewModel   = ContentViewModel()
    var scoketModel = ScoketMQTTManager.share
    var likeList: [ConetentLikeModel] = []
    @IBOutlet weak var tableView: UITableView!
    var searchKey: String = ""
    
    let playerLayer:AVPlayerLayer = AVPlayerLayer.init()
    var player:AVPlayer = AVPlayer.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentNavigationHidden        = true
    }
    override func setUI() {
        super.setUI()
        title = "更多歌曲"
//        self.configTableView(tableView, register_cell: ["ContentSingCell",
//                                                        "HistorySongCell",
//                                                        "HistorySongContentCell"])
        self.tableView.mj_header = self.mj_header

        self.tableView.mj_footer = self.mj_footer
        configCurrentSongsId()
        configPlay()
        makeCustomerImageNavigationItem("icon_music_white", left: false) { [weak self] in
            guard let `self` = self else { return }
            VCRouter.toPlayVC()
        }
        configTopHeaderView()
        dataDelegate.tableView = self.tableView
        dataDelegate.songListType = .like
        dataDelegate.current_vc = self
    }
    /// 配置tableView里面的数据源
    func configDelegateArr()  {
        self.dataDelegate.dataArr = self.dataArr.map({ (item) -> BaseListItem in
            let listItem = BaseListItem()
            listItem.title = item.name ?? ""
            listItem.time = item.length
            listItem.trackId = item.trackId ?? 0
            return listItem
        })
        self.tableView.reloadData()
//        self.lbTotal.set_text = "共" + self.dataDelegate.dataArr.count.toString + "首"
//        topView.lbTotal.set_text = "共" + self.dataDelegate.dataArr.count.toString + "条结果"
    }
    func configDataArr() {
        self.dataArr += self.flatMapLikeList(arr: self.dataArr)
    }
    lazy var topView: TrackListHeaderView = {
        let v = TrackListHeaderView.loadFromNib()
        v.frame = CGRect.init(x: 0, y: 0, w: MGScreenWidth
            , h: 42)
        v.viewBack.backgroundColor = UIColor.white
        v.lbTotal.textColor = UIColor.black
        v.viewDefault.isHidden = true
//        v.btnDefault.set_Title("添加全部")
//        v.btnDefault.addAction {
//            self.clickAllAction()
//        }
        v.addBorderBottom(size: 0.5, color: lineColor)
        return v
    }()
    func configTopHeaderView()  {
        self.headerView.addSubview(topView)
    }
    func setTopViewInfo(total: String)  {
        topView.lbTotal.set_text = "共" + total + "条结果"
    }
    func configCurrentSongsId()  {
        scoketModel.getPalyingSingsModel.asObservable().subscribe { [weak self] in
            guard let `self` = self else { return }
            guard let model = $0.element else { return }
            //            print("getPalyingSingsId ===：", $0.element ?? 0)
            self.mapSongsArrPlayingStatus(songId: model.trackId ?? 0)
            //            self.mapSongsArrPlayingStatus(songId: $0.element ?? 0)
        }.disposed(by: rx_disposeBag)
    }

    func mapSongsArrPlayingStatus(songId: Int)  {
        self.dataArr.forEachEnumerated { (index, item) in
            if let song_Id = item.trackId {
                if song_Id == songId {
                    item.isPlay = true
                }else {
                    item.isPlay = false
                }
            }
        }
        self.tableView.reloadData()
    }
    func configPlay()  {
        
        playerLayer.frame = CGRect.init(x: 10, y: 30, w: self.view.bounds.size.width - 20, h: 200)
        // 设置画面缩放模式
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        // 在视图上添加播放器
        self.view.layer.addSublayer(playerLayer)
        
    }
    override func request() {
        super.request()
        var params_task = [String: Any]()
        params_task["clientId"] = XBUserManager.device_Id
        params_task["keywords"] = [searchKey]
        params_task["page"]     = self.pageIndex
        params_task["ranges"] = ["resource"]
        Net.requestWithTarget(.getSearchResource(req: params_task), successClosure: { (result, code, message) in
            self.endRefresh()
            if let arr = Mapper<ConetentSingModel>().mapArray(JSONObject:JSON(result)["resources"].arrayObject) {
                if self.pageIndex == 1 {
                    self.tableView.mj_footer = self.mj_footer
                    self.dataArr.removeAll()
                }
                
                self.dataArr += self.flatMapLikeList(arr: arr)
                self.refreshStatus(status: arr.checkRefreshStatus(self.pageIndex,paseSize: 20))
            }
            if let topModel = Mapper<ConetentSingAlbumModel>().map(JSONObject:JSON(result)["resourcesPager"].object) {
//                self.setTopViewInfo(total: topModel.total?.toString ?? "")
                self.headerInfo  = topModel
            }
//            self.scoketModel.sendGetTrack()
            self.tableView.reloadData()
//            self.starAnimationWithTableView(tableView: self.tableView)
        })
     
    }
    func starAnimationWithTableView(tableView: UITableView) {
        //        table
        if self.pageIndex == 1 {
            TableViewAnimationKit.show(with: .moveSpring, tableView: tableView)
        }
        
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
    
    //MARK: 请求预制列表数据
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
    
    func clickAllAction() {
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
    //MARK: 点击添加全部
    func clickSongsToTrackList(isAll: Bool,songModel: ConetentSingModel? = nil)  {
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
}
//extension SearchSongsViewController {
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return dataArr.count
//    }
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let m  = dataArr[section]
//        return m.isExpanded ? 2 : 1
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "HistorySongCell", for: indexPath) as! HistorySongCell
//            let m  = dataArr[indexPath.section]
//            cell.lbTitle.set_text = m.name
//            cell.lbTime.set_text = XBUtil.getDetailTimeWithTimestamp(timeStamp: m.length)
//            cell.btnExtension.isSelected = m.isExpanded
//            cell.iconType = m.isPlay ? .songList_pause : .songList_play
//            cell.btnExtension.addAction {[weak self] in
//                guard let `self` = self else { return }
//                self.clickExtensionAction(indexPath: indexPath)
//            }
//            cell.imgIcon.addTapGesture {[weak self] (sender) in
//                guard let `self` = self else { return }
//                if m.isPlay { // 当前正在播放， 跳转播放器页面
//                    VCRouter.toPlayVC()
//                }else {
//                    self.requestOnlineSing(trackId: m.resId ?? "")
//                }
//
//            }
//            return cell
//        }else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "HistorySongContentCell", for: indexPath) as! HistorySongContentCell
//
//            cell.viewDel.isHidden = true
//            let m  = dataArr[indexPath.section]
//            cell.viewAdd.addTapGesture {[weak self] (sender) in
//                guard let `self` = self else { return }
//                self.clickSongsToTrackList(isAll: false,songModel: m)
//            }
//            cell.isLike = m.isLike
//            cell.viewLike.addTapGesture {[weak self]  (sender) in
//                guard let `self` = self else { return }
//                if m.isLike {
//                    self.requestCancelSong(songId: m.trackId)
//                }else {
//                    self.requestLikeSing(songId: m.trackId, duration: m.length ?? 0, title: m.name ?? "")
//                }
//
//            }
//
//            cell.viewAudition.addTapGesture {[weak self]  (sender) in
//                guard let `self` = self else { return }
//                self.playVoice(model: m)
//
//            }
//            cell.lbAudition.set_text = m.isAudition ? "暂停" : "试听"
//            cell.viewAudition.isHidden = false
//            return cell
//        }
//    }
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard XBUserManager.device_Id != "" else {
//            XBHud.showMsg("请先绑定设备")
//            return
//        }
//        //        self.requestOnlineSing(trackId: dataArr[indexPath.row].resId ?? "")
//    }
//    func clickExtensionAction(indexPath: IndexPath)  {
//        if indexPath.row == 0 {
//            let m  = dataArr[indexPath.section]
//            m.isExpanded = !m.isExpanded
//            tableView.reloadSections([indexPath.section], animationStyle: .automatic)
//        }
//        if indexPath.row == 1 {
//            let m  = dataArr[indexPath.section]
//            //            self.requestCancleLikeSing(trackId: m.trackId?.toString, section: indexPath.section)
//
//        }
//    }
//
//    //MARK: 点击试听
//    func playVoice(model: ConetentSingModel)  {
//        guard let urlTask =  URL.init(string: model.content ?? "") else {
//            XBLog("歌曲地址有误")
//            return
//        }
//        if model.isAudition {
//            player.pause()
//
//        }else {
//            let playerItem:AVPlayerItem = AVPlayerItem.init(url: urlTask)
//            self.player = AVPlayer(playerItem: playerItem)
//            playerLayer.player = player
//
//            // 开始播放
//            player.play()
//        }
//        model.isAudition = !model.isAudition
//        dataArr.forEach { (item) in
//            if item.trackId != model.trackId {
//                item.isAudition = false
//            }
//        }
//
//        self.tableView.reloadData()
//
//    }
//    //MARK: 在线点播歌曲
//    func requestOnlineSing(trackId: String)  {
//        guard XBUserManager.device_Id != "" else {
//            XBHud.showMsg("请先绑定设备")
//            return
//        }
//
//        let arr = trackId.components(separatedBy: ":")
//        guard arr.count > 1 else {
//            return
//        }
//        viewModel.requestOnlineSing(openId: XBUserManager.userName, trackId: arr[1], deviceId: XBUserManager.device_Id) {
//            VCRouter.toPlayVC()
//        }
//    }
//}
