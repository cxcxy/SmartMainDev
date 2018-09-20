//
//  LoginViewModel.swift
//  SmartMain
//
//  Created by mac on 2018/9/20.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class LoginViewModel: NSObject {
    /// 获取验证码接口
    func requestGetCode(mobile: String,closure: @escaping () -> ())  {
        guard mobile != "" else {
            XBHud.showMsg("请输入手机号")
            return
        }
        Net.requestWithTarget(.getAuthCode(mobile: mobile), successClosure: { (result, code, message) in
            XBHud.showMsg("发送验证码成功")
            closure()
        })
    }
    /// 注册第一步接口
    func requestRegister(mobile: String,code: String,pass: String,closure: @escaping () -> ())  {
        guard mobile != "" else {
            XBHud.showMsg("请输入手机号")
            return
        }
        guard code != "" else {
            XBHud.showMsg("请输入验证码")
            return
        }
        guard pass != "" else {
            XBHud.showMsg("请输入密码")
            return
        }
        var params_task = [String: Any]()
        params_task["username"] = mobile
        params_task["password"] = pass
        params_task["nickname"] = "际浩小达人"
        params_task["authCode"] = code
        Net.requestWithTarget(.register(req: params_task), successClosure: { (result, code, message) in
            if let str = result as? String {
                if str == "ok" {
                    XBHud.showMsg("注册成功")
                    closure()
                }else {
                    XBHud.showMsg("注册失败")
                }
            }
        })
    }
    /// 注册第二步接口 加入家庭
    func requestFamilyRegister(mobile: String,closure: @escaping () -> ())  {
        guard mobile != "" else {
            XBHud.showMsg("请输入手机号")
            return
        }
        var params_task = [String: Any]()
        params_task["openId"] = mobile
        params_task["type"] = 2
        params_task["nickname"] = "智伴小达人"
        Net.requestWithTarget(.familyRegister(req: params_task), successClosure: { (result, code, message) in
            if let str = result as? String {
                if str == "ok" {
                    XBHud.showMsg("注册成功")
                    closure()
                }else {
                    XBHud.showMsg("注册失败")
                }
            }
        })
    }
    /// 账号密码登录接口
    func requestPassLogin(mobile: String,code: String,closure: @escaping () -> ())  {
        guard mobile != "" else {
            XBHud.showMsg("请输入手机号")
            return
        }
        guard code != "" else {
            XBHud.showMsg("请输入密码")
            return
        }
        Net.requestWithTarget(.loginWithPass(mobile: mobile, password: code), successClosure: { (result, code, message) in
            if let jsonStr = result as? String {
                self.loginUserInfo(jsonResult: jsonStr,mobile: mobile,closure: closure)
            }
        })
    }
    /// 验证码登录接口
    func requestCodeLogin(mobile: String,code: String,closure: @escaping () -> ())  {
        guard mobile != "" else {
            XBHud.showMsg("请输入手机号")
            return
        }
        guard code != "" else {
            XBHud.showMsg("请输入验证码")
            return
        }
        Net.requestWithTarget(.login(mobile: mobile, code: code), successClosure: { (result, code, message) in
            if let jsonStr = result as? String {
                self.loginUserInfo(jsonResult: jsonStr,mobile: mobile,closure: closure)
            }
        })
    }
    /// 修改密码接口
    func requestResetPass(mobile: String,code: String,onePass: String,twoPass: String)  {
        guard mobile != "" else {
            XBHud.showMsg("请输入手机号")
            return
        }
        guard code != "" else {
            XBHud.showMsg("请输入验证码")
            return
        }
        guard onePass != "" else {
            XBHud.showMsg("请输入新密码")
            return
        }
        guard onePass == twoPass else {
            XBHud.showMsg("请两次输入密码一致")
            return
        }
        var params_task = [String: Any]()
        params_task["username"] = mobile
        params_task["password"] = onePass
        Net.requestWithTarget(.resetPassword(authCode: code,req: params_task), successClosure: { (result, code, message) in
            if let str = result as? String {
                if str == "ok" {
                    print("修改成功")
                    XBHud.showMsg("修改成功")
                }else {
                    XBHud.showMsg("修改失败")
                }
            }
            print(result)
        })
    }
    func loginUserInfo(jsonResult: String, mobile: String,closure: @escaping () -> ())  {
        guard let status = jsonResult.json_Str()["status"].int else {
            return
        }
        guard status == 200 else {
            let message = jsonResult.json_Str()["message"].stringValue
            XBHud.showMsg(message)
            return
        }
        if let arr = jsonResult.json_Str()["result"]["deviceId"].arrayObject {
            if arr.count > 0 {
                XBUserManager.device_Id = arr[0] as! String
            }
        }
        XBUserManager.userName = mobile
        closure()
    }
}
extension String {
    func json_Str() -> JSON{
        return JSON.init(parseJSON: self)
    }
}
