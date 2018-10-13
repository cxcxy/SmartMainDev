//
//  ContentSingsVC.swift
//  SmartMain
//
//  Created by mac on 2018/9/5.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class ContentSingsVC: XBBaseViewController {
    var clientId: String! // 当前设备ID
    var albumId: String! // 当前歌曲列表 ID
    var dataArr: [ConetentSingModel] = []
    var trackList: [EquipmentModel] = [] // 预制列表 数组
    var headerInfo:ConetentSingAlbumModel?
    @IBOutlet weak var lbTopDes: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgTop: UIImageView!
    var viewModel = ContentViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentNavigationNone = true
    }
    override func setUI() {
        super.setUI()
        self.configTableView(tableView, register_cell: ["ContentSingCell"])
        self.tableView.mj_header = self.mj_header
        
        request()
        requestTrackList()
    }
    func configTopHeadeaInfp(model: ConetentSingAlbumModel!)  {
        self.headerInfo = model
        lbTopDes.set_text = model.name
        imgTop.set_Img_Url(model.imgLarge)
    }
    override func request() {
        super.request()
        var params_task = [String: Any]()
        params_task["clientId"] = clientId
        params_task["albumId"] = albumId
        params_task["page"] = self.pageIndex
        params_task["count"] = XBPageSize
        Net.requestWithTarget(.contentsings(req: params_task), successClosure: { (result, code, message) in
            if let arr = Mapper<ConetentSingModel>().mapArray(JSONObject:JSON(result)["list"].arrayObject) {
                if self.pageIndex == 1 {
                    self.tableView.mj_footer = self.mj_footer
                    self.dataArr.removeAll()
                }
                self.dataArr += arr
                self.refreshStatus(status: arr.checkRefreshStatus(self.pageIndex))
            }
            if let topModel = Mapper<ConetentSingAlbumModel>().map(JSONObject:JSON(result)["album"].object) {
                self.configTopHeadeaInfp(model: topModel)
            }
            self.tableView.reloadData()
            self.starAnimationWithTableView(tableView: self.tableView)
        })
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
    //MARK: 点击添加全部
    func clickAddAllSongsToTrackList()  {
        guard XBUserManager.device_Id != "" else {
            XBHud.showMsg("请先绑定设备")
            return
        }
        let v = PlaySongListView.loadFromNib()
        v.lbTitleDes.set_text = "添加至"
        v.listViewType = .trackList
        v.trackArr = self.trackList
        v.getTrackListIdBlock = {[weak self] trackId in
            guard let `self` = self else { return }
            v.hide()
            self.requestAddSingsTrackList(trackId: trackId)
        }
        v.show()
    }
}
extension ContentSingsVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = ContentSingHaderView.loadFromNib()
        if let total = headerInfo?.total {
            v.lbTotal.set_text = "共" + total.toString + "首"
        }else {
            v.lbTotal.set_text = ""
        }
        v.btnAddAll.addAction { [weak self]in
            guard let `self` = self else { return }
            self.clickAddAllSongsToTrackList()
        }
        return v
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentSingCell", for: indexPath) as! ContentSingCell

        cell.modelData = dataArr[indexPath.row]
        cell.headerInfo = self.headerInfo
        cell.lbLineNumber.set_text = (indexPath.row + 1).toString
//        guard XBUserManager.device_Id != "" else {
//            XBHud.showMsg("请先绑定设备")
//            return
//        }
//        if XBUserManager.device_Id == "" {
//            cell.setArr = ["收藏"]
//        }else {
//            cell.setArr = ["添加到播单","收藏"]
//        }
        cell.setArr = ["添加到播单","收藏"]
        cell.trackList = self.trackList
        
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard XBUserManager.device_Id != "" else {
            XBHud.showMsg("请先绑定设备")
            return
        }
        self.requestOnlineSing(trackId: dataArr[indexPath.row].resId ?? "")
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
}
