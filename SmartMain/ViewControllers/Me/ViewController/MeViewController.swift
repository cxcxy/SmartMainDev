//
//  MeViewController.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/4.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class MeViewController: XBBaseViewController {
    @IBOutlet weak var viewInfo: UIView!
    
    @IBOutlet weak var lbNickName: UILabel!
    @IBOutlet weak var viewAbout: UIView!
    @IBOutlet weak var btnLoginOut: UIButton!
    @IBOutlet weak var viewCenter: UIView!
    @IBOutlet weak var viewPhoto: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.isTranslucent = true
    }
    override func setUI() {
        super.setUI()
        self.title = "宝宝"
        viewCenter.setCornerRadius(radius: 5)
        btnLoginOut.setCornerRadius(radius: 15)
        self.currentNavigationNone = true
        viewPhoto.roundView()
        lbNickName.set_text = user_defaults.get(for: .userName)
        viewInfo.addTapGesture { [weak self](sender) in
            let vc = MeInfoVC()
            self?.pushVC(vc)
        }
        viewAbout.addTapGesture {[weak self] (sender) in
            let vc = AboutMeVC()
            self?.pushVC(vc)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    lazy var popWindow:UIWindow = {
        let w = UIApplication.shared.delegate as! AppDelegate
        return w.window!
    }()

    @IBAction func clickLoginOutAction(_ sender: Any) {
        user_defaults.clear(.userName)
        user_defaults.clear(.deviceId)
        let sv = UIStoryboard.getVC("Main", identifier:"LoginNav") as! XBBaseNavigation
        popWindow.rootViewController = sv
    }

}
