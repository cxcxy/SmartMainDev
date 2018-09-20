//
//  SetInfoViewController.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/19.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class SetInfoViewController: XBBaseViewController {

    @IBOutlet weak var tfNick: UITextField!
    @IBOutlet weak var btnSure: UIButton!
    @IBOutlet weak var imgPhoto: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setUI() {
        super.setUI()
        self.title = "宝贝信息"
        view.backgroundColor = viewColor
        btnSure.radius_ll()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
