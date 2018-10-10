//
//  PlaySongListView.swift
//  SmartMain
//
//  Created by mac on 2018/10/9.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class PlaySongListView: ETPopupView {
    
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnCloose: UIButton!
    var dataArr: [EquipmentSingModel] = []
    var trackListId: Int!// 列表id
    var pageIndex: Int = 1
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        animationDuration = 0.3
        type = .sheet
        viewContent.setCornerRadius(radius: 10)
        
        self.snp.makeConstraints { (make) in
            make.width.equalTo(MGScreenWidth)
            make.height.equalTo(MGScreenWidth + 50)
        }
        ETPopupWindow.sharedWindow().touchWildToHide = true
        self.layoutIfNeeded()
        self.configTableView()
        self.btnCloose.addAction {[weak self] in
            guard let `self` = self else { return }
            self.hide()
        }
    }
    func configTableView()  {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.cellId_register("HistorySongCell")
        request()
    }
    func request() {
        var params_task = [String: Any]()
        params_task["trackListId"] = trackListId
        params_task["currentPage"] = pageIndex
        params_task["pageSize"] = XBPageSize
        Net.requestWithTarget(.getTrackSubList(req: params_task), successClosure: { (result, code, message) in
        
            if let arr = Mapper<EquipmentSingModel>().mapArray(JSONObject: JSON.init(parseJSON: result as! String)["tracks"].arrayObject) {
                if self.pageIndex == 1 {
                    self.dataArr.removeAll()
                    self.tableView.mj_footer = self.mj_footer
                }
                self.dataArr += arr
//                self.total = JSON.init(parseJSON: result as! String)["totalCount"].int
                self.refreshStatus(status: arr.checkRefreshStatus(self.pageIndex))
                self.tableView.reloadData()
            }
            
        })
    }
    /**
     *   tableView 的 MJ_Footer
     */
    lazy var mj_footer:MJRefreshAutoNormalFooter = {
        let f = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction:#selector(loadMore))!
        return f
    }()
    /**
     *   上拉加载， 自动加1
     */
    @objc func loadMore() {
        pageIndex += 1
        request()
    }
    /**
     *   结束刷新 ，停止动作
     */
    func endRefresh() {
//        mj_header.endRefreshing()
        mj_footer.endRefreshing()
    }
    /**
     *   根据状态来处理 上拉刷新，下来加载的控件展示与否
     */
    func refreshStatus(status:RefreshStatus){
        switch status {
        case .PullSuccess:
            self.mj_footer.isHidden = false
            endRefresh()
        case .PushSuccess:
            self.mj_footer.isHidden = false
            endRefresh()
        case .RefreshFailure:
            endRefresh()
            self.mj_footer.isHidden = true
        case .NoMoreData :
            endRefresh()
            self.mj_footer.isHidden = true
            
        case .Unknown: break
        }
    }
}
extension PlaySongListView: UITableViewDelegate,UITableViewDataSource {
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
        return dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistorySongCell", for: indexPath) as! HistorySongCell
        let m  = dataArr[indexPath.row]
        cell.lbTitle.set_text = m.title
        cell.btnExtension.isHidden = true
        cell.lbTime.set_text = XBUtil.getDetailTimeWithTimestamp(timeStamp: m.duration)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         self.requestSingDetail(trackId: dataArr[indexPath.row].id ?? 0)
    }
    // 获取歌曲详情 发送MQTT 播放歌曲
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
    func sendTopicSingDetail(singModel: SingDetailModel)  {
        ScoketMQTTManager.share.sendTrackListPlay(trackListId: trackListId, singModel: singModel)
        self.hide()
    }
}
