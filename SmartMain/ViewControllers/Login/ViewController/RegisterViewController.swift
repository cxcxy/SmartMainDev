//
//  RegisterViewController.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/5.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class RegisterViewController: XBBaseViewController {
//    @IBOutlet weak var viewPassword: UIView!
    
//    @IBOutlet weak var btnLogin: UIButton!
//    @IBOutlet weak var viewPhone: UIView!
    
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var thPassword: UITextField!
    @IBOutlet weak var tfCode: UITextField!
    @IBOutlet weak var btnCode: UIButton!
    
    @IBOutlet weak var viewPhoto: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "注册"
        self.currentNavigationNone = true
        // Do any additional setup after loading the view.
    }
    override func setUI() {
        super.setUI()
        view.backgroundColor = UIColor.white
        viewPhoto.roundView()


    }
    @IBAction func clickClearPhoneAction(_ sender: Any) {
        tfPhone.text = ""
    }
    @IBAction func clickClearPassAction(_ sender: Any) {
        thPassword.text = ""
    }
    func sendCodeWithBtnTimer()  {
        self.btnCode.startTimer(60, title: "获取验证码", mainBGColor: UIColor.white, mainTitleColor: UIColor.init(hexString: "707784")!, countBGColor: UIColor.white, countTitleColor: MGRgb(128, g: 128, b: 128), handle: nil)
    }
    @IBAction func clickSendCodeAction(_ sender: Any) {
       
        guard tfPhone.text != "" else {
             XBHud.showMsg("请输入手机号")
            return
        }
        Net.requestWithTarget(.getAuthCode(mobile: tfPhone.text!), successClosure: { (result, code, message) in
            XBHud.showMsg("发送验证码成功")
            self.sendCodeWithBtnTimer()
            print(result)
        })
    }
    @IBAction func clickRegisterAction(_ sender: Any) {
//        XBHud.showMsg("点击注册按钮")
        guard tfPhone.text != "" else {
            XBHud.showMsg("请输入手机号")
            return
        }
        guard thPassword.text != "" else {
            XBHud.showMsg("请输入密码")
            return
        }
        guard tfCode.text != "" else {
            XBHud.showMsg("请输入验证码")
            return
        }
        var params_task = [String: Any]()
        params_task["username"] = tfPhone.text
        params_task["password"] = thPassword.text
        params_task["nickname"] = "智伴小达人"
        params_task["authCode"] = "1111"
        Net.requestWithTarget(.register(req: params_task), successClosure: { (result, code, message) in
            if let str = result as? String {
                if str == "ok" {
                    print("注册成功")
                    //                    XBHud.showMsg("注册成功")
                    self.requestFamilyRegister()
                }else {
                    XBHud.showMsg("注册失败")
                }
            }
            print(result)
        })
    }
    func requestFamilyRegister()  {
        var params_task = [String: Any]()
        params_task["openId"] = tfPhone.text
        params_task["type"] = 2
        params_task["nickname"] = "智伴小达人"
        Net.requestWithTarget(.familyRegister(req: params_task), successClosure: { (result, code, message) in
            if let str = result as? String {
                if str == "ok" {
                    print("注册成功")
                    XBHud.showMsg("注册成功")
                    self.popVC()
                    
                }else {
                    XBHud.showMsg("注册失败")
                }
            }
            print(result)
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
