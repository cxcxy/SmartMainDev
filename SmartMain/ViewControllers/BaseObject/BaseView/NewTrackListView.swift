//
//  TrackListView.swift
//  SmartMain
//
//  Created by mac on 2018/11/22.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class NewTrackListView: ETPopupViewSheet {
    var trackList: [EquipmentModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var songModel: SingDetailModel? // 当前播放歌曲model
    @IBOutlet weak var tableView: BaseTableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.cellId_register("TrackListHomeCell")
    }

}
// 默认分组间隔
extension NewTrackListView:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return XBMin
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return XBMin
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackListHomeCell", for: indexPath) as! TrackListHomeCell
        
        let model = trackList[indexPath.row]
        let trackCount = model.trackCount ?? 0
        let count = "共" + trackCount.toString + "首"
        cell.lbTitle.set_text = model.name
        
        cell.lbTatal.set_text = count
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = trackList[indexPath.row]
        self.requestAddSingWithList(trackId: model.id, trackName: model.name)
    }
    /**
     *   增加歌曲到预制列表中 添加单个歌曲
     */
    func requestAddSingWithList(trackId: Int? ,trackName: String?)  {
        guard let m = self.songModel else {
            XBHud.showMsg("所需歌曲信息不全")
            return
        }
        guard let trackId = trackId else {
            XBHud.showMsg("无歌单ID")
            return
        }
        guard let trackName = trackName else {
            XBHud.showMsg("无歌单名称")
            return
        }
        let req_model = AddSongTrackReqModel()
        req_model.id = m.id
        req_model.title = m.title
        req_model.coverSmallUrl = m.coverSmallUrl
        req_model.duration = m.duration
        req_model.url = m.url
        req_model.downloadSize = m.downloadSize?.toInt()
        req_model.downloadUrl = m.downloadUrl
        
        Net.requestWithTarget(.addSongToList(deviceId: XBUserManager.device_Id, trackId: trackId, trackName: trackName, trackIds: [req_model]), successClosure: { (result, code, message) in
            print(result)
            if let str = result as? String {
                if str == "ok" {
                    XBHud.showMsg("加入成功")
                    self.hide()
                }else if str == "duplicate" {
                    XBHud.showMsg("歌单已经存在")
                }
            }
        })
    }
}
class ETPopupViewSheet: ETPopupView{
    override func awakeFromNib() {
        super.awakeFromNib()
        animationDuration = 0.3
        type = .sheet
        
        self.snp.makeConstraints { (make) in
            make.width.equalTo(MGScreenWidth)
        }
        ETPopupWindow.sharedWindow().touchWildToHide = true
        UIApplication.shared.keyWindow?.endEditing(true)
        //        self.setCornerRadius(radius: 5.0)
        self.layoutIfNeeded()
        
    }
}
class BaseTableView: UITableView {
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        setupSubviews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    func setupSubviews()  {
        self.config_adjustInset()
        self.backgroundColor      = tableColor
        self.estimatedRowHeight   = 200
        self.rowHeight            = UITableViewAutomaticDimension
        self.separatorStyle       = .none
        self.keyboardDismissMode  = .onDrag
        self.showsVerticalScrollIndicator = false
    }
}
