//
//  EquimentInfoVC.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/4.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class EquimentInfoVC: XBBaseTableViewController {
    var sourceArr:[String] = ["设备号","存储空间","固件版本"]
    var valueArr: [String] = []
    var equimentModel: EquipmentInfoModel! {
        didSet {
            let cardAvailable = (equimentModel.cardAvailable ?? 0).toString
            let cardTotal = (equimentModel.cardTotal ?? 0).toString
            let cardStr = cardAvailable + "/" + cardTotal
            self.valueArr = [equimentModel.id ?? "", cardStr, equimentModel.firmwareVersion ?? ""]
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func setUI() {
        super.setUI()
        title = "设备信息"
        tableView.cellId_register("EquipmentListCell")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension EquimentInfoVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return valueArr.count
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "EquipmentListCell", for: indexPath) as! EquipmentListCell
        cell.lbTitle.set_text = sourceArr[indexPath.row]
//        cell.lbNumber.set_text = valueArr[indexPath.row]
        return cell

        
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
