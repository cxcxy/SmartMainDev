//
//  MeInfoVC.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/5.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class MeInfoVC: XBBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    override func setUI() {
        super.setUI()
        tableView.cellId_register("MeInfoHaderCell")
        tableView.cellId_register("MeInfoNameCell")
        request()
    }
    override func request() {
        super.request()
        Net.requestWithTarget(.getBabyInfo(deviceId: XBUserManager.device_Id), successClosure: { (result, code, message) in
            print(result)
        })
    }
    func updateInfo()  {
        var params_task = [String: Any]()
        
        params_task["deviceid"] = XBUserManager.device_Id
        params_task["babyname"] = ""
        params_task["headimgurl"] = ""
        params_task["sex"] = ""
        params_task["birthday"] = ""
        Net.requestWithTarget(.updateBabyInfo(req: params_task), successClosure: { (result, code, message) in
            print(result)
        })
        
    }
    func resetPassword()  {
        var params_task = [String: Any]()
        
        params_task["username"] = ""
        params_task["password"] = ""

        Net.requestWithTarget(.resetPassword(authCode: "", req: params_task), successClosure: { (result, code, message) in
            print(result)
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
extension MeInfoVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeInfoHaderCell", for: indexPath) as! MeInfoHaderCell
            
            return cell
        }
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeInfoNameCell", for: indexPath) as! MeInfoNameCell
            
            return cell
        }
        return UITableViewCell()
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = LoginViewController()
        self.pushVC(vc)
        //        VCRouter.toEquipmentSettingVC()
    }
    
}
