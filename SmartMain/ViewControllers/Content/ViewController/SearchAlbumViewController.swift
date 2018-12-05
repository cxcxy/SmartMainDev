//
//  ContentSingsVC.swift
//  SmartMain
//
//  Created by mac on 2018/9/5.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class SearchAlbumViewController: XBBaseViewController {
    
    var dataTopArr : [ConetentSingModel] = [] {
        didSet {
            //            let arr = self.flatMapLikeList(arr: self.dataArr)
            self.tableView.mj_footer = self.mj_footer
            self.dataArr.removeAll()
            self.resourceAlbum = self.flatMapLikeList(arr: self.dataTopArr)
            self.refreshStatus(status: dataTopArr.checkRefreshStatus(self.pageIndex,paseSize: 20))
        }
    }
    
    var dataArr: [ConetentSingModel] = [] {
        didSet {
            //            let arr = self.flatMapLikeList(arr: self.dataArr)
            self.tableView.reloadData()
        }
    }

//    var headerInfo:ConetentSingAlbumModel?
    var headerAlbumInfo:ConetentSingAlbumModel? {
        didSet {
            guard let m = headerAlbumInfo else {
                return
            }
            self.setTopViewInfo(total: m.total?.toString ?? "")
        }
    }
    @IBOutlet weak var headerView: UIView!
    var viewModel   = ContentViewModel()
    @IBOutlet weak var tableView: UITableView!
    var searchKey: String = ""
    
    var resourceAlbum: [ConetentSingModel]   = []{
        didSet {
            self.tableView.reloadData()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentNavigationHidden        = true
    }
    override func setUI() {
        super.setUI()
        title = "更多歌曲"
        self.configTableView(tableView, register_cell: ["ContentSingCell",
                                                        "HistorySongCell",
                                                        "HistorySongContentCell"])
        self.tableView.mj_header = self.mj_header
        self.tableView.mj_footer = self.mj_footer
        
        configTopHeaderView()
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
    func flatMapLikeList(arr: [ConetentSingModel]) -> [ConetentSingModel] {
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
    func configTopHeaderView()  {
        self.headerView.addSubview(topView)
    }
    
    func setTopViewInfo(total: String)  {
        topView.lbTotal.set_text = "共" + total + "条结果"
    }
    
    override func request() {
        super.request()
        requestResourceAlbum()
    }
    
    /// 搜索专辑
    func requestResourceAlbum()  {
        var params_album = [String: Any]()
        params_album["clientId"] = XBUserManager.device_Id
        params_album["keywords"] = [searchKey]
        params_album["page"]     = self.pageIndex
        params_album["ranges"] = ["album"]
        Net.requestWithTarget(.getSearchResource(req: params_album), successClosure: { (result, code, message) in
            self.endRefresh()
            if let arr = Mapper<ConetentSingModel>().mapArray(JSONObject:JSON(result)["albums"].arrayObject) {
                if self.pageIndex == 1 {
                    self.resourceAlbum.removeAll()
                    self.tableView.mj_footer = self.mj_footer
                }
                self.resourceAlbum += arr
                self.refreshStatus(status: arr.checkRefreshStatus(self.pageIndex,paseSize: 20))
                self.tableView.reloadData()
                self.starAnimationWithTableView(tableView: self.tableView)
            }
            if let topModel = Mapper<ConetentSingAlbumModel>().map(JSONObject:JSON(result)["albumsPager"].object) {
                self.headerAlbumInfo = topModel
            }
        })
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
extension SearchAlbumViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resourceAlbum.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistorySongCell", for: indexPath) as! HistorySongCell
        let m  = resourceAlbum[indexPath.row]
        cell.lbTitle.set_text = m.name
        let totalStr = m.total?.toString ?? ""
        cell.lbTime.set_text = "共" + totalStr + "首"
        cell.btnExtension.isHidden = true
        cell.imgIcon.set_Img_Url(m.imgSmall)
        cell.imgRight.isHidden = false
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard XBUserManager.device_Id != "" else {
            XBHud.showMsg("请先绑定设备")
            return
        }
        let model = resourceAlbum[indexPath.row]
        VCRouter.toContentSingsVC(clientId: XBUserManager.device_Id, albumId: model.albumId?.toString ?? "")
        //        self.requestOnlineSing(trackId: dataArr[indexPath.row].resId ?? "")
    }
 
}
