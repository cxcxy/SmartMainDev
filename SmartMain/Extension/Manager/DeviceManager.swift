//
//  DeviceManager.swift
//  SmartMain
//
//  Created by mac on 2018/9/21.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class DeviceManager: NSObject {
    
    /**
     *   判断当前设备是否在线  isCheckDevices: 检查是否绑定设备 ，isShowLoading： 是否弹出loading框
     */
    class func isOnline(isCheckDevices: Bool = true,closure: @escaping (Bool) -> ()) {
//        guard <#condition#> else {
//            <#statements#>
//        }
        if isCheckDevices {
            guard XBUserManager.device_Id != "" else {
                XBHud.showMsg("请先绑定设备")
                return
            }
        }
        EquimentViewModel().requestCheckEquipmentOnline(isShowLoading: false) { (onLine) in
            if onLine {
                closure(true)
            } else {
                closure(false)
            }
        }
    }
}
