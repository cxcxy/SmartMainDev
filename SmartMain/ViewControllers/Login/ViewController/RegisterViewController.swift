//
//  RegisterViewController.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/5.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class RegisterViewController: XBBaseViewController {
    
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var thPassword: UITextField!
    @IBOutlet weak var tfCode: UITextField!
    @IBOutlet weak var btnCode: UIButton!
    var viewModel = LoginViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "手机号注册"
    }
    override func setUI() {
        super.setUI()
        view.backgroundColor = UIColor.white
        btnCode.radius_l()
        btnRegister.radius_ll()

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
        viewModel.requestGetCode(mobile: tfPhone.text!) {
            self.sendCodeWithBtnTimer()
        }
    }
    @IBAction func clickRegisterAction(_ sender: Any) {
//        let vc = SetInfoViewController()
//        self.pushVC(vc)
        viewModel.requestRegister(mobile: tfPhone.text!, code: tfCode.text!, pass: thPassword.text!) {
            
            let vc = SetInfoViewController()
            vc.setInfoType = .setUserInfo
            self.pushVC(vc)
//            self.popVC()
        }
    }
    func requestFamilyRegister()  {
        viewModel.requestFamilyRegister(mobile: tfPhone.text!) {
            self.popVC()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
