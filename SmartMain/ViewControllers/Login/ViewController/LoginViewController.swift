//
//  LoginViewController.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/5.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
class BoaderView: UIView {
    //code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    //xib
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    func setupSubviews()  {
        self.setCornerRadius(radius: 20)
        self.addBorder(width: 0.5, color: viewColor)
    }
}
class LoginViewController: XBBaseViewController {
    @IBOutlet weak var viewPassword: XBTextView!
    @IBOutlet weak var btnSendCode: UIButton!
    
    @IBOutlet weak var btnCode: UIButton!
    @IBOutlet weak var tfCode: UITextField!
    @IBOutlet weak var viewCode: IQPreviousNextView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var viewPhone: XBTextView!

    var viewModel = LoginViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "手机号登录"
    }
    override func setUI() {
        super.setUI()
        viewPassword.isHidden = false
        viewCode.isHidden = true
        view.backgroundColor = UIColor.white
        btnLogin.radius_ll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func clickForgetAction(_ sender: Any) {
        let vc = ResetPassViewController()
        self.pushVC(vc)
    }
    
    @IBAction func clickSendCodeAction(_ sender: Any) {
//        viewModel.requestGetCode(mobile: viewPhone.text!) { [weak self] in
//            guard let `self` = self else { return }
//            self.sendCodeWithBtnTimer()
//        }
    }
    func sendCodeWithBtnTimer()  {
        self.btnSendCode.startTimer(60, title: "获取验证码", mainBGColor: UIColor.white, mainTitleColor: UIColor.init(hexString: "707784")!, countBGColor: UIColor.white, countTitleColor: MGRgb(128, g: 128, b: 128), handle: nil)
    }
    @IBAction func clickRegisterAction(_ sender: Any) {
        btnCode.isSelected = !btnCode.isSelected
        viewPassword.isHidden = btnCode.isSelected
        viewCode.isHidden = !btnCode.isSelected
    }

    @IBAction func clickResetAction(_ sender: Any) {
        self.viewPhone.text = ""
    }
    
    @IBAction func clicResetPassAction(_ sender: Any) {
        viewPassword.text = ""
    }
    lazy var popWindow:UIWindow = {
        let w = UIApplication.shared.delegate as! AppDelegate
        return w.window!
    }()
    @IBAction func clickLoginAction(_ sender: Any) {
        if viewPhone.text! == "" {
            XBHud.showMsg("请输入手机号")
            return
        }
        if !viewPhone.text!.validateMobile() {
            XBHud.showMsg("请输入正确手机号")
            return
        }
        requestPasswordLogin()
//        self.btnCode.isSelected ? requestAuthCodeLogin() : requestPasswordLogin()

    }
    func requestPasswordLogin()  {
        viewModel.requestPassLogin(mobile: viewPhone.text!, code: viewPassword.text!) { [weak self] in
            guard let `self` = self else { return }
            XBHud.showMsg("登录成功")
            XBDelay.start(delay: 0.5, closure: {
                 self.toHome()
            })
           
        }
    }
    func requestAuthCodeLogin()  {
//        viewModel.requestCodeLogin(mobile: viewPhone.text!, code: "1111") { [weak self] in
//            guard let `self` = self else { return }
//            self.toHome()
//        }
    }
    func toHome()  {

        let mainViewController   = ContentMainVC()
        let nav = XBBaseNavigation.init(rootViewController: mainViewController)
        self.popWindow.rootViewController = nav
    }
}
