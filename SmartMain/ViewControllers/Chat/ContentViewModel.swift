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
                    closure()
                }else if str == "1"{
                    XBHud.showMsg("设备不在线")
                }else if str == "2"{
                    XBHud.showMsg("你没有绑定设备")
                }
                
            }
        })
    }
    //MARK: 按关键字搜索资源
    func requestSearchResource(req: [String: Any]) -> Observable<[SearchResourceModel]>  {
        
        return Observable.create { observer -> Disposable in
            
            Net.requestWithTarget(.searchResource(req: req), successClosure: { (result, code, message) in
                
                if let result = result as? String {
                    if let arr = Mapper<SearchResourceModel>().mapArray(JSONObject:result.json_Str()["body"]["content"].arrayObject) {
                        observer.onNext(arr)
                        
                    }
                    
                }
                
            })
            
            return Disposables.create {
            }
            
        }

    }
    //MARK: 按关键字搜索专辑
    func requestSearchResourceAlbum(req: [String: Any]) -> Observable<[SearchResourceAlbumModel]> {
        
        return Observable.create { observer -> Disposable in
            
            Net.requestWithTarget(.searchResourceAlbum(req: req), successClosure: { (result, code, message) in
                if let result = result as? String {
                    if let arr = Mapper<SearchResourceAlbumModel>().mapArray(JSONObject:result.json_Str()["body"]["content"].arrayObject) {
                        observer.onNext(arr)
                    }
                }
            })
            
            return Disposables.create {
            }
            
        }
    }
    /**
     *   收藏歌曲
     */
    func requestLikeSing(songId: Int?,duration: Int, title: String,closure: @escaping () -> ())  {
        guard let songId = songId else {
            XBHud.showMsg("当前歌曲ID错误")
            return
        }
        var params_task = [String: Any]()
        params_task["openId"] = XBUserManager.userName
        params_task["trackId"]  = songId
        params_task["duration"] = duration
        params_task["title"]    = title
        Net.requestWithTarget(.saveLikeSing(req: params_task), successClosure: { (result, code, message) in
            print(result)
            if let str = result as? String {
                if str == "ok" {
                    XBHud.showMsg("收藏成功")
                    closure()
                }else {
                    XBHud.showMsg("收藏失败")
                }
            }
        })
    }
}
