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
    @IBOutlet weak var tfTwoPass: XBTextView!
    @IBOutlet weak var tfOnePass: XBTextView!
    @IBOutlet weak var btnCode: UIButton!
    @IBOutlet weak var tfCode: UITextField!
    @IBOutlet weak var tfPhone: XBTextView!
    var viewModel = LoginViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setUI() {
        super.setUI()
        title = "重置密码"
        btnCode.radius_l()
        btnReset.radius_ll()
    }
    @IBAction func clickResetAction(_ sender: Any) {
        viewModel.requestResetPass(mobile: tfPhone.text!,
                                   code: tfCode.text!,
                                   onePass: tfOnePass.text!,
                                   twoPass: tfTwoPass.text!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func sendCodeWithBtnTimer()  {
        self.btnCode.startTimer(60, title: "获取验证码",
                                mainBGColor: UIColor.init(hexString: "81C64E")!,
                                mainTitleColor: UIColor.white,
                                countBGColor: UIColor.white,
                                countTitleColor: MGRgb(128, g: 128, b: 128), handle: nil)
    }
    @IBAction func clickSendCodeAction(_ sender: Any) {
        viewModel.requestGetCode(mobile: tfPhone.text!,type: "reset") { (success) in
            if success {
                self.sendCodeWithBtnTimer()
            }
            
        }
    }
}
