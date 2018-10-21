//
//  ContentVC.swift
//  SmartMain
//
//  Created by mac on 2018/9/4.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class ResourceAllVC: XBBaseTableViewController {
    

    
    var dataArr: [ResourceAllModel] = []
    var dataTrackArr: [EquipmentModel] = []
    var viewModel = ContentViewModel()
      var bannersArr: [ResourceBannerModel] = []
    var hotArr: [ResourceTopListModel] = []
    var eliteArr: [ResourceTopListModel] = []
    var latestArr: [ResourceTopListModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 80, right: 0)
        
        tableView.cellId_register("ContentHeaderCell")
        tableView.cellId_register("ContentShowCell")
        tableView.cellId_register("ContentShowThreeCell")
        tableView.cellId_register("ContentScrollCell")
        tableView.cellId_register("ContentSingSongCell")
        
        tableView.mj_header = self.mj_header
    }
    override func setUI() {
        super.setUI()
        request()
     
    }
    override func request() {
        super.request()

        
        
        var params_HOTTEST = [String: Any]()
        params_HOTTEST["page"]             = 1
        params_HOTTEST["size"]             = 9
        params_HOTTEST["type"]            = "HOTTEST"
        var params_ELITE = [String: Any]()
        params_ELITE["page"]             = 1
        params_ELITE["size"]             = 9
        params_ELITE["type"]            = "ELITE"
        var params_LATEST = [String: Any]()
        params_LATEST["page"]             = 1
        params_LATEST["size"]             = 9
        params_LATEST["type"]            = "LATEST"
        let request_class: Observable<([ResourceAllModel],[ResourceBannerModel],[ResourceTopListModel],[ResourceTopListModel],[ResourceTopListModel])>
            = Observable.zip(
                viewModel.requestResourceAll(),
                viewModel.requestResourceBanners(),
                viewModel.requestResourceTopList(req: params_HOTTEST),
                viewModel.requestResourceTopList(req: params_ELITE),
                viewModel.requestResourceTopList(req: params_LATEST))
        
        request_class.subscribe(onNext: { [weak self](allArr,banners,hotArr,eliteArr,latestArr) in
            guard let `self` = self else { return }
            self.dataArr = allArr
            self.bannersArr = banners
            self.hotArr     = hotArr
            self.eliteArr   = eliteArr
            self.latestArr  = latestArr
            self.tableView.reloadData()
            }, onError: {[weak self] (error) in
                guard let `self` = self else { return }
                
        }).disposed(by: rx_disposeBag)
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
extension ResourceAllVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard dataArr.count > 0 else {
            return 0
        }
        return 5
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentHeaderCell", for: indexPath) as! ContentHeaderCell
            cell.dataArr = self.bannersArr
            return cell
        }
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentShowCell", for: indexPath) as! ContentShowCell
            cell.resourceArr    = self.dataArr
            cell.resourctType   = .tuling
            cell.lbTitle.set_text = "相关资源"
            
            return cell
        }
        if indexPath.section == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentShowThreeCell", for: indexPath) as! ContentShowThreeCell
            
            cell.resourceTopListArr = self.hotArr
            cell.lbTitle.set_text = "最热专辑"
            cell.topTypeString = "HOTTEST"
           cell.resourctType = .tuling
            return cell
        }
        if indexPath.section == 3 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentShowThreeCell", for: indexPath) as! ContentShowThreeCell
            cell.resourceTopListArr = self.eliteArr
            cell.resourctType = .tuling
            cell.lbTitle.set_text = "精品专辑"
            cell.topTypeString = "ELITE"
            return cell
        }
        if indexPath.section == 4 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentShowThreeCell", for: indexPath) as! ContentShowThreeCell
            cell.resourceTopListArr = self.latestArr
            cell.resourctType = .tuling
            cell.lbTitle.set_text = "最新专辑"
            cell.topTypeString = "LATEST"
            return cell
            
        }
        return UITableViewCell()
        
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section == 4 {
//            let dataModel = dataArr[section - 1]
//            let v = SingSongSectionHeader.loadFromNib()
//            let sectionModel = dataArr[section - 1]
//            v.lbTitle.set_text = sectionModel.name
//
//            return v
//        }
        return nil
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 4 {
//            return 55
//        }
        return XBMin
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if indexPath.section == 4 {
//            let sectionModel = dataArr[indexPath.section - 1]
//            let contentArr = sectionModel.contents ?? []
//            let model = contentArr[indexPath.row]
//            if model.albumType == 2 {
//                VCRouter.toContentSubVC(clientId: XBUserManager.device_Id, albumId: model.id ?? "", navTitle: model.name)
//            }else {
//                VCRouter.toContentSingsVC(clientId: XBUserManager.device_Id, albumId: model.id ?? "")
//            }
//        }
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
    
}
