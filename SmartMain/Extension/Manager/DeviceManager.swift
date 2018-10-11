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
     *   判断当前设备是否在线
     */
    class func isOnline(closure: @escaping (Bool) -> ()) {
        EquimentViewModel().requestCheckEquipmentOnline { (onLine) in
            if onLine {
                closure(true)
            } else {
                closure(false)
            }
        }
    }
}
