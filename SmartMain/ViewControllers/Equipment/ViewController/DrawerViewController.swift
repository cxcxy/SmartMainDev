//
//  DrawerViewController.swift
//  SmartMain
//
//  Created by mac on 2018/9/20.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
class DrawerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let closeButton    = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle("Close", for: UIControlState())
        closeButton.addTarget(self,
                              action: #selector(didTapCloseButton),
                              for: .touchUpInside
        )
        closeButton.sizeToFit()
        closeButton.setTitleColor(UIColor.blue, for: UIControlState())
        view.addSubview(closeButton)
        view.addConstraint(
            NSLayoutConstraint(
                item: closeButton,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: view,
                attribute: .centerX,
                multiplier: 1,
                constant: 0
            )
        )
        view.addConstraint(
            NSLayoutConstraint(
                item: closeButton,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: view,
                attribute: .centerY,
                multiplier: 1,
                constant: 0
            )
        )
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }
    @objc func didTapCloseButton(_ sender: UIButton) {
//        if let drawerController = parent as? KYDrawerController {
//            drawerController.setDrawerState(.closed, animated: true)
//        }
//        guard let drawerController = parent as? KYDrawerController,
//            let navController = drawerController.mainViewController as! XBBaseNavigation?
//            else { return }
//        drawerController.setDrawerState(.closed, animated: false)
        // Push onto the stack
        let vc = MeInfoVC()
//        self.pushVC(vc)
        self.cw_push(vc)
//        navController.pushViewController(vc, animated: true)
        

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
