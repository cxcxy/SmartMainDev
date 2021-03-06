
//
//  SearchViewController.swift
//  SmartMain
//
//  Created by mac on 2018/9/4.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
enum MerchantsDetailElement :String{
    
    case resource                       = "HeaderCycle"                // 顶部轮播
    case resourceAlbum                  = "MerchantsConvert"           // 是否有兑换金额
    
}
class SearchViewControllerNew: XBBaseViewController {
    //    var dataArr: [ConetentLikeModel] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var viewSearchTop: UIView!
    
    var dataRxArr =  Variable<[SectionModel<MerchantsDetailElement,Any>]>([])
    
    
    var trackList: [EquipmentModel] = [] // 预制列表 数组
    
    var headerInfo:ConetentSingAlbumModel?
    var dataArr: [ConetentSingModel] = []
    var viewModel = ContentViewModel()
    
    var resourceArr:[ConetentSingModel]      = []
    var resourceAlbum: [ConetentSingModel]   = []
    
    var sectionNumber: Int = 0
    
    //    var viewModel = ContentViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func setUI() {
        super.setUI()
        self.view.backgroundColor = UIColor.white
        self.currentNavigationHidden        = true
        viewSearchTop.setCornerRadius(radius: 10)
        textField.becomeFirstResponder()
        self.configTableView(tableView, register_cell: ["HistorySongCell","ContentSingSongCell"])
        tableView.delegate = nil
        tableView.dataSource = nil
        self.textField.delegate = self
        requestTrackList()
        self.configRxTableView()
    }
    func configRxTableView() {
        //创建数据源
        let dataSource = RxTableViewSectionedReloadDataSource
            <SectionModel<MerchantsDetailElement,Any>>(configureCell: {
                (dataSource, tableView, indexPath, element) in
                //                let row = indexPath.row
                let s =     dataSource.sectionModels[indexPath.section]
                switch s.model {
                case .resource:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HistorySongCell", for: indexPath) as! HistorySongCell
                    if let itemModel = element as? SearchResourceModel{
                        cell.lbTitle.set_text = itemModel.name
                        cell.lbTime.set_text  = "专辑：" + (itemModel.categoryName ?? "")
                        cell.btnExtension.addAction { [weak self] in
                            guard let `self` = self else { return }
                            self.showArr(item: itemModel)
                        }
                    }
                    return cell
                case .resourceAlbum:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ContentSingSongCell", for: indexPath) as! ContentSingSongCell
                    if let itemModel = element as? SearchResourceAlbumModel{
                        cell.lbTitle.set_text = itemModel.name
                        cell.imgIcon.set_Img_Url(itemModel.picCover)
                        cell.imgRight.isHidden = false
                    }
                    return cell
                }
            })
        
        dataRxArr.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx_disposeBag)
        /// 绑定 tableViewdelegate
        tableView.rx
            .setDelegate(self)
            .disposed(by: rx_disposeBag)
        /// 点击事件
        tableView.rx
            .itemSelected
            .subscribe {[weak self] (indexpath) in
                guard let `self` = self else { return }
                let s = dataSource.sectionModels[(indexpath.element?.section)!]
                switch s.model {
                case .resource:
                    break
                case .resourceAlbum:
                    break
                }
            }.disposed(by: rx_disposeBag)
        
    }
    
    override func request()  {
        super.request()
        //        var params_task = [String: Any]()
        //        params_task["clientId"] = XBUserManager.device_Id
        //        params_task["keywords"] = [self.textField.text]
        //        params_task["page"]     = self.pageIndex
        //        params_task["ranges"] = ["resource"]
        //        Net.requestWithTarget(.getSearchResource(req: params_task), successClosure: { (result, code, message) in
        //            if let arr = Mapper<SearchResourceModel>().mapArray(JSONObject:JSON(result)["resources"].arrayObject) {
        //                if self.pageIndex == 1 {
        //                    self.tableView.mj_footer = self.mj_footer
        //                    self.resourceArr.removeAll()
        //                }
        //                self.resourceArr += arr
        //                self.refreshStatus(status: arr.checkRefreshStatus(self.pageIndex,paseSize: 20))
        //            }
        //            if let topModel = Mapper<ConetentSingAlbumModel>().map(JSONObject:JSON(result)["resourcesPager"].object) {
        //                self.headerInfo = topModel
        //            }
        //            self.tableView.reloadData()
        //        })
    }
    //MARK: 按关键字搜索资源
    func requestResource()  {
        var params_resource = [String: Any]()
        params_resource["clientId"] = XBUserManager.device_Id
        params_resource["keywords"] = [self.textField.text]
        params_resource["page"]     = self.pageIndex
        params_resource["ranges"] = ["resource"]
        var params_album = [String: Any]()
        params_album["clientId"] = XBUserManager.device_Id
        params_album["keywords"] = [self.textField.text]
        params_album["page"]     = self.pageIndex
        params_album["ranges"] = ["album"]
        let request_class: Observable<([ConetentSingModel],[ConetentSingModel])>
            = Observable.zip(
                viewModel.requestZhiBanSearchResource(req: params_resource),
                viewModel.requestZhiBanSearchResource(req: params_album))
        
        request_class.subscribe(onNext: { [weak self](resourceArr,resourceAlbum) in
            guard let `self` = self else { return }
            self.resourceArr = resourceArr
            self.resourceAlbum = resourceAlbum
            self.configTableViewData()
            }, onError: {[weak self] (error) in
                guard let `self` = self else { return }
                
        }).disposed(by: rx_disposeBag)
        
    }
    
    func configTableViewData()  {
        dataRxArr.value.remove_All()
        if self.resourceArr.count > 0 {
            dataRxArr.value.append(SectionModel.init(model: .resource, items: self.resourceArr))
        }
        if self.resourceAlbum.count > 0 {
            dataRxArr.value.append(SectionModel.init(model: .resourceAlbum, items: self.resourceAlbum))
        }
        
    }
    func showArr(item: SearchResourceModel)  {
        VCRouter.prentSheetAction(dataArr: ["添加到播单","收藏"]) {[weak self] (index) in
            guard let `self` = self else { return }
            if index == 0 {
                self.showTrackListView(trackList: self.trackList,item: item)
            }
            if index == 1 {
                //                self.requestLikeSing()
                print("收藏")
                self.requestListSong(songId: item.id,
                                     duration: item.duration ?? 0,
                                     title: item.name ?? "")
            }
        }
    }
    //MARK: 底部弹出播放列表
    func showTrackListView(trackList: [EquipmentModel],item: SearchResourceModel)  {
        let v = PlaySongListView.loadFromNib()
        v.listViewType = .trackList_song
//        v.trackArr = trackList
        v.getTrackListIdBlock = {[weak self] (trackId, trackName) in
            guard let `self` = self else { return }
            v.hide()
            
            self.requestAddSingWithList(trackId: trackId,
                                        songId: item.id,
                                        songName: item.name,
                                        songDuration: item.duration,
                                        albumTitle: item.categoryName,
                                        albumCoverSmallUrl: item.picCover,
                                        songUrl: item.downloadUrl,
                                        trackName: trackName)
        }
        v.show()
    }
    @IBAction func clickCancelAction(_ sender: Any) {
        self.popVC()
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
        // Dispose of any resources that can be recreated.
    }
    
}
extension SearchViewControllerNew {
    
    //MARK: 在线点播歌曲
    func requestOnlineSing(trackId: String)  {
        let arr = trackId.components(separatedBy: ":")
        guard arr.count > 1 else {
            return
        }
        viewModel.requestOnlineSing(openId: user_defaults.get(for: .userName)!, trackId: arr[1], deviceId: XBUserManager.device_Id) {
            
        }
    }
    /**
     *   增加歌曲到预制列表中 添加单个歌曲
     */
    func requestAddSingWithList(trackId: Int,
                                songId: Int?,
                                songName: String?,
                                songDuration: Int?,
                                albumTitle: String?,
                                albumCoverSmallUrl: String?,
                                songUrl: String?,
                                trackName: String)  {
        
        let req_model = AddSongTrackReqModel()
        req_model.id                    = songId
        req_model.title                 = songName
        req_model.coverSmallUrl         = ""
        req_model.duration              = songDuration
        req_model.albumTitle            = albumTitle
        req_model.albumCoverSmallUrl    = albumCoverSmallUrl
        req_model.url                   = songUrl
        req_model.downloadSize          = 1
        req_model.downloadUrl           = ""
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
    func requestListSong(songId: Int?,duration: Int,title: String)  {
        viewModel.requestLikeSing(songId: songId, duration: duration, title: title) {
            print("收藏成功")
        }
    }
    /**
     *   取消收藏歌曲
     */
    func requestCancleLikeSing(trackId: String?,section: Int)  {
        
        var params_task = [String: Any]()
        params_task["openId"] = XBUserManager.userName
        params_task["trackId"]  = trackId
        Net.requestWithTarget(.deleteLikeSing(req: params_task), successClosure: { (result, code, message) in
            print(result)
            if let str = result as? String {
                if str == "ok" {
                    XBHud.showMsg("取消收藏成功")
                    self.dataArr.remove(at: section)
                    self.tableView.reloadData()
                }else {
                    XBHud.showMsg("取消收藏失败")
                }
            }
        })
    }
}
extension SearchViewControllerNew: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.textField {
            self.requestResource()
            //            self.requestResourceAlbum()
        }
        return true
    }
    
}
