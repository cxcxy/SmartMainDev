//
//  PMNetManager.swift
//  XBPMDev
//
//  Created by mac on 2018/3/28.
//  Copyright © 2018年 mac-cx. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper
import Moya
import Result

typealias FailClosure               = (_ errorMsg:String?) -> ()
typealias SuccessClosure            = (_ result:AnyObject, _ code: Int?,_ message: String?) ->()

let Net = XBNetManager.shared

enum RequestCode: Int{
 
    case FailError                              = 2000           // 其他错误信息，直接显示即可
    case SystemError                            = 9999           // 系统错误
    case RefreshTokenError                      = 1004           // RefreshToken传入有误,弹出框提醒用户，用户确认后退出系统。
    case RefreshTokenTimeout                    = 1015           // RefreshToken已过期，直接退出系统。
    case AccessTokenError                       = 1006           // AccessToken传入有误，弹出框提醒用户，用户确认后退出系统。
    case AccessTokenTimeout                     = 1005           // AccessToken已过期，客户端获取这个代码后需主动刷新Token。
    case Success                                = 1000           // 数据请求成功
    
}
extension Task {
    /**
     *   拿到Task 里面的请求参数
     */
   internal func getTaskParams()  -> String {
        switch self {
        case .requestParameters(let params, _):
            let json_str = JSON(params)
            return json_str.rawString([.castNilToNSNull: true]) ?? ""
        default:
            return ""
        }

    }
}
class XBNetManager {
    static let shared = XBNetManager()
    fileprivate init(){}
    
    func filterStatus(jsonString: AnyObject) -> JSON? {
        if let result = jsonString as? String {
            guard let status = result.json_Str()["status"].int else {
                return nil
            }
            guard status == 200 else {
                let message = result.json_Str()["message"].stringValue
                XBHud.showMsg(message)
                return nil
            }
            return result.json_Str()["result"]
        }
        return nil
    }
    
    public static func endpointClosure(target: RequestApi) -> Endpoint {
        let method = target.method

        let endpoint = Endpoint.init(url: target.baseURL.absoluteString + target.path,
                                     sampleResponseClosure: {.networkResponse(200, target.sampleData)},
                                     method: method,
                                     task: target.task,
                                     httpHeaderFields: target.headers)

        return endpoint
    }
    public static let requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<RequestApi>.RequestResultClosure) in
        guard var request = try? endpoint.urlRequest() else { return }
        request.timeoutInterval = TimeInterval(15) //设置请求超时时间
        done(.success(request))
    }
    let requestProvider = MoyaProvider<RequestApi>(endpointClosure: XBNetManager.endpointClosure,
                                                   requestClosure:  XBNetManager.requestTimeoutClosure)
    
    func requestWithTarget(
        _ target:RequestApi,
        isShowLoding: Bool              = true,  // 是否弹出loading框， 默认是
        isDissmissLoding: Bool          = true,  // 是否消失loading框， 默认是
        isShowErrorMessage: Bool        = true,  // 是否弹出错误提示， 默认是
        successClosure: @escaping SuccessClosure,
        failClosure: FailClosure? = nil
        ){
        // 之所以封装了一层， 是可以区分， 有一些接口，不需要此 判断本地Token 逻辑的时候，  直接调用 requestBaseWithTarget
        /// 本地刷新token逻辑
        self.requestBaseWithTarget(target, isShowLoding: isShowLoding, isDissmissLoding: isDissmissLoding, isShowErrorMessage: isShowErrorMessage, successClosure: successClosure, failClosure: failClosure)
    }
    func requestBaseWithTarget(
        _ target:RequestApi,
        isShowLoding:    Bool        = true,  // 是否弹出loading框， 默认是
        isDissmissLoding:    Bool    = true,  // 是否消失loading框， 默认是
        isShowErrorMessage: Bool     = true,  // 是否弹出错误提示， 默认是
        successClosure: @escaping SuccessClosure,
        failClosure: FailClosure? = nil
        ){
        let task_log = "request target： \n请求的URL：\(target.path)\n请求的参数：\(target.task.getTaskParams())"
        XBApiLog(task_log)
        if !NetWorkType.getNetWorkType() {
            self.endRrefreshing()
            XBHud.showWarnMsg("您的网络不太给力～")
            return
        }
        if isShowLoding {
            XBHud.showLoading()
        }
        
        _ =  requestProvider.request(target) { (result) in
            if isDissmissLoding {
                XBHud.dismiss()
                self.endRrefreshing()
            }
            switch result{
                
            case let .success(response):
                
                _ = response.data
                guard let jsonString = try? response.mapString() else {
                    return
                }
                let statusCode = response.statusCode
                guard  statusCode == 200 else {
                    print(jsonString)
                    XBHud.showWarnMsg("系统错误")
                    if let failClosure = failClosure{
                        failClosure("系统错误")
                    }
                    return
                }

                guard let info = Mapper<XBBaseResModel>().map(JSONString:jsonString) else {
                    successClosure(jsonString as AnyObject, 200,"success")
                    self.configEmptyDataSet()
                    return
                }
                self.log_print(jsonString, info)
        
                guard let data = info.resdata else {
                    successClosure(jsonString as AnyObject, 200,"success")
                    self.configEmptyDataSet()
                    return
                }

                successClosure(data, info.code,info.message)
                
            case .failure(_):
                XBHud.showWarnMsg("系统错误")
                if let failClosure = failClosure{
                    failClosure("系统错误")
                }
                break
            }
            
            self.configEmptyDataSet()
            
        }
    }
    
    //MARK: 接口日志打印规则
    func log_print(_ jsonString: String,_ info: XBBaseResModel?)  {
        XBApiLog("------jsonString------\n\(jsonString)")
        XBApiLog("\n--code: \(String(describing: info?.code?.toString))\n--message: \(String(describing: info?.message))\n--data: \(String(describing: info?.resdata))")
    }
    
    //MARK: 自定义日志上报到腾讯的bugly
    func reportToLogWithBugly(taskParams: String, errorString: String,errorMsg: String)  {
        
//        Bugly.reportException(withCategory: 4,
//                              name: errorMsg,
//                              reason: "自定义错误类型",
//                              callStack: [""],
//                              extraInfo: ["taskParams": taskParams,
//                                          "errorString": errorString],
//                              terminateApp: false)
        
    }

}
extension XBNetManager {
    /**
     *  停止刷新动作
     */
    func endRrefreshing()  {
        
        DispatchQueue.main.async {
            (UIApplication.currentViewController() as? XBBaseViewController)?.endRefresh()
        }

    }
    /**
     *  配置默认图显示
     */
    func configEmptyDataSet() {
        DispatchQueue.main.async {
             (UIApplication.currentViewController() as? XBBaseViewController)?.loading       = true
        }
    }
    /**
     *  取消所有的网络请求
     */
    func cancelAllRequest() {
//        XBHud.dismiss()
        requestProvider.manager.session.getAllTasks { (dataTasks) in
            dataTasks.forEachEnumerated{ $1.cancel() }
        }

    }
    
}
