//
//  LikeViewController.swift
//  SmartMain
//
//  Created by mac on 2018/9/4.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class LikeViewController: XBBaseViewController {
    @IBOutlet weak var lbTotal: UILabel!
    //    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var viewAllSelect: UIView!
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnAllSelect: UIButton!
    @IBOutlet weak var bottomDeleteView: UIView!
    var dataArr: [ConetentLikeModel] = [] {
        didSet {
            self.configDelegateArr()
        }
        
    }
        var dataDelegate: BaseTableViewDelegate = BaseTableViewDelegate()
    var viewModel = ContentViewModel()
    var scoketModel = ScoketMQTTManager.share
    
    var isHiddenEditDelete: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.cellId_register("HistorySongCell")
//        tableView.cellId_register("HistorySongContentCell")
        self.tableView.mj_header = self.mj_header
//        self.configTableView(tableView, register_cell: ["HistorySongCell","HistorySongContentCell"])
    }
    override func setUI() {
        super.setUI()
        self.viewAllSelect.isHidden = true
        bottomDeleteView.isHidden = true
        
//        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 80, right: 0)
        dataDelegate.tableView = self.tableView
        dataDelegate.songListType = .like
        
        dataDelegate.selectStatus = { [weak self](status) in
            guard let `self` = self else { return }
            self.btnAllSelect.isSelected = (status == 2)
        }
        request()
        self.currentNavigationHidden = true
          configCurrentSongsId()
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        request()
//    }
    
    @IBAction func clickEditAction(_ sender: Any) {

        self.reloadEditStatus()
    }
    func reloadEditStatus()  {
        UIView.animate(withDuration: 0.3) {
            self.bottomDeleteView.isHidden = !self.isHiddenEditDelete
        }
        dataDelegate.isAllSelect = false // 重置选择状态
        self.btnAllSelect.isSelected = false
        self.mj_header.isHidden = self.isHiddenEditDelete // 隐藏下拉刷新组建
        self.btnEdit.isSelected = self.isHiddenEditDelete // 更新编辑按钮文案
        self.viewAllSelect.isHidden = !self.isHiddenEditDelete
        self.lbTotal.isHidden = self.isHiddenEditDelete
        dataDelegate.isEdit = self.isHiddenEditDelete
        self.isHiddenEditDelete = !self.isHiddenEditDelete
    }
    /// 配置tableView里面的数据源
    func configDelegateArr()  {
        self.dataDelegate.dataArr = self.dataArr.map({ (item) -> BaseListItem in
            let listItem = BaseListItem()
            listItem.title = item.title ?? ""
            listItem.time =  item.duration
            listItem.trackId = item.trackId ?? 0
            listItem.isLike = true
            return listItem
        })
        self.lbTotal.set_text = "共" + self.dataDelegate.dataArr.count.toString + "首"
    }
    /// 本地删除数据源
    func deleteArr(selectIds: [Int])  {
        for item in self.dataArr.enumerated() {
            for id in selectIds {
                if item.element.trackId == id {
                    self.dataArr.remove(at: item.offset)
                }
            }
        }
        self.configDelegateArr()
        self.reloadEditStatus()
        
        self.tableView.reloadData()
        self.tableView.mj_footer.endRefreshingWithNoMoreData()
//        self.refreshStatus(status: .NoMoreData)
    }
    
    func requestDeleteRangeSing(phone: String, selectIds: [Int])  {

        Net.requestWithTarget(.deleteLikeRangeSing(openId: phone, trackIds: selectIds), successClosure: { (result, code, message) in
            print(result)
            if let result = result as? String {
                guard let status = result.json_Str()["status"].int else {
                    return
                }
                if status == 200 {
                    self.deleteArr(selectIds: selectIds)
                }
                if status == 404 {
                    XBHud.showWarnMsg("此用户没有歌单")
                }
            }
            
            self.endRefresh()
            
        }){ (errorMsg) in
            
        }
    }
    @IBAction func clickRangeDeleteAction(_ sender: Any) {
        guard let phone = user_defaults.get(for: .userName) else {
            XBHud.showMsg("请登录")
            return
        }
        let selectIds =  self.dataDelegate.dataArr.compactMap { (item) -> Int? in
            if item.isSelect {
                return item.trackId ?? 0
            }else {
                return nil
            }
        }
        guard selectIds.count > 0 else {
            XBHud.showMsg("请选择歌曲")
            return
        }
        let v = SmartHindView.loadFromNib()
        v.hindType = .delete
        v.block = { [weak self](isSure) in
            guard let `self` = self else { return }
            if isSure {
                self.requestDeleteRangeSing(phone: phone, selectIds: selectIds)
            }
        }
        v.show()
     
    }
    @IBAction func clickEditAllSelectAction(_ sender: UIButton) {
        dataDelegate.isAllSelect = !btnAllSelect.isSelected
        btnAllSelect.isSelected = !btnAllSelect.isSelected
        
    }
    override func request() {
        super.request()
        guard let phone = user_defaults.get(for: .userName) else {
            XBHud.showMsg("请登录")
            return
        }
        Net.requestWithTarget(.getLikeList(openId: phone), successClosure: { (result, code, message) in
            print(result)
             self.endRefresh()
            if let arr = Mapper<ConetentLikeModel>().mapArray(JSONString: result as! String) {
                if self.pageIndex == 1 {
  
                    self.tableView.mj_footer = self.mj_footer
                    self.dataArr.removeAll()
                }
               
                self.dataArr += arr
                
                userLikeList = self.dataArr // 刷新我的最爱数据
                self.refreshStatus(status: .NoMoreData)
                self.scoketModel.sendGetTrack()
                self.tableView.reloadData()
                self.starAnimationWithTableView(tableView: self.tableView)
            }
        }){ (errorMsg) in
            if errorMsg == ERROR_TIMEOUT {
                self.loadingTimerOut = true
            } else {
                self.loading = true
            }
            self.endRefresh()
        }
    }
    func configCurrentSongsId()  {
        scoketModel.getPalyingSingsId.asObservable().subscribe { [weak self] in
            guard let `self` = self else { return }
            print("getPalyingSingsId ===：", $0.element ?? 0)
            
            self.mapSongsArrPlayingStatus(songId: $0.element ?? 0)
            }.disposed(by: rx_disposeBag)
    }
//    m.trackId
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
    func starAnimationWithTableView(tableView: UITableView) {
        //        table
        if self.pageIndex == 1 {
            TableViewAnimationKit.show(with: .moveSpring, tableView: tableView)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
//extension LikeViewController {
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return dataArr.count
//    }
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        let m  = dataArr[section]
//        return m.isExpanded ? 2 : 1
//
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "HistorySongCell", for: indexPath) as! HistorySongCell
//            let m  = dataArr[indexPath.section]
//            cell.lbTitle.set_text = m.title
//            cell.lbTime.set_text = XBUtil.getDetailTimeWithTimestamp(timeStamp: m.duration)
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
//                    self.requestOnlineSing(trackId: m.trackId?.toString ?? "")
//                }
//
//            }
//
//            return cell
//        }else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "HistorySongContentCell", for: indexPath) as! HistorySongContentCell
//            let m  = dataArr[indexPath.section]
//            cell.viewAdd.isHidden = true
//            cell.viewDel.isHidden = true
//            cell.lbLike.set_text = "取消收藏"
//            cell.btnLike.isSelected = true
//            cell.viewLike.addTapGesture {[weak self] (sender) in
//                guard let `self` = self else { return }
//                self.requestCancleLikeSing(trackId: m.trackId?.toString, section: indexPath.section)
//            }
//            return cell
//        }
//    }
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard XBUserManager.device_Id != "" else {
//            XBHud.showMsg("请先绑定设备")
//            return
//        }
////        self.clickExtensionAction(indexPath: indexPath)
//
//    }
//    func clickExtensionAction(indexPath: IndexPath)  {
//        if indexPath.row == 0 {
//            let m  = dataArr[indexPath.section]
//            m.isExpanded = !m.isExpanded
//            tableView.reloadSections([indexPath.section], animationStyle: .automatic)
//        }
//        if indexPath.row == 1 {
//            let m  = dataArr[indexPath.section]
//            self.requestCancleLikeSing(trackId: m.trackId?.toString, section: indexPath.section)
//        }
//    }
//    //MARK: 在线点播歌曲
//    func requestOnlineSing(trackId: String)  {
//
//        viewModel.requestOnlineSing(openId: user_defaults.get(for: .userName)!, trackId: trackId, deviceId: XBUserManager.device_Id) {
//
//        }
//    }
//    /**
//     *   取消收藏歌曲
//     */
//    func requestCancleLikeSing(trackId: String?,section: Int)  {
//
//        viewModel.requestCancleLikeSing(trackId: trackId?.toInt() ?? 0) {
//            self.dataArr.remove(at: section)
//            self.tableView.reloadData()
//
//        }
//
//    }
//}
