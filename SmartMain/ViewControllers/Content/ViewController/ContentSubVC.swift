//
//  ContentSubVC.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/4.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
enum ContentSubType {
    case search // 从搜索点击进来
    case none // 默认进来
}
class ContentSubVC: XBBaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let itemWidth:CGFloat = ( MGScreenWidth - 20 - 20 - 20 ) / 2 // item 宽度
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    // 底部加载
    let footer = MJRefreshAutoNormalFooter()
    
    var listType: ContentSubType = .none
    var searchKey: String = ""
    var resourceAlbum: [ConetentSingModel]   = []
    
    var clientId: String!
    var albumId: String?
    var modouleId: String?
    var dataArr: [ModulesConetentModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func setUI() {
        super.setUI()
//        self.currentNavigationHidden = true
        configCollectionView()
        //下拉刷新相关设置
        header.setRefreshingTarget(self, refreshingAction: #selector(pullToRefresh))
        
        //上拉加载相关设置
        footer.setRefreshingTarget(self, refreshingAction: #selector(loadMore))
        request()
        view.backgroundColor = UIColor.init(hexString: "CDE5B2")
        makeCustomerImageNavigationItem("icon_music_white", left: false) { [weak self] in
            guard let `self` = self else { return }
            VCRouter.toPlayVC()
        }
//        let v = ContentTopNavView.loadFromNib()
//        v.frame = CGRect.init(x: 0, y: 0, w: MGScreenWidth, h: 135)
//        self.view.addSubview(v)
    }
    func configCollectionView()  {
        collectionView.cellId_register("ContentSubItem")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        
    }
    override func request() {
        super.request()
        switch listType {
        case .none:
            requestNoneList()
            break
        case .search:
            requestResourceAlbum()
            break

        }

        
    }
    func collectionViewEndRefresh()  {
        self.header.endRefreshing()
        self.footer.endRefreshing()
    }
    /**
     *   根据状态来处理 上拉刷新，下来加载的控件展示与否
     */
    func refreshCollectionViewStatus(status:RefreshStatus){
        switch status {
        case .PullSuccess:
            self.footer.isHidden = false
            collectionViewEndRefresh()
        case .PushSuccess:
            self.footer.isHidden = false
            collectionViewEndRefresh()
        case .RefreshFailure:
            collectionViewEndRefresh()
            self.footer.isHidden = true
        case .NoMoreData :
            collectionViewEndRefresh()
            self.footer.isHidden = true
            
        case .Unknown: break
        }
    }
    func requestNoneList() {
        var params_task = [String: Any]()
        params_task["clientId"] = clientId
        params_task["moduleId"] = modouleId
        params_task["albumId"] = albumId
        params_task["page"] = self.pageIndex
        params_task["count"] = XBPageSize
        Net.requestWithTarget(.contentsub(req: params_task), successClosure: { (result, code, message) in
            if let arr = Mapper<ModulesConetentModel>().mapArray(JSONObject:JSON(result)["categories"].arrayObject) {
                if self.pageIndex == 1 {
                    self.dataArr.removeAll()
                    self.collectionView.mj_footer = self.footer
                    
                }
                self.dataArr += arr
                self.refreshCollectionViewStatus(status: arr.checkRefreshStatus(self.pageIndex))
                self.collectionViewEndRefresh()
                self.collectionView.reloadData()
            }
        })
    }
    /// 搜索专辑
    func requestResourceAlbum()  {
        var params_album = [String: Any]()
        params_album["clientId"] = XBUserManager.device_Id
        params_album["keywords"] = [searchKey]
        params_album["page"]     = self.pageIndex
        params_album["ranges"] = ["album"]
        Net.requestWithTarget(.getSearchResource(req: params_album), successClosure: { (result, code, message) in
            if let arr = Mapper<ConetentSingModel>().mapArray(JSONObject:JSON(result)["albums"].arrayObject) {
                if self.pageIndex == 1 {
                    self.resourceAlbum.removeAll()
                    self.collectionView.mj_footer = self.footer
                }
                self.resourceAlbum += arr
                self.refreshCollectionViewStatus(status: arr.checkRefreshStatus(self.pageIndex,paseSize: 20))
                self.collectionViewEndRefresh()
                self.collectionView.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension ContentSubVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch listType {
        case .none:
            return dataArr.count
        case .search:
            return resourceAlbum.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentSubItem", for: indexPath)as! ContentSubItem
        //        cell.imgIcon.contentMode = .scaleAspectFit
        switch listType {
        case .none:
            cell.lbTitle.set_text = dataArr[indexPath.row].name
            cell.imgIcon.set_Img_Url(dataArr[indexPath.row].imgSmall)
            let totalStr = dataArr[indexPath.row].total?.toString ?? ""
            cell.lbTotal.set_text = "共" + totalStr + "首"
        case .search:
            cell.lbTitle.set_text = resourceAlbum[indexPath.row].name
            cell.imgIcon.set_Img_Url(resourceAlbum[indexPath.row].imgSmall)
            let totalStr = resourceAlbum[indexPath.row].total?.toString ?? ""
            cell.lbTotal.set_text = "共" + totalStr + "首"
        }

        return cell
    }
    //最小item间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 20, left: 0, bottom: 20, right: 0)
    }
    //item 的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:itemWidth ,height:itemWidth * 205 / 155)
    }
    //item 对应的点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch listType {
        case .none:
            let model = dataArr[indexPath.row]
            if model.albumType == 2 {
                VCRouter.toContentSubVC(clientId: XBUserManager.device_Id, albumId: model.id ?? "", navTitle: model.name)
            }else {
                VCRouter.toContentSingsVC(clientId: XBUserManager.device_Id, albumId: model.id ?? "")
            }
        case .search:
            let model = resourceAlbum[indexPath.row]
            VCRouter.toContentSingsVC(clientId: XBUserManager.device_Id, albumId: model.albumId?.toString ?? "")
        }

    }

}

//extension ContentSubVC {
////    override func numberOfSections(in tableView: UITableView) -> Int {
////        return dataArr.count
////    }
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return dataArr.count
//
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentSubShowCell", for: indexPath) as! ContentSubShowCell
//        cell.lbTitle.set_text = dataArr[indexPath.row].name
//        cell.imgIcon.set_Img_Url(dataArr[indexPath.row].imgSmall)
//        return cell
//
//    }
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //        VCRouter.toContentSubVC()
//        let model = dataArr[indexPath.row]
//        if model.albumType == 2 {
//            VCRouter.toContentSubVC(clientId: XBUserManager.device_Id, albumId: model.id ?? "", navTitle: model.name)
//        }else {
//            VCRouter.toContentSingsVC(clientId: XBUserManager.device_Id, albumId: model.id ?? "")
//        }
//    }
////    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
////        return 10
////    }
//
////    //设置cell的显示动画
////    func tableView(tableView: UITableView!, willDisplayCell cell: UITableViewCell!,
////                   forRowAtIndexPath indexPath: NSIndexPath!){
////
////    }
////    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
////        //设置cell的显示动画为3D缩放
////        //xy方向缩放的初始值为0.1
////        cell.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1)
////        //设置动画时间为0.25秒，xy方向缩放的最终值为1
////        UIView.animate(withDuration: 0.25, animations: {
////            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
////        })
////    }
//}
