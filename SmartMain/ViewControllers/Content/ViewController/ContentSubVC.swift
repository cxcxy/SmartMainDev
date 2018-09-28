//
//  ContentSubVC.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/4.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class ContentSubVC: XBBaseTableViewController {
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

        tableView.cellId_register("ContentSubShowCell")
        self.cofigMjHeader()
        request()
    }
    override func request() {
        super.request()
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
                    self.cofigMjFooter()
                }
                self.dataArr += arr
                self.refreshStatus(status: arr.checkRefreshStatus(self.pageIndex))
                self.tableView.reloadData()
                self.starAnimationWithTableView(tableView: self.tableView)
            }
        })
        
    }
    func starAnimationWithTableView(tableView: UITableView) {
//        table
        TableViewAnimationKit.show(with: .alpha, tableView: tableView)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension ContentSubVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentSubShowCell", for: indexPath) as! ContentSubShowCell
        cell.lbTitle.set_text = dataArr[indexPath.section].name
        cell.imgIcon.set_Img_Url(dataArr[indexPath.section].imgSmall)
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        VCRouter.toContentSubVC()
        let model = dataArr[indexPath.section]
        if model.albumType == 2 {
            VCRouter.toContentSubVC(clientId: XBUserManager.device_Id, albumId: model.id ?? "", navTitle: model.name)
        }else {
            VCRouter.toContentSingsVC(clientId: XBUserManager.device_Id, albumId: model.id ?? "")
        }
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
//    //设置cell的显示动画
//    func tableView(tableView: UITableView!, willDisplayCell cell: UITableViewCell!,
//                   forRowAtIndexPath indexPath: NSIndexPath!){
//
//    }
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        //设置cell的显示动画为3D缩放
//        //xy方向缩放的初始值为0.1
//        cell.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1)
//        //设置动画时间为0.25秒，xy方向缩放的最终值为1
//        UIView.animate(withDuration: 0.25, animations: {
//            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
//        })
//    }
}
