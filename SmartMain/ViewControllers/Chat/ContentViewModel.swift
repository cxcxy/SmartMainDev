//
//  ContentViewModel.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/27.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class ContentViewModel: NSObject {
    /// 云端资源在线点播
    func requestOnlineSing(openId: String,trackId: String,deviceId: String,closure: @escaping () -> ())  {

        Net.requestWithTarget(.onlineSing(openId: openId, trackId: trackId, deviceId: deviceId), successClosure: { (result, code, message) in
            if let str = result as? String {
                if str == "0" {
                    XBHud.showMsg("点播成功")
                }else if str == "1"{
                    XBHud.showMsg("设备不在线")
                }else if str == "2"{
                    XBHud.showMsg("你没有绑定设备")
                }
                closure()
            }
        })
    }
}
