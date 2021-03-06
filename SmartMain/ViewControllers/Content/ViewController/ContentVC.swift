//
//  ContentVC.swift
//  SmartMain
//
//  Created by mac on 2018/9/4.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class ContentVC: XBBaseViewController {
    var dataArr: [ModulesResModel] = []
    var dataTrackArr: [EquipmentModel] = []
    var bannersArr: [ResourceBannerModel] = []
    
    @IBOutlet weak var viewTopLayout: NSLayoutConstraint!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var tableView: UITableView!
     @IBOutlet weak var viewSearchTop: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 80, right: 0)
        tableView.cellId_register("ContentHeaderCell")
        tableView.cellId_register("ContentShowCell")
        tableView.cellId_register("ContentShowThreeCell")
        tableView.cellId_register("ContentScrollCell")
        tableView.cellId_register("ContentSingSongCell")
        tableView.cellId_register("Cell_801_Product")
        
        self.configTableView(tableView)
        tableView.mj_header = self.mj_header
        
    }
    override func setUI() {
        super.setUI()
        self.currentNavigationHidden = true
         viewSearchTop.setCornerRadius(radius: 15)
        viewSearchTop.addTapGesture { [weak self](sender) in
            guard let `self` = self else { return }
            VCRouter.toSearchSingsVC()
        }
        request()
        
    }
    override func request() {
        super.request()
        
        var params_task = [String: Any]()
        params_task["clientId"] = XBUserManager.device_Id
        params_task["tags"] = ["six"]
        Net.requestWithTarget(.contentModules(req: params_task), successClosure: { (result, code, message) in
            self.endRefresh()
            if let arr = Mapper<ModulesResModel>().mapArray(JSONObject:JSON(result)["modules"].arrayObject) {
                let filterArr = arr.filter({ (item) -> Bool in
                    if let contents = item.contents {
                        return contents.count > 0
                    }
                    return false
                })
                self.dataArr = filterArr
//                self.endRefresh()
                self.requestResourceBanners()
//                self.tableView.reloadData()
            }
        }) { (errorMsg) in
            if errorMsg == ERROR_TIMEOUT {
                self.loadingTimerOut = true
            } else {
                self.loading = true
            }
            self.endRefresh()
        }
    }
    //MARK: 请求顶部banner 接口
    func requestResourceBanners()  {
        Net.requestWithTarget(.getResourceBanner(customer: "zhiban"), successClosure: { (result, code, message) in
            if let obj = Net.filterStatus(jsonString: result) {
                if let banners = Mapper<ResourceBannerModel>().mapArray(JSONObject: obj.object) {
                    self.bannersArr = banners
                    self.endRefresh()
                    self.tableView.reloadData()
                }
            }
        }) { (errorMsg) in

        }
    }
    func starAnimationWithTableView(tableView: UITableView) {

        if self.pageIndex == 1 {
            TableViewAnimationKit.show(with: .moveSpring, tableView: tableView)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
extension ContentVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard dataArr.count > 0 else {
            return 0
        }
        return dataArr.count > 6 ? 7 : dataArr.count + 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

//        if section == 4 {
//            return 5
//        }else {
            return 1
//        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentHeaderCell", for: indexPath) as! ContentHeaderCell
            cell.dataArr = self.bannersArr
            return cell
//            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_801_Product", for: indexPath) as! Cell_801_Product
//            let model1 = ConfigNetModel()
//            model1.title = "1"
//            model1.des = "2"
//            cell.dataSourceArray = [model1,model1,model1]
//            return cell
            
        }
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentShowCell", for: indexPath) as! ContentShowCell
//            cell.collectionDataArr = ["1","2","3","4"]
            cell.dataModel = dataArr[indexPath.section - 1]
//            let img = dataArr[0]
            
            return cell
        }
//        if indexPath.section == 2 {
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentScrollCell", for: indexPath) as! ContentScrollCell
//            //            cell.collectionDataArr = ["1","2","3","4"]
//            cell.dataModel = dataArr[indexPath.section - 1]
//            //            let img = dataArr[0]
//
//            return cell
//        }
//        if indexPath.section == 4 {
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentSingSongCell", for: indexPath) as! ContentSingSongCell
//            let sectionModel = dataArr[indexPath.section - 1]
//            let contentArr = sectionModel.contents ?? []
//            cell.imgIcon.set_Img_Url(contentArr[indexPath.row].imgLarge)
//            cell.lbTitle.set_text = contentArr[indexPath.row].name
//            return cell
//
//        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentShowThreeCell", for: indexPath) as! ContentShowThreeCell
//        cell.collectionDataArr = ["1","2","3","4","1","2","3","4","1"]
        cell.dataModel = dataArr[indexPath.section - 1]
        return cell
        
    }
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section == 4 {
//            let dataModel = dataArr[section - 1]
//            let v = SingSongSectionHeader.loadFromNib()
//            let sectionModel = dataArr[section - 1]
//            v.lbTitle.set_text = sectionModel.name
//            v.btnAll.addAction {
//                VCRouter.toContentSubVC(clientId: XBUserManager.device_Id, modouleId: dataModel.id, navTitle: dataModel.name)
//            }
//            return v
//        }
//        return nil
//    }
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 4 {
//            return 55
//        }
//        return XBMin
//    }
//    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == 4 {
            let sectionModel = dataArr[indexPath.section - 1]
            let contentArr = sectionModel.contents ?? []
            let model = contentArr[indexPath.row]
            if model.albumType == 2 {
                VCRouter.toContentSubVC(clientId: XBUserManager.device_Id, albumId: model.id ?? "", navTitle: model.name)
            }else {
                VCRouter.toContentSingsVC(clientId: XBUserManager.device_Id, albumId: model.id ?? "")
            }
        }
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //设置cell的显示动画为3D缩放
        //xy方向缩放的初始值为0.1
        cell.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1)
        //设置动画时间为0.25秒，xy方向缩放的最终值为1
        //        UIView.animateWithDuration(0.25, animations: {
        //            cell.layer.transform=CATransform3DMakeScale(1, 1, 1)
        //        })
        UIView.animate(withDuration: 0.5) {
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 滑动视图上移动画
        viewUpAnimationWihtScrollView(scrollView)

    }
    func viewUpAnimationWihtScrollView(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if (offsetY) > 182 {
            if (offsetY - 182) <= 44 {
                viewTopLayout.constant = -(offsetY - 182)
            }else {
                viewTopLayout.constant = -44
            }
        } else {
            viewTopLayout.constant = 0
        }
    }
}
