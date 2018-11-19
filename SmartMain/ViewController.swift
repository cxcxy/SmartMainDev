//
//  ViewController.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/3.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class ViewController: XBBaseViewController {

    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setUI() {
        super.setUI()
        self.currentNavigationHidden = true
        view.backgroundColor = viewColor
        btnLogin.setCornerRadius(radius: 20)
        btnRegister.setCornerRadius(radius: 20)
//        btnRegister.addBorder(width: 2, color: UIColor.init(hexString: "008C48")! )
    }
    @IBAction func clickLoginAction(_ sender: Any) {

        let vc = LoginViewController()
        self.pushVC(vc)
    }
    @IBAction func clickRegisterAction(_ sender: Any) {
            let vc = RegisterViewController()
            self.pushVC(vc)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

