//
//  ViewController.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/3.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class ViewController: XBBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.currentNavigationHidden = true
   
    }
    @IBAction func clickLoginAction(_ sender: Any) {
//        let vc = XBTabBarController()
//        self.pushVC(vc)
        let vc = LoginViewController()
        self.pushVC(vc)
    }
    @IBAction func clickRegisterAction(_ sender: Any) {
        //        let vc = XBTabBarController()
        //        self.pushVC(vc)
            let vc = RegisterViewController()
            self.pushVC(vc)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

