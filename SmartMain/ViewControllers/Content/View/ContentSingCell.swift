//
//  ContentSingCell.swift
//  SmartMain
//
//  Created by mac on 2018/9/5.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
import ObjectMapper
class ContentSingCell: BaseTableViewCell {

    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbLineNumber: UILabel!
    
    var trackId: String?
    var duration: String?
    var title: String?
    var listId: Int? // 预制列表二级列表 列表ID
    var headerInfo:ConetentSingAlbumModel?
    
    var setArr: [String] = []
    
    var trackList: [EquipmentModel] = [] // 预制列表数据model

    var singModelData: EquipmentSingModel? { // 预制列表菜单Model
        didSet {
            guard let m = singModelData else {
                return
            }
            self.lbTitle.set_text = m.title
            self.lbTime.set_text = XBUtil.getDetailTimeWithTimestamp(timeStamp: m.duration)
            self.trackId = m.id?.toString
            self.duration = m.duration?.toString
            self.title = m.title
        }
    }
    var modelData: ConetentSingModel? { // 三级页面Model
        didSet {
            guard let m = modelData else {
                return
            }
            self.lbTitle.set_text = m.name
            self.lbTime.set_text = XBUtil.getDetailTimeWithTimestamp(timeStamp: m.length)
            if let arr = m.resId?.components(separatedBy: ":") {
                if arr.count > 0 {
                    self.trackId = arr[1]
                }
            }
            self.duration = m.length?.toString
            self.title = m.name
        }
    }
    var likeModelData: ConetentLikeModel? { // 收藏页面Model
        didSet {
            guard let m = likeModelData else {
                return
            }
            self.lbTitle.set_text = m.title
            self.lbTime.set_text = XBUtil.getDetailTimeWithTimestamp(timeStamp: m.duration)
            self.trackId = m.trackId?.toString
            self.duration = m.duration?.toString
            self.title = m.title
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func clickMnumAction(_ sender: Any) {
//        let v = ShowChooseView.loadFromNib()
//        v.btnLike.addAction {[weak self] in
//            guard let `self` = self else { return }
//            self.requestLikeSing()
//        }
//        v.btnCancleLike.addAction {[weak self] in
//            guard let `self` = self else { return }
//            self.requestCancleLikeSing()
//        }
//        v.btnDeleteDemand.addAction {[weak self] in
//            guard let `self` = self else { return }
//            self.requestDeleteDemand()
//        }
//        v.btnDelTrackList.addAction {[weak self] in
//            guard let `self` = self else { return }
//            self.requestDeleteSingWithList()
//        }
//        v.btnAddTrackList.addAction {[weak self] in
//            guard let `self` = self else { return }
//            self.requestAddSingWithList()
//        }
//        v.show()
        
//        let v = PlaySongListView.loadFromNib()
//        v.trackListId = 3709
//        v.show()
        
        
        guard setArr.count > 0 else {
            return
        }
        VCRouter.prentSheetAction(dataArr: setArr) { (index) in
            if index == 0 {
                self.showTrackListAction()
            }
            if index == 1 {
                self.requestLikeSing()
            }
        }
    }
    func showTrackListAction()  {
        guard XBUserManager.device_Id != "" else {
            XBHud.showMsg("请先绑定设备")
            return
        }
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
    /**
     *   从预制列表中删除
     */
    func requestDeleteSingWithList()  {
        Net.requestWithTarget(.removeSingsList(deviceId: XBUserManager.device_Id, listId: listId!, trackIds: [trackId!]), successClosure: { (result, code, message) in
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
    func requestLikeSing()  {
        
        var params_task = [String: Any]()
        params_task["openId"] = XBUserManager.userName
        params_task["trackId"]  = trackId
        params_task["duration"] = duration
        params_task["title"]    = title
        Net.requestWithTarget(.saveLikeSing(req: params_task), successClosure: { (result, code, message) in
            print(result)
            if let str = result as? String {
                if str == "ok" {
                    XBHud.showMsg("收藏成功")
                }else {
                    XBHud.showMsg("收藏失败")
                }
            }
        })

    }
    /**
     *   取消收藏歌曲
     */
    func requestCancleLikeSing()  {
        
        var params_task = [String: Any]()
        params_task["openId"] = XBUserManager.userName
        params_task["trackId"]  = trackId
        Net.requestWithTarget(.deleteLikeSing(req: params_task), successClosure: { (result, code, message) in
            print(result)
            if let str = result as? String {
                if str == "ok" {
                    XBHud.showMsg("取消收藏成功")
                }else {
                    XBHud.showMsg("取消收藏失败")
                }
            }
        })
        
    }
    /**
     *   删除点播历史
     */
    func requestDeleteDemand()  {
        
        var params_task = [String: Any]()
        params_task["deviceId"] = XBUserManager.device_Id
        params_task["trackId"]  = trackId
        Net.requestWithTarget(.deleteDemand(req: params_task), successClosure: { (result, code, message) in
            print(result)
            if let str = result as? String {
                if str == "ok" {
                    XBHud.showMsg("删除点播成功")
                }else {
                    XBHud.showMsg("删除点播失败")
                }
            }
        })
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
