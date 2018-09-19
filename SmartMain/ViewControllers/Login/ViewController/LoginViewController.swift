//
//  LoginViewController.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/5.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class LoginViewController: XBBaseViewController {
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var btnSendCode: UIButton!
    
    @IBOutlet weak var btnCode: UIButton!
    @IBOutlet weak var tfCode: UITextField!
    @IBOutlet weak var viewCode: IQPreviousNextView!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var viewPhoto: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "登录"
        self.currentNavigationNone = true
    }
    override func setUI() {
        super.setUI()
        viewPassword.isHidden = false
        viewCode.isHidden = true
        view.backgroundColor = UIColor.white
        viewPhoto.roundView()
        viewPhone.setCornerRadius(radius: 10)
        viewPassword.setCornerRadius(radius: 10)
        viewPhone.addBorder(width: 0.5, color: UIColor.darkGray)
        viewPassword.addBorder(width: 0.5, color: UIColor.darkGray)
        btnLogin.setCornerRadius(radius: 10)
        btnLogin.addBorder(width: 0.5, color: UIColor.darkGray)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func clickForgetAction(_ sender: Any) {
        XBHud.showMsg("忘记密码")

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
    func sendCodeWithBtnTimer()  {
        self.btnSendCode.startTimer(60, title: "获取验证码", mainBGColor: UIColor.white, mainTitleColor: UIColor.init(hexString: "707784")!, countBGColor: UIColor.white, countTitleColor: MGRgb(128, g: 128, b: 128), handle: nil)
    }
    @IBAction func clickRegisterAction(_ sender: Any) {
//        let vc = RegisterViewController()
//        self.pushVC(vc)
        btnCode.isSelected = !btnCode.isSelected
        viewPassword.isHidden = btnCode.isSelected
        viewCode.isHidden = !btnCode.isSelected
        
    }

    @IBAction func clickResetAction(_ sender: Any) {
        self.tfPhone.text = ""
    }
    
    @IBAction func clicResetPassAction(_ sender: Any) {
        tfPassword.text = ""
    }
    lazy var popWindow:UIWindow = {
        let w = UIApplication.shared.delegate as! AppDelegate
        return w.window!
    }()
    @IBAction func clickLoginAction(_ sender: Any) {
        if tfPhone.text! == "" {
            XBHud.showMsg("请输入手机号")
            return
        }
        self.btnCode.isSelected ? requestAuthCodeLogin() : requestPasswordLogin()

    }
    func requestPasswordLogin()  {
        if tfPassword.text! == "" {
            XBHud.showMsg("请输入手机号")
            return
        }
        Net.requestWithTarget(.loginWithPass(mobile: tfPhone.text!, password: tfPassword.text!), successClosure: { (result, code, message) in
            if let jsonStr = result as? String {
                self.loginUserInfo(jsonResult: jsonStr)
            }
        })
    }
    func requestAuthCodeLogin()  {
        Net.requestWithTarget(.login(mobile: tfPhone.text!, code: "1111"), successClosure: { (result, code, message) in
            if let jsonStr = result as? String {
                self.loginUserInfo(jsonResult: jsonStr)
            }
        })
    }
    func loginUserInfo(jsonResult: String)  {
        guard let status = jsonResult.json_Str()["status"].int else {
            return
        }
        guard status == 200 else {
            let message = jsonResult.json_Str()["message"].stringValue
            XBHud.showMsg(message)
            return
        }
        if let arr = jsonResult.json_Str()["result"]["deviceId"].arrayObject {
            if arr.count > 0 {
                XBUserManager.device_Id = arr[0] as! String
            }
        }
        XBUserManager.userName = self.tfPhone.text!
        let vc = XBTabBarController()
        self.popWindow.rootViewController = vc
    }
}
extension String {
    func json_Str() -> JSON{
        return JSON.init(parseJSON: self)
    }
}
