//
//  GroupAddMemberController.swift
//  SmartMain
//
//  Created by mac on 2018/9/26.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class GroupAddMemberController: XBBaseViewController {
    var groupId: String?
    
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var viewInput: BoaderView!
    
    @IBOutlet weak var btnAdd: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func setUI() {
        super.setUI()
        title = "邀请群聊组成员"
        
//        viewInput.radius_ll()
//        viewInput.addBorder(width: <#T##CGFloat#>, color: <#T##UIColor#>)
        btnAdd.radius_ll()
    }
    @IBAction func clickAddAction(_ sender: Any) {
        guard tfPhone.text != "" else {
            XBHud.showMsg("请输入手机号")
            return
        }
        EMClient.shared().groupManager.addMembers([tfPhone.text!], toGroup: self.groupId ?? "", message: "") { (emGroup, error) in
            print("邀请成功",emGroup)
            Noti_post(.refreshGroupInfo)
            self.popVC()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
