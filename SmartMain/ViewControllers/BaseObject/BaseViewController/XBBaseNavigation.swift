//
//  XBBaseNavigation.swift
//  BSMaster
//
//  Created by 陈旭 on 2017/9/29.
//  Copyright © 2017年 陈旭. All rights reserved.
//

import UIKit

class XBBaseNavigation: UINavigationController,UIGestureRecognizerDelegate {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        interactivePopGestureRecognizer?.delegate   = self   // 使用系统返回手势
        // 修改隐藏导航栏“返回”字体
        let appearance = UIBarButtonItem.appearance()
        appearance.setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: 0.0, vertical: 0.0), for: .default)

        self.navigationBar.barTintColor = XBNavColor // 统一 导航条背景色
         navigationBar.isTranslucent                 = false // 取消半透明效果
        
        self.navigationBar.tintColor = UIColor.white // 统一 导航条上面字体的颜色
//
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18.0)];

        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
    }
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.viewControllers.count <= 1 {
            return false
        }
        return true
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer.isKind(of: UIScreenEdgePanGestureRecognizer.classForCoder())
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {// 如果大于 0 说明是第二层页面
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: true)
    }
    
    
}
