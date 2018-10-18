//
//  AppDelegate.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/3.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var lunchView: XBLaunchView!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window?.makeKeyAndVisible()
        ChatManager.share.init_ChatMessage(application,
                                           launchOptions)
        if user_defaults.has(.userName) {
            print("登录过")
            _ = ScoketMQTTManager.share
            self.configDrawerController()
            loginEMClient()
            
        }else {
            print("未登录过")
            let sv = UIStoryboard.getVC("Main", identifier:"LoginNav") as! XBBaseNavigation
            window?.rootViewController = sv
        }
        
        IQKeyboardManager.shared.enable = true
        if (launchOptions == nil) {
//            showADLaunchView()
            requestCheakVersion()
        }

        return true
    }
    // 检查更新 接口
    func requestCheakVersion() {
        XBUpdateVersionManager.checkUpdateVersion { (versionType,versionModel) in
            
            guard let iosUrl = versionModel.iosurl else {
                return
            }
            guard let urlString = URL.init(string: iosUrl) else{
                return
            }
            if versionType == .oldVersion {
                let v = XBUpdateVersionView.loadFromNib()
                v.versionType   = versionType
                v.versionModel  = versionModel
                v.initOrigin()
                v.clickActionTouchBlock = {(_ type: String) -> Void in
                    if (type == "update") {
                        
                        UIApplication.shared.openURL(urlString)
                        
                    }
                }
                v.show()
            }
        }
    }
    //MARK: 弹出广告页
    func showADLaunchView()  {
        
        lunchView       = XBLaunchView.loadFromNib()
        lunchView.frame =  CGRect(x: 0, y: 0, width: MGScreenWidth, height: MGScreenHeight)
        window?.addSubview(lunchView)
        window?.bringSubview(toFront: lunchView)
        
    }
    func configDrawerController()  {
        let mainViewController   = ContentMainVC()
//        let drawerViewController = DrawerViewController()
//        let drawerController     = KYDrawerController(drawerDirection: .left, drawerWidth: 300)
//        drawerController.screenEdgePanGestureEnabled = false
        let nav = XBBaseNavigation.init(rootViewController: mainViewController)
//        drawerController.mainViewController = nav
//        drawerController.drawerViewController = drawerViewController
        
        window?.rootViewController = nav
    }
    func loginEMClient()  {
        
        ChatManager.share.loginEMClient(username: XBUserManager.userName, password: XBUserManager.password)

    }
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        print("环信注册deviceToken")
        EMClient.shared()?.registerForRemoteNotifications(withDeviceToken: deviceToken, completion: { (error) in
            print(error ?? "环信注册deviceToken 成功")
        })
    }
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
    }
//    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
//        application.registerForRemoteNotifications()
//    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
//            [[EaseSDKHelper shareHelper] hyphenateApplication:application didReceiveRemoteNotification:userInfo];
        EaseSDKHelper.share()?.hyphenateApplication(application, didReceiveRemoteNotification: userInfo)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    // 进入后台
    func applicationDidEnterBackground(_ application: UIApplication) {
        EMClient.shared().applicationDidEnterBackground(application)
    }
    // 从后台打开
    func applicationWillEnterForeground(_ application: UIApplication) {
        EMClient.shared().applicationWillEnterForeground(application)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

