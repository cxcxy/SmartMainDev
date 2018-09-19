//
//  ResetPassViewController.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/19.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class ResetPassViewController: XBBaseViewController {

    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var tfTwoPass: UITextField!
    @IBOutlet weak var tfOnePass: UITextField!
    @IBOutlet weak var btnCode: UIButton!
    @IBOutlet weak var tfCode: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func setUI() {
        super.setUI()
        title = "重设密码"
        btnCode.radius_l()
        btnReset.radius_ll()
    }
    @IBAction func clickResetAction(_ sender: Any) {
        guard tfPhone.text != "" else {
            XBHud.showMsg("请输入手机号")
            return
        }
        guard tfCode.text != "" else {
            XBHud.showMsg("请输入验证码")
            return
        }
        guard tfOnePass.text != "" else {
            XBHud.showMsg("请输入新密码")
            return
        }
        guard tfOnePass.text == tfTwoPass.text else {
            XBHud.showMsg("请两次输入密码一致")
            return
        }
        var params_task = [String: Any]()
        params_task["username"] = tfPhone.text
        params_task["password"] = tfOnePass.text
        Net.requestWithTarget(.resetPassword(authCode: tfCode.text!,req: params_task), successClosure: { (result, code, message) in
            if let str = result as? String {
                if str == "ok" {
                    print("修改成功")
                    XBHud.showMsg("修改成功")
                }else {
                    XBHud.showMsg("修改失败")
                }
            }
            print(result)
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
}
