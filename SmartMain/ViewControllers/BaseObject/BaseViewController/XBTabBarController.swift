//
//  XBTabBarController.swift
//  XBShinkansen
//
//  Created by mac on 2018/5/25.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit
let tabBackColor    = UIColor(hexString: "#FFFFFF")!

struct XBColor {
    
    static let tab_select           = "00BCEB".hexColor
    static let tab_defalut          = "787878".hexColor
    static let orange       = "FFD444".hexColor
    static let black        = "202020".hexColor
    static let blackLight   = "000000".hexColor
    
}
extension String {
    var hexColor: UIColor {
        let hex = trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return .clear
        }
        
        return UIKit.UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
class XBTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK:Private Method
    func setViewControllers(){
        
        self.view.backgroundColor   = tabBackColor
        self.tabBar.backgroundColor = UIColor(hexString: "#FFFFFF")
        self.tabBar.barTintColor    = tabBackColor
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.isTranslucent   = false
        self.tabBar.layer.borderWidth   = 0.5
        self.tabBar.layer.borderColor   = MGRgb(234, g: 234, b: 234).cgColor
        self.tabBar.clipsToBounds       = true
        self.delegate                   = self
        
//        let storys =        ["Home",    "Found",       "HotStyle",        "Brand",     "User"      ]
        let images          =           ["tab_grayTransact","tab_grayPurse","tab_grayOrder","tab_grayMe"]
        let images_select   =           ["tab_transact","tab_purse","tab_order","tab_me"]
        let imagesTitle     =           ["设备", "内容", "微聊", "宝宝"]
        
//        let mainVC1 = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainViewController") as! XBBaseViewController
        let mainVC2 = ContentMainVC()
        let mainVC3 = ChatMainViewController()
        let mainVC1 = EquipmentVC.init(style: .grouped)
        let mainVC4 = MeViewController()
        /// 初始化 tabbar 下标对应的 vc
        let viewContrllers:[XBBaseViewController] = [mainVC1,mainVC2, mainVC3, mainVC4]
        
        var viewContrllers_nav:[XBBaseNavigation]     = []

        for (index, vc) in viewContrllers.enumerated(){
            let nav = XBBaseNavigation.init(rootViewController: vc)
            nav.tabBarItem.image             = UIImage(named:images[index])?.withRenderingMode(.alwaysOriginal)
            nav.tabBarItem.selectedImage     = UIImage(named:images_select[index])?.withRenderingMode(.alwaysOriginal)
            nav.tabBarItem.title             = imagesTitle[index]
            nav.tabBarItem.imageInsets       = UIEdgeInsetsMake(-1, 0, 1, 0)
            nav.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)
            
            viewContrllers_nav.append(nav)
        }
        self.viewControllers = viewContrllers_nav
        self.selectedIndex   = 0
        configTabBar()
    }
    func configTabBar() {
        let items = self.tabBar.items
        for item in items! as [UITabBarItem] {
            
            let dic_corlor   = NSDictionary(object: XBColor.tab_defalut,
                                            forKey: NSAttributedStringKey.foregroundColor as NSCopying)
            
            let dic_selected = NSDictionary(object: XBColor.tab_select,
                                            forKey: NSAttributedStringKey.foregroundColor as NSCopying)
            
            item.setTitleTextAttributes(dic_selected as? [NSAttributedStringKey : AnyObject],
                                        for: UIControlState.selected)
            
            
            item.setTitleTextAttributes(dic_corlor as? [NSAttributedStringKey : AnyObject],
                                        for: UIControlState.normal)
        }
    }
    
    
}


extension XBTabBarController: UITabBarControllerDelegate{
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        
    }
    
    //    //将要点击
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let controllers = tabBarController.viewControllers
        let index = controllers?.index(of: viewController)
        
        return true
    }

}
