//
//  EquimentViewModel.swift
//  SmartMain
//
//  Created by mac on 2018/9/27.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

class EquimentViewModel: NSObject {
    /// 获取配置网络音频
    func requestGetVoice(ssid: String,password: String,openId: String,deviceId: String,closure: @escaping (String) -> ())  {
        guard ssid != "" else {
            XBHud.showMsg("请输入WIFI名称")
            return
        }
        guard password != "" else {
            XBHud.showMsg("请输入WIFI密码")
            return
        }
        var params_task = [String: Any]()
        params_task["ssid"] = ssid
        params_task["password"] = password
        params_task["openId"] = openId
        params_task["deviceId"] = deviceId
        Net.requestWithTarget(.getNetVoice(req: params_task), successClosure: { (result, code, message) in
            if let str = result as? String {
                closure(str)
            }
        })
    }
    /// 检查设备是否在线
    func requestCheckEquipmentOnline(closure: @escaping (Bool) -> ())  {
        Net.requestWithTarget(.getEquimentInfo(deviceId: XBUserManager.device_Id), successClosure: { (result, code, message) in
            if let model = Mapper<EquipmentInfoModel>().map(JSONString: result as! String) {
                
                if model.online == 1 {
                    print("当前设备在线")
                    XBUserManager.online = true
                    closure(true)
                }else {
                    print("当前设备不在线")
                    XBUserManager.online = false
                    closure(false)
                }
                
            }else {
                print("当前设备不在线")
                XBUserManager.online = false
                closure(false)
            }
        })
    }
}
