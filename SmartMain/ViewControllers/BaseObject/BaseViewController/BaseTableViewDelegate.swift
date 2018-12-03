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
    var isPlay: Bool = false// 是否正在播放
    var isLike: Bool = false // 是否喜欢
    var isAudition: Bool = false // 是否在试听
    var isSelect: Bool = false // 是否选中
}
enum SongListType {
    case track // 预制列表
    case like // 收藏列表
    case histroy // 历史列表
    case songs
}
// 0 都未选中 ，1 选择部分 2 全部选中
typealias AllSelectStatus = ((_ status: Int) -> ())
class BaseTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var songListType : SongListType = .track
    var selectStatus: AllSelectStatus?
    var trackList: [EquipmentModel] = [] // 预制列表 数组
    var songsArr: [ConetentSingModel] = []
    var dataArr: [BaseListItem] = [] {
        didSet {
            if let playingSongId = scoketModel.playingSongId {
                self.mapSongsArrPlayingStatus(songId: playingSongId)
            }
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
    open var tableView :UITableView!{
        
        didSet{
            
            self.tableView.cellId_register("BaseListCell")
            self.tableView.estimatedRowHeight = 60
            self.tableView.delegate           = self
            self.tableView.dataSource         = self
            tableView.separatorStyle       = .none
            tableView.keyboardDismissMode  = .onDrag
            tableView.showsVerticalScrollIndicator = false
        }
    }
    override init() {
        super.init()
        scoketModel.getPalyingSingsId.asObservable().subscribe { [weak self] in
            guard let `self` = self else { return }
            print("getPalyingSingsId ===：", $0.element ?? 0)
            self.mapSongsArrPlayingStatus(songId: $0.element ?? 0)
        }.disposed(by: rx_disposeBag)
    }

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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch songListType {
        case .songs:
            if let albumModel = self.albumModel {
                return 220
            }
           return XBMin
        default:
            return XBMin
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch songListType {
        case .songs:
            if let albumModel = self.albumModel {
                let v = ContentSongsHeader.loadFromNib()
//                v.frame = CGRect.init(x: 0, y: 0, w: MGScreenWidth, h: 210)
                self.configTopHeadeaInfo(view: v, model: albumModel)
//                v.btnAddAll.addAction {[weak self] in
//                    guard let `self` = self else { return }
//                    self.clickSongsToTrackList(isAll: true)
//                }
                return v
            }
             return nil
        default:
            return nil
        }

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BaseListCell", for: indexPath) as! BaseListCell
        cell.lbLineNumber.set_text = (indexPath.row + 1).toString
        cell.isEdit = self.isEdit
        let model = dataArr[indexPath.row]
        cell.modelData = model
        cell.indexPathRow = indexPath.row
        
       
        cell.delegate = self
        switch songListType {
        case .track,.songs:
            cell.btnMore.isHidden = false
        case .like:
            cell.btnMore.isHidden = true
        default:
            break
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArr[indexPath.row]
        guard let trackId = model.trackId else {
            XBHud.showMsg("歌曲ID有误")
            return
        }
        switch songListType {
        case .track:
            self.requestSingDetail(trackId: trackId)
        case .like:
            if self.isEdit {
                model.isSelect = !model.isSelect
                mapAllSelect()
                self.tableView.reloadData()
            } else {
                self.requestOnlineSing(trackId: trackId.toString)
            }
            
        default:
            break
        }
        
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
        Net.requestWithTarget(.getSingDetail(trackId: trackId), successClosure: { (result, code, message) in
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
        Net.requestWithTarget(.removeSingsList(deviceId: XBUserManager.device_Id, listId: self.trackListId, trackIds: [trackId]), successClosure: { (result, code, message) in
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
        viewModel.requestLikeSing(songId: trackId, duration: duration, title: title) {
            self.dataArr.forEachEnumerated({ (index, item) in
                if item.trackId == trackId {
                    item.isLike = true
                }
            })
            self.tableView.mj_footer.endRefreshingWithNoMoreData()
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
        Net.requestWithTarget(.addSingsToTrack(req: params_task), successClosure: { (result, code, message) in
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
        let req_model = AddSongTrackReqModel()
        
        req_model.id = m.trackId
        req_model.title = m.name
        req_model.duration = m.length
        req_model.url = m.content
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
            if isAll {
                self.requestAddSingsTrackList(trackId: trackId)
            } else {
                self.requestAddSingWithList(trackId: trackId, songModel: songModel, trackName: trackName)
            }
            
        }
        v.show()
    }
}
extension BaseTableViewDelegate: BaseListCellDelegate {
    func clickItemMoreAction(trackId: Int,duration: Int?, title: String?,indexPathRow: Int) {
        let v = SwitchPlayView.loadFromNib()
        switch songListType {
        case .track:
            v.switchPlayType = .track
        case .songs:
            v.switchPlayType = .songs
        default:
            break
        }

        v.viewSing.addAction { [weak self] in
            guard let `self` = self else { return }
            v.hide()
            self.clickOneAction(trackId: trackId, duration: duration, title: title, indexPathRow: indexPathRow)
            
        }
        v.viewAll.addAction { [weak self] in
            guard let `self` = self else { return }
            v.hide()
            self.clickTwoAction(trackId: trackId,indexPathRow: indexPathRow)
            
        }
        v.viewThree.addAction { [weak self] in
            guard let `self` = self else { return }
            v.hide()
            self.clickThreeAction(trackId: trackId, duration: duration, title: title)
            
        }
        v.show()
    }
    func clickOneAction(trackId: Int,duration: Int?, title: String?,indexPathRow: Int)  {
        switch songListType {
        case .track:
            self.requestLikeSing(trackId: trackId, duration: duration ?? 0, title: title ?? "")
            
        case .songs:
            print("试听")
        default:
            break
        }
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
    func clickThreeAction(trackId: Int,duration: Int?, title: String?)  {
        switch songListType {
        case .songs:
           self.requestLikeSing(trackId: trackId, duration: duration ?? 0, title: title ?? "")
           print("收藏")
        default:
            break
        }
    }
}
