//
//  BaseTableViewDelegate.swift
//  SmartMain
//
//  Created by mac on 2018/11/27.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
class BaseListItem: NSObject {
    var title: String!
    var time: Int?
    var trackId: Int?
    var url: String?
    var isPlay: Bool = false// 是否正在播放
    var isLike: Bool = false // 是否喜欢
    var isAudition: Bool = false // 是否在试听
    var isSelect: Bool = false // 是否选中
}
enum SongListType {
    case track // 预制列表
    case trackScrollView // 预制列表
    case like // 收藏列表
    case histroy // 历史列表

    case songs
}
// 0 都未选中 ，1 选择部分 2 全部选中
typealias AllSelectStatus = ((_ status: Int) -> ())
class BaseTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
//    var viewContainer: UIView?
    var songListType : SongListType = .track
    var selectStatus: AllSelectStatus?
    var trackList: [EquipmentModel] = [] // 预制列表 数组
    var songsArr: [ConetentSingModel] = []
    var dataArr: [BaseListItem] = [] {
        didSet {
            if let playingSongId = scoketModel.playingSongId {
                self.mapSongsArrPlayingStatus(songId: playingSongId)
            }
             _ = self.flatMapLikeList(arr: dataArr)
        }
    }
    var albumModel: ConetentSingAlbumModel? {
        didSet {
            self.tableView.reloadData()
        }
    }
    var isEdit: Bool = false {
        didSet {
            self.tableView.reloadData()
        }
    }
    var isAllSelect: Bool = false {
        didSet {
            self.dataArr.forEach { (item) in
                item.isSelect = isAllSelect
            }
            self.tableView.reloadData()
        }
    }
    var trackListId: Int! // 预制列表id
    var viewModel = ContentViewModel()
    var scoketModel = ScoketMQTTManager.share
    
    let playerLayer:AVPlayerLayer = AVPlayerLayer.init()
    var player:AVPlayer = AVPlayer.init()
    weak var viewContainer: UIView? {
        didSet {
            if let viewContainer = viewContainer {
                self.configPlay(viewContainer: viewContainer)
            }
        }
    }
    weak var current_vc: UIViewController?

    open var tableView :UITableView!{
        
        didSet{
            
            self.tableView.cellId_register("BaseListCell")
             self.tableView.cellId_register("ContentSongsTopCell")
            self.tableView.estimatedRowHeight = 60
            self.tableView.delegate           = self
            self.tableView.dataSource         = self
            tableView.emptyDataSetDelegate = self
            tableView.emptyDataSetSource   = self
            tableView.separatorStyle       = .none
            tableView.keyboardDismissMode  = .onDrag
            tableView.showsVerticalScrollIndicator = false
        }
    }
    override init() {
        super.init()
        if let currentSongModel = currentDeviceSongModel {
//            self.currentSongModel = currentSongModel
//            self.configUI(singsDetail: currentSongModel)
            self.mapSongsArrPlayingStatus(songId: currentSongModel.trackId ?? 0)
        }
        scoketModel.getPalyingSingsModel.asObservable().subscribe { [weak self] in
            guard let `self` = self else { return }
            guard let model = $0.element else { return }
            //            print("getPalyingSingsId ===：", $0.element ?? 0)
            self.mapSongsArrPlayingStatus(songId: model.trackId ?? 0)
            //            self.mapSongsArrPlayingStatus(songId: $0.element ?? 0)
        }.disposed(by: rx_disposeBag)
    }
    func configPlay(viewContainer: UIView)  {
        
        playerLayer.frame = CGRect.init(x: 10, y: 30, w: MGScreenWidth, h: 200)
        // 设置画面缩放模式
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        // 在视图上添加播放器
        viewContainer.layer.addSublayer(playerLayer)
        
    }
//    //MARK: 点击试听
//    func playVoice(model: BaseListItem)  {
//        guard let urlTask =  URL.init(string: model.url ?? "") else {
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

    // 歌曲的播放状态
    func mapSongsArrPlayingStatus(songId: Int)  {
        guard self.dataArr.count > 0 else {
            return
        }
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
    // 歌曲的收藏状态
    func flatMapLikeList(arr: [BaseListItem]) -> [BaseListItem] {
        for item in arr {
            for likeitem in userLikeList {
                if likeitem.trackId == item.trackId {
                    item.isLike = true
                    continue
                }
            }
        }
        return arr
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch songListType {
        case .songs:
            return dataArr.count + 1
        default:
            return dataArr.count
        }
        
    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        switch songListType {
//        case .songs:
//            if let albumModel = self.albumModel {
//                return 220
//            }
//           return XBMin
//        default:
//            return XBMin
//        }
//
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        switch songListType {
//        case .songs:
//            if let albumModel = self.albumModel {
//                let v = ContentSongsHeader.loadFromNib()
//                v.frame = CGRect.init(x: 0, y: 0, w: MGScreenWidth, h: 210)
////                self.configTopHeadeaInfo(view: v, model: albumModel)
//                 v.lbTopDes.set_text = "12312312312312312312312312312321312312312312312"
////                v.btnAddAll.addAction {[weak self] in
////                    guard let `self` = self else { return }
////                    self.clickSongsToTrackList(isAll: true)
////                }
//                v.layoutIfNeeded()
//                return v
//            }
//             return nil
//        default:
//            return nil
//        }
//
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
        switch songListType {
        case .songs:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ContentSongsTopCell", for: indexPath) as! ContentSongsTopCell
                if let model = self.albumModel {
                    cell.lbTopDes.set_text = model.name
                    let totalStr = model.total?.toString ?? ""
                    cell.lbTopTotal.set_text =  "共" + totalStr + "首"
                    cell.imgTop.set_Img_Url(model.imgLarge)
                    cell.imgBackground.set_Img_Url(model.imgLarge)
                    cell.btnAddAll.addAction {[weak self] in
                        guard let `self` = self else { return }
                        self.clickSongsToTrackList(isAll: true)
                    }
                }
                return cell
            }else {
                return self.getListCell(tableView, cellForRowAt: indexPath, indexPathRow: indexPath.row - 1)
            }
        default:
            break
        }
        return self.getListCell(tableView, cellForRowAt: indexPath, indexPathRow: indexPath.row)
    }
    func getListCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath,indexPathRow: Int) -> BaseListCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BaseListCell", for: indexPath) as! BaseListCell
        cell.lbLineNumber.set_text = (indexPathRow + 1).toString
        cell.isEdit = self.isEdit
        let model = dataArr[indexPathRow]
        cell.modelData = model
        cell.indexPathRow = indexPathRow
        cell.delegate = self
        switch songListType {
        case .track,.songs:
            cell.btnMore.isHidden = false
        case .like,.trackScrollView:
            cell.btnMore.isHidden = true
        default:
            break
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var model:BaseListItem!
        switch songListType {
        case .songs:
            if indexPath.row == 0 {
                return
            }
            model = dataArr[indexPath.row - 1]
        default:
            model = dataArr[indexPath.row]
        }
        guard let trackId = model.trackId else {
            XBHud.showMsg("歌曲ID有误")
            return
        }
        switch songListType {
        case .track,.trackScrollView:
            self.requestPlayTrackList(trackId: trackId)
        case .like:
            if self.isEdit {
                model.isSelect = !model.isSelect
                mapAllSelect()
                self.tableView.reloadData()
            } else {
                self.requestOnlineSing(trackId: trackId.toString)
            }
            
        default:
            self.requestOnlineSing(trackId: trackId.toString)
            break
        }
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.current_vc != nil {
            //导航栏显示状态
            let a = scrollView.contentOffset.y
            self.topNavigationAnimate(a)
        }


    }
    func topNavigationAnimate(_ offsetY : CGFloat)  {
        let f = (offsetY/90.0) >= 0 ? (offsetY/90.0) : 0
        let l = f > 1.0 ? 1:f
        
        let w = UIColor.init(hexString: "7ECC3B", alpha: l)
        current_vc?.navigationController?.navigationBar.setBackgroundImage(UIImage.getImageWithColor(color: w!), for: UIBarMetrics.default)
        
    }
    func mapAllSelect()  {
        let arr = self.dataArr.filter { (item) -> Bool in
            return item.isSelect
        }
        if arr.count == 0 {
            print("全部未选择")
            if let selectStatus = self.selectStatus {
                selectStatus(0)
            }
        } else if arr.count == self.dataArr.count {
            print("全部选择")
            if let selectStatus = self.selectStatus {
                selectStatus(2)
            }
        } else {
            print("部分选择")
            if let selectStatus = self.selectStatus {
                selectStatus(1)
            }
        }
    }
}
extension BaseTableViewDelegate {
    //MARK: 配置顶部信息
    func configTopHeadeaInfo(view:ContentSongsHeader, model: ConetentSingAlbumModel!)  {
        view.lbTopDes.set_text = model.name
        let totalStr = model.total?.toString ?? ""
        view.lbTopTotal.set_text =  "共" + totalStr + "首"
        view.imgTop.set_Img_Url(model.imgLarge)
        view.imgBackground.set_Img_Url(model.imgLarge)
    }
    //MARK: 获取歌曲详情
    func requestSingDetail(trackId: Int)   {
        Net.requestWithTarget(.getSingDetail(trackId: trackId),isEndRrefreshing: false, successClosure: { (result, code, message) in
            guard let result = result as? String else {
                return
            }
            if let model = Mapper<SingDetailModel>().map(JSONString: result) {
                self.sendTopicSingDetail(singModel: model)
            }
        })
    }
    // 发送预制列表点播歌曲 MQTT
    func sendTopicSingDetail(singModel: SingDetailModel)  {
        ScoketMQTTManager.share.sendTrackListPlay(trackListId: self.trackListId, singModel: singModel)
    }
    /**
     *   删除 dataArr 中的歌曲
     */
    func deleteDataArr(trackId: Int) {
        for item in self.dataArr.enumerated() {
            if item.element.trackId == trackId {
                self.dataArr.remove(at: item.offset)
                break
            }
        }
        self.tableView.reloadData()
    }
    /**
     *   从预制列表中删除
     */
    func requestDeleteSingWithList(trackId: String)  {
        Net.requestWithTarget(.removeSingsList(deviceId: XBUserManager.device_Id, listId: self.trackListId, trackIds: [trackId]),isEndRrefreshing: false, successClosure: { (result, code, message) in
            if let str = result as? String {
                if str == "ok" {
                    XBHud.showMsg("删除成功")
                    if let trackId = trackId.toInt() {
                        self.deleteDataArr(trackId: trackId)
                    }
                }else {
                    XBHud.showMsg("删除失败")
                }
            }
        })
    }
    //MARK: 在线点播歌曲
    func requestOnlineSing(trackId: String)  {
        
        viewModel.requestOnlineSing(openId: user_defaults.get(for: .userName)!, trackId: trackId, deviceId: XBUserManager.device_Id) {
            
        }
    }
    /**
     *   收藏歌曲
     */
    func requestLikeSing(trackId: Int?,duration: Int, title: String)  {
        guard let trackId = trackId else {
            XBHud.showMsg("当前歌曲ID错误")
            return
        }
        viewModel.requestLikeSing(songId: trackId, duration: duration, title: title) { [weak self] in
            guard let `self` = self else { return }
            self.dataArr.forEachEnumerated({ (index, item) in
                if item.trackId == trackId {
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
    //MARK: 添加列表内全部歌曲 到 预制列表中
    func requestAddSingsTrackList(trackId: Int) {
        var params_task = [String: Any]()
        params_task["deviceId"] = XBUserManager.device_Id
        params_task["id"] = trackId
        params_task["name"] = self.albumModel?.name ?? ""
        params_task["list"] = self.songsArr.toJSON()
        Net.requestWithTarget(.addSingsToTrack(req: params_task),isEndRrefreshing: false, successClosure: { (result, code, message) in
            if let str = result as? String {
                if str == "ok" {
                    XBHud.showMsg("添加成功")
                    XBDelay.start(delay: 1, closure: {
//                        self.requestTrackList()
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
//        let req_model = AddSongTrackReqModel()
//
//        req_model.id = m.trackId
//        req_model.title = m.name
//        req_model.duration = m.length
//        req_model.url = m.content
//        req_model.downloadUrl = m.content
        
        let req_model = AddSongTrackReqModel()
        req_model.id = m.trackId
        req_model.title = m.name
        req_model.coverSmallUrl = self.albumModel?.imgSmall ?? ""
        req_model.duration = m.length
        req_model.albumTitle = self.albumModel?.name ?? ""
        req_model.albumCoverSmallUrl = self.albumModel?.imgSmall ?? ""
        req_model.url = m.content
        req_model.downloadSize = 1
        req_model.downloadUrl = m.content
        
        
        Net.requestWithTarget(.addSongToList(deviceId: XBUserManager.device_Id, trackId: trackId, trackName: trackName, trackIds: [req_model]),isEndRrefreshing: false, successClosure: { (result, code, message) in
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
//        requestPlayTrackList(trackId: <#T##Int#>)
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
    func requestPlayTrackList(trackId: Int) {
        var params_task = [String: Any]()
        params_task["openId"] = XBUserManager.userName
        params_task["deviceId"] = XBUserManager.device_Id
        params_task["trackListId"] = trackListId
        params_task["trackId"] = trackId
        Net.requestWithTarget(.trackPlaySing(req: params_task), successClosure: { (result, code, message) in
            print(result)
//            result as? NSNumber
             if let str = result as? String {
                if str == "0" {
                    XBHud.showMsg("播放成功")
                }
                if str == "2" {
                    XBHud.showMsg("该openId没有和该deviceId绑定")
                }
                if str == "1" {
                    XBHud.showMsg("设备不在线")
                }
            }
        })
    }
}
extension BaseTableViewDelegate: BaseListCellDelegate {
    func clickPauseAction(indexPathRow: Int) {
        self.playVoice(model: self.dataArr[indexPathRow])
    }
    func clickItemMoreAction(trackId: Int,duration: Int?, title: String?,isLike: Bool, indexPathRow: Int) {
        let v = SwitchPlayView.loadFromNib()
        switch songListType {
        case .track:
            v.switchPlayType = .track
            if isLike {
                v.lbOne.set_text = "取消收藏"
            }else {
                v.lbOne.set_text = "收藏"
            }
        case .songs:
            v.switchPlayType = .songs
            if isLike {
                v.lbThree.set_text = "取消收藏"
            }else {
                v.lbThree.set_text = "收藏"
            }
        default:
            break
        }

        v.viewSing.addAction { [weak self] in
            guard let `self` = self else { return }
            v.hide()
            self.clickOneAction(trackId: trackId, duration: duration, title: title, isLike: isLike, indexPathRow: indexPathRow)
            
        }
        v.viewAll.addAction { [weak self] in
            guard let `self` = self else { return }
            v.hide()
            self.clickTwoAction(trackId: trackId,indexPathRow: indexPathRow)
            
        }
        v.viewThree.addAction { [weak self] in
            guard let `self` = self else { return }
            v.hide()
            self.clickThreeAction(trackId: trackId, duration: duration, title: title,isLike: isLike)
            
        }
        v.show()
    }
    func clickOneAction(trackId: Int,duration: Int?, title: String?,isLike: Bool,indexPathRow: Int)  {
        switch songListType {
        case .track:
//            self.requestLikeSing(trackId: trackId, duration: duration ?? 0, title: title ?? "")
            if isLike {
                print("取消收藏")
                self.requestCancelSong(songId: trackId)
            }else {
                print("收藏")
                self.requestLikeSing(trackId: trackId, duration: duration ?? 0, title: title ?? "")
            }
        case .songs:
            print("试听")
            self.playVoice(model: dataArr[indexPathRow])
        default:
            break
        }
    }
    func configPlay()  {
        if let viewContainer = self.viewContainer {
            playerLayer.frame = CGRect.init(x: 10, y: 30, w: XBMin, h: XBMin)
            // 设置画面缩放模式
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
            // 在视图上添加播放器
            viewContainer.layer.addSublayer(playerLayer)
        }
    }
    //MARK: 点击试听
    func playVoice(model: BaseListItem)  {
        guard let urlTask =  URL.init(string: model.url ?? "") else {
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

    func clickTwoAction(trackId: Int,indexPathRow: Int)  {
        switch songListType {
        case .track:
            self.requestDeleteSingWithList(trackId: trackId.toString)
        case .songs:
            
            self.clickSongsToTrackList(isAll: false, songModel: self.songsArr[indexPathRow])
            print("添加到播单")
        default:
            break
        }
    }
    func clickThreeAction(trackId: Int,duration: Int?, title: String?,isLike: Bool)  {
        switch songListType {
        case .songs:
            if isLike {
                print("取消收藏")
                self.requestCancelSong(songId: trackId)
            }else {
                print("收藏")
                self.requestLikeSing(trackId: trackId, duration: duration ?? 0, title: title ?? "")
            }
           
           
        default:
            break
        }
    }
}
// 空白展位图
extension BaseTableViewDelegate:DZNEmptyDataSetDelegate,DZNEmptyDataSetSource{
    @objc(titleForEmptyDataSet:) func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if  !NetWorkType.getNetWorkType() { // 无网络状态  或者 出现超时错误
            return NSAttributedString()
        }
        if XBUserManager.device_Id == "" && songListType != .like {
            //MARK: tableView 无数据展示状态
            let XBNoDataTitle:NSAttributedString = NSAttributedString(string: "暂无绑定设备",
                                                                      attributes:[NSAttributedStringKey.foregroundColor:MGRgb(0, g: 0, b: 0, alpha: 0.5),
                                                                                  NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14)])
            return XBNoDataTitle
        }
        //MARK: tableView 无数据展示状态
        let XBNoDataTitle:NSAttributedString    =   NSAttributedString(string: "暂无数据",
                                                                       attributes:[NSAttributedStringKey.foregroundColor:MGRgb(0, g: 0, b: 0, alpha: 0.5),
                                                                                   NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14)])
        return XBNoDataTitle
    }
    @objc(backgroundColorForEmptyDataSet:) func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return tableColor
    }
    @objc(imageForEmptyDataSet:) func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage? {
        if  !NetWorkType.getNetWorkType() { // 无网络状态  或者 出现超时错误
            return UIImage.init(named: "network_error")
        }
        return nil
    }
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        
        if  !NetWorkType.getNetWorkType(){ // 无网络状态  或者 出现超时错误
            let text = "网络不给力，请点击重试哦~"
            let attStr = NSMutableAttributedString(string: text)
            attStr.addAttribute(.font, value: UIFont.systemFont(ofSize: 15.0), range: NSRange(location: 0, length: text.count))
            attStr.addAttribute(.foregroundColor, value: UIColor.lightGray, range: NSRange(location: 0, length: text.count))
            attStr.addAttribute(.foregroundColor, value: viewColor, range: NSRange(location: 7, length: 4))
            return attStr
        }
        return NSAttributedString.init()
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        print("点击了网络不给力")
        //        if  !NetWorkType.getNetWorkType() || loadingTimerOut { // 无网络状态  或者 出现超时错误

        //        }
        
        if let current_vc = self.current_vc as? XBBaseViewController{
            current_vc.request()
        }
        
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}
