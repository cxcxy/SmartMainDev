//
//  ContentSubNewController.swift
//  SmartMain
//
//  Created by mac on 2018/12/5.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class ContentSubNewController: XBBaseViewController {
    var clientId: String!
    var albumId: String?
    var modouleId: String?
    var dataArr: [ModulesConetentModel] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func setUI() {
        super.setUI()
        self.configTableView(tableView, register_cell: ["TrackListHomeCell"])
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
                    self.tableView.mj_footer = self.mj_footer
                    
                }
                self.dataArr += arr
                self.refreshStatus(status: arr.checkRefreshStatus(self.pageIndex))
                self.tableView.reloadData()
//                self.refreshCollectionViewStatus(status: arr.checkRefreshStatus(self.pageIndex))
//                self.collectionViewEndRefresh()
//                self.collectionView.reloadData()
            }
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ContentSubNewController {
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        return dataArr.count
    //    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArr.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackListHomeCell", for: indexPath) as! TrackListHomeCell
        
        let model = dataArr[indexPath.row]
        let totalStr = dataArr[indexPath.row].total ?? 0
        if totalStr > 0 {
            let count = "共" + totalStr.toString + "首"
            cell.lbTatal.isHidden = false
            cell.lbTatal.set_text = count
        }else {
            cell.lbTatal.isHidden = true
        }
        cell.imgIcon.backgroundColor = UIColor.white
        cell.imgIcon.set_Img_Url(model.imgSmall)
        cell.lbTitle.set_text = model.name
        
       
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArr[indexPath.row]
        if model.albumType == 2 {
            VCRouter.toContentSubVC(clientId: XBUserManager.device_Id, albumId: model.id ?? "", navTitle: model.name)
        }else {
            VCRouter.toContentSingsVC(clientId: XBUserManager.device_Id, albumId: model.id ?? "")
        }
    }
    
    //    // Header
    //    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //
    //        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? SMAllClassViewHeader ?? SMAllClassViewHeader(reuseIdentifier: "header")
    //         let trackCount = dataArr[section].trackCount ?? 0
    //        let count = "（" + trackCount.toString + "）"
    //        header.titleLabel.set_text = dataArr[section].name! + count
    //        header.section = section
    //        header.delegate = self
    //
    //        return header
    //
    //
    //    }
    //    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //        return 10
    //    }
    //    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    //        let v = UIView()
    //        v.frame = CGRect.init(x: 0, y: 0, w: tableView.w, h: 10)
    //        v.backgroundColor = UIColor.white
    //        return v
    //    }
    //    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 30
    //    }
}

