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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if user_defaults.has(.userName) {
            print("登录过")
            let vc = XBTabBarController()
            window?.rootViewController = vc
            let options = EMOptions.init(appkey: "1188180613253110#o9tm3wzgkwwrmakc5gddip54t5g")
            EMClient.shared().initializeSDK(with: options)
            EaseSDKHelper.share().hyphenateApplication(application, didFinishLaunchingWithOptions: launchOptions, appkey: "1188180613253110#o9tm3wzgkwwrmakc5gddip54t5g", apnsCertName: "", otherConfig: [kSDKConfigEnableConsoleLogger: false])
            loginEMClient()
        }else {
            print("未登录过")
            let sv = UIStoryboard.getVC("Main", identifier:"LoginNav") as! XBBaseNavigation
            window?.rootViewController = sv
        }
        _ = ScoketMQTTManager.share
        IQKeyboardManager.sharedManager().enable = true
        return true
    }
    func loginEMClient()  {

        EMClient.shared().login(withUsername: XBUserManager.userName, password: "123456") { (aUserName, aError) in
            if (aError == nil) {
                print("登录成功",aUserName)
            }else {
                print("登录失败")
            }
        }
    }
    func applicationWillResignActive(_ application: UIApplication) {
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

