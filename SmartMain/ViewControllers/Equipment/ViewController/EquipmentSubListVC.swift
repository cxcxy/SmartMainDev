//
//  ContentSingsVC.swift
//  SmartMain
//
//  Created by mac on 2018/9/5.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class EquipmentSubListVC: XBBaseTableViewController {
    var trackListId: Int! // 列表id
    
    var dataArr: [EquipmentSingModel] = []
    var headerInfo:ConetentSingAlbumModel?
    var total: Int?
    var viewModel = ContentViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func setUI() {
        super.setUI()
        self.registerCells(register_cells: ["ContentSingCell"])
        self.tableView.mj_header = self.mj_header
//        self.tableView.mj_footer = self.mj_footer
        request()

        ScoketMQTTManager.share.getSetDefaultMessage.asObservable().subscribe { [weak self] in
            guard let `self` = self else { return }
            print("getSetDefaultMessage ===：", $0.element ?? "")
            if let model = Mapper<GetTrackListDefault>().map(JSONString: $0.element!) {
                self.requestSetDefault(model: model)
            }
        }.disposed(by: rx_disposeBag)
    }

    override func request() {
        super.request()
        var params_task = [String: Any]()
        params_task["trackListId"] = trackListId
        params_task["currentPage"] = self.pageIndex
        params_task["pageSize"] = XBPageSize
        Net.requestWithTarget(.getTrackSubList(req: params_task), successClosure: { (result, code, message) in
            
            if let arr = Mapper<EquipmentSingModel>().mapArray(JSONObject: JSON.init(parseJSON: result as! String)["tracks"].arrayObject) {
                if self.pageIndex == 1 {
                    self.dataArr.removeAll()
                    self.tableView.mj_footer = self.mj_footer
                }
                self.dataArr += arr
                self.total = JSON.init(parseJSON: result as! String)["totalCount"].int
                self.refreshStatus(status: arr.checkRefreshStatus(self.pageIndex))
                self.tableView.reloadData()
            }
           
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func sendTopicSetDefault()  {
        ScoketMQTTManager.share.sendSetDefault(trackListId: trackListId)
    }
    func requestSetDefault(model: GetTrackListDefault)  {
        guard let trackIds = model.trackIds else {
            return
        }
        Net.requestWithTarget(.setTrackListDefult(trackListId: trackListId, deviceId: XBUserManager.device_Id, trackIds: trackIds), successClosure: { (result, code, message) in
            if let str = result as? String {
                if str == "ok" {
                    self.request()
                }
            }
        })
        
    }
}
extension EquipmentSubListVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = ContentSingHaderView.loadFromNib()
        v.btnAddAll.set_Title("恢复默认列表")
        v.btnAddAll.addAction {[weak self] in
            guard let `self` = self else { return }
            self.sendTopicSetDefault()
        }
        if let total = self.total {
            v.lbTotal.set_text = "共" + total.toString + "首"
        }else {
            v.lbTotal.set_text = ""
        }
        return v
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentSingCell", for: indexPath) as! ContentSingCell
        cell.singModelData = dataArr[indexPath.row]
        cell.listId = self.trackListId
        cell.lbLineNumber.set_text = (indexPath.row + 1).toString
        cell.setArr = ["添加到播单","收藏","删除"]
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//         self.requestOnlineSing(trackId: (dataArr[indexPath.row].id ?? 0).toString)
        self.requestSingDetail(trackId: dataArr[indexPath.row].id ?? 0)
    }
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
    }
    func requestOnlineSing(trackId: String)  {
        
        viewModel.requestOnlineSing(openId: user_defaults.get(for: .userName)!, trackId: trackId, deviceId: XBUserManager.device_Id) {
            
        }
    }
}


