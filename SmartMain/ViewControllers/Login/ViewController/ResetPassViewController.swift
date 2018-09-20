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
    var viewModel = LoginViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setUI() {
        super.setUI()
        title = "重设密码"
        btnCode.radius_l()
        btnReset.radius_ll()
    }
    @IBAction func clickResetAction(_ sender: Any) {
        viewModel.requestResetPass(mobile: tfPhone.text!,
                                   code: tfCode.text!,
                                   onePass: tfOnePass.text!,
                                   twoPass: tfOnePass.text!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
