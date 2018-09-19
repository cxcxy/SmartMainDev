//
//  UIViewController+Extension.swift
//  BSMaster
//
//  Created by 陈旭 on 2017/9/29.
//  Copyright © 2017年 陈旭. All rights reserved.
//

import Foundation
extension UIViewController {
    /// 反射拿到类名
    func identifier() -> String {
        let mirror = Mirror(reflecting: self)
        return String(describing: mirror.subjectType)
    }
    // 跳转蒙版VC
    func presentToMaskViewController(viewControllerToPresent:UIViewController,completion: (() -> Swift.Void)? = nil) {
        
        viewControllerToPresent.providesPresentationContextTransitionStyle = true
        
        viewControllerToPresent.definesPresentationContext = true
        
        viewControllerToPresent.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//        DispatchQueue.main.async {
            self.present(viewControllerToPresent, animated: false, completion: completion)
//        }
        
        
    }
    // //返回指定页面2
    func popToViewController(classVC:UIViewController){
        if let navController = navigationController {
            for controller: UIViewController in navController.viewControllers {
                if controller.className == classVC.className {
                    navigationController?.popToViewController(controller, animated: true)
                }
            }
        }
    }
    
}
extension UIViewController{
    
    func makeCustomerNavigationItem(_ title:String!,left:Bool,isOffset:Bool = false,handler:NavigationItemHandler?){
        //        self.navigationItem.leftBarButtonItems = nil
        let item = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(UIViewController.itemClick(_:)))
        
        item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14.0)], for: .normal)
        
        if let action = handler {
            ActionManager.sharedManager.actionDict[NSValue(nonretainedObject:item)] = action
        }
        if left{
            self.navigationItem.leftBarButtonItem = item
        }else{
            self.navigationItem.rightBarButtonItem = item
        }
        if isOffset {
            if let left = self.navigationItem.leftBarButtonItem{
                let offset = UIDevice.deviceType.rawValue > 3 ? -20 : -16
                left.imageInsets = UIEdgeInsetsMake(0,CGFloat(offset),0, 0);
            }
        }
        
    }
    
    func makeCustomerImageNavigationItem(_ image:String!,left:Bool,isOffset:Bool = false,handler:@escaping NavigationItemHandler){
        let image = UIImage(named:image)
        let item = UIBarButtonItem(image:image?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(UIViewController.itemClick(_:)))
        ActionManager.sharedManager.actionDict[NSValue(nonretainedObject:item)] = handler
        let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceItem.width = -10
        
        if left{
            self.navigationItem.leftBarButtonItem = item
            //            self.navigationItem.leftBarButtonItems = [spaceItem,item]
        }else{
            self.navigationItem.rightBarButtonItem = item
        }
        
        if isOffset {
            if let left = self.navigationItem.leftBarButtonItem{
                let offset = UIDevice.deviceType.rawValue > 3 ? -20 : -16
                left.imageInsets = UIEdgeInsetsMake(0,CGFloat(offset),0, 0);
            }
        }else{
            if let left = self.navigationItem.rightBarButtonItem{
                let offset = UIDevice.deviceType.rawValue > 3 ? -20 : -16
                left.imageInsets = UIEdgeInsetsMake(0,CGFloat(offset),0, 0);
            }
        }
    }
    
    func makeBuyCarNavigationItem(_ carEntranceButton:UIButton, handler:@escaping NavigationItemHandler){
        
        
        let item = UIBarButtonItem(customView: carEntranceButton)
        
        carEntranceButton.addAction {
            #selector(UIViewController.itemClick(_:))
        }
        
        
        ActionManager.sharedManager.actionDict[NSValue(nonretainedObject:carEntranceButton)] = handler
        
        let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceItem.width = -10
        self.navigationItem.rightBarButtonItem = item
        self.navigationItem.rightBarButtonItems = [spaceItem,item]
        
        if let left = self.navigationItem.rightBarButtonItem{
            let offset = UIDevice.deviceType.rawValue > 3 ? -20 : -16
            left.imageInsets = UIEdgeInsetsMake(0,CGFloat(offset),0, 8);
        }
        
    }
    
    func makeRightNavigationItem(_ navigationItem:UIView,left:Bool){
        
        let item = UIBarButtonItem(customView: navigationItem)
        
        let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceItem.width = 0
        
        if left{
            
            self.navigationItem.leftBarButtonItem = item
            self.navigationItem.leftBarButtonItems = [spaceItem,item]
            if let left = self.navigationItem.leftBarButtonItem{
                let offset = UIDevice.deviceType.rawValue > 3 ? -20 : -16
                left.imageInsets = UIEdgeInsetsMake(0,CGFloat(offset),0, 8);
            }
        }else{
            self.navigationItem.rightBarButtonItem = item
            self.navigationItem.rightBarButtonItems = [spaceItem,item]
            if let left = self.navigationItem.rightBarButtonItem{
                let offset = UIDevice.deviceType.rawValue > 3 ? -20 : -16
                left.imageInsets = UIEdgeInsetsMake(0,CGFloat(offset),0, 8);
            }
        }
        
    }
    
    
    @objc func itemClick(_ item:UIBarButtonItem){
        if let closure = ActionManager.sharedManager.actionDict[NSValue(nonretainedObject:item)]{
            closure()
        }
    }
    
    
    /**
     获取自己之前的视图
     
     - returns:
     */
    func forwardController() ->UIViewController?{
        let vcs = self.navigationController?.viewControllers
        if let controllers = vcs {
            let position =  controllers.index(of: self)
            return controllers[position! - 1]
        }
        return nil
    }
    
    func forwardControllerType(_ controller:AnyClass) -> Bool {
        if let v = forwardController(){
            if v.isKind(of: controller) {
                return true
            }
        }
        return false
    }
    
}
public extension UIStoryboard {
    /**
     根据stroyboard名称返回初始控制器
     
     - parameter name: 名称
     
     - returns: 初始控制器
     */
    class func initialViewController(_ name: String) -> UIViewController {
        let sb = UIStoryboard(name: name, bundle: nil)
        return sb.instantiateInitialViewController()!
    }
    
    /**
     根据stroyboard名称和标示符返回对应的控制器
     
     - parameter name:       名称
     - parameter identifier: 标示符
     
     - returns: 对应的控制器
     */
    class func getVC(_ name: String, identifier: String) -> UIViewController
    {
        let sb = UIStoryboard(name: name, bundle: nil)
        return sb.instantiateViewController(withIdentifier: identifier)
    }
    
    
    class func initNavVC(_ name: String, identifier: String) -> UINavigationController {
        let sb      = UIStoryboard(name: name, bundle: nil)
        let nav_vc  = UINavigationController.init(rootViewController: sb.instantiateViewController(withIdentifier: identifier))
        
        return nav_vc
    }
    
}
