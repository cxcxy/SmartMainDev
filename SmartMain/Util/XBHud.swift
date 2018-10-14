//
//  BSHud.swift
//  BSMaster
//
//  Created by 陈旭 on 2017/9/29.
//  Copyright © 2017年 陈旭. All rights reserved.
//

import Foundation
import SVProgressHUD

struct XBHud {
    
    // 提示框 SV
    static func showLoading(){
        
        DispatchQueue.main.async {
//            SVProgressHUD.setfa\\\
            SVProgressHUD.setFadeInAnimationDuration(0.0)
            SVProgressHUD.setFadeOutAnimationDuration(0.0)
            SVProgressHUD.setDefaultStyle(.custom)
            SVProgressHUD.setDefaultMaskType(.clear)
            SVProgressHUD.setForegroundColor(MGRgb(0, g: 0, b: 0, alpha: 0.2))
            SVProgressHUD.setBackgroundColor(MGRgb(0, g: 0, b: 0, alpha: 0.0))
            SVProgressHUD.show()
            
        }
        
    }
    
    
    // 消失提示框
    static func dismiss(){
        DispatchQueue.main.async {
            
            SVProgressHUD.dismiss()
            
        }
    }
    
    
    // 提示语
    static func showMsg(_ message:String?){
        DispatchQueue.main.async {
            
            configSVHud()
            let msg = message ?? "网络错误"
            SVProgressHUD.showText(withStatus: msg)
        }
    }
    // 提示语
    static func showConfigNetMsg(){
        DispatchQueue.main.async {
            
//            configSVHud(5.0)
            SVProgressHUD.setBackgroundColor(UIColor.darkGray)
            SVProgressHUD.setForegroundColor(UIColor.white)
            SVProgressHUD.show(withStatus: "配置中")
        }
    }
    // 错误
    static func showWarnMsg(_ message:String?){
        DispatchQueue.main.async {
            
            configErrorSVHud()
            let msg = message ?? ""
            SVProgressHUD.showInfo(withStatus: msg)
        }
    }
    
    static func configSVHud(_ timeInterval: TimeInterval = 1.0){
        
        SVProgressHUD.setFadeInAnimationDuration(0.0)
        SVProgressHUD.setFadeOutAnimationDuration(0.0)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setBackgroundColor(MGRgb(0, g: 0, b: 0, alpha: 0.8))
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setMinimumDismissTimeInterval(timeInterval)
        SVProgressHUD.setCornerRadius(10)
        
    }
    
    static func configErrorSVHud(){
        
        SVProgressHUD.setFadeInAnimationDuration(0.0)
        SVProgressHUD.setFadeOutAnimationDuration(0.0)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setDefaultStyle(.custom)
//        SVProgressHUD.setInfoImage(UIImage(named:"hud_error")!)
        SVProgressHUD.setImageViewSize(CGSize.init(width: 28, height: 28))
        SVProgressHUD.setBackgroundColor(MGRgb(0, g: 0, b: 0, alpha: 0.8))
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setMinimumDismissTimeInterval(1.5)
        
    }
    
}
