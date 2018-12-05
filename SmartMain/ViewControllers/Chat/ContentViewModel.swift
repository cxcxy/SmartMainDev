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

        Net.requestWithTarget(.onlineSing(openId: openId, trackId: trackId, deviceId: deviceId),isEndRrefreshing: false, successClosure: { (result, code, message) in
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
    //// zhiban
    //MARK: 按关键字搜索资源
    func requestZhiBanSearchResource(req: [String: Any]) -> Observable<[ConetentSingModel]>  {
        
        return Observable.create { observer -> Disposable in
            
            Net.requestWithTarget(.getSearchResource(req: req), successClosure: { (result, code, message) in
                
                if let result = result as? String {
                   if let arr = Mapper<ConetentSingModel>().mapArray(JSONObject:JSON(result)["resources"].arrayObject) {
                        observer.onNext(arr)
                    }
                }
                
            })
            return Disposables.create {
            }
        }
    }
    //MARK: 按关键字搜索专辑
    func requestZhiBanSearchResourceAlbum(req: [String: Any]) -> Observable<[SearchResourceAlbumModel]> {
        return Observable.create { observer -> Disposable in
            Net.requestWithTarget(.getSearchResource(req: req), successClosure: { (result, code, message) in
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
    //// tuling ：：
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
        Net.requestWithTarget(.saveLikeSing(req: params_task),isEndRrefreshing: false, successClosure: { (result, code, message) in
            print(result)
            if let str = result as? String {
                if str == "ok" {
                    XBHud.showMsg("收藏成功")
                    let likeItem = ConetentLikeModel()
                    likeItem.trackId = songId
                    likeItem.duration = duration
                    likeItem.title = title
                    userLikeList.append(likeItem)
                    closure()
                }else {
                    XBHud.showMsg("收藏失败")
                }
            }
        })
    }
    /**
     *   取消收藏歌曲
     */
    func  requestCancleLikeSing(trackId: Int,closure: @escaping () -> ())  {
        
        var params_task = [String: Any]()
        params_task["openId"] = XBUserManager.userName
        params_task["trackId"]  = trackId
        Net.requestWithTarget(.deleteLikeSing(req: params_task),isEndRrefreshing: false, successClosure: { (result, code, message) in
            print(result)
            if let str = result as? String {
                if str == "ok" {
                    XBHud.showMsg("取消收藏成功")
                    userLikeList =  userLikeList.filter({ (item) -> Bool in
                        return item.trackId != trackId
                    })
                    closure()
                }else {
                    XBHud.showMsg("取消收藏失败")
                }
            }
        })
        
    }

    func requestLikeListSong(closure: @escaping ([ConetentLikeModel]) -> ())  {
        guard let phone = user_defaults.get(for: .userName) else {
            XBHud.showMsg("请登录")
            return
        }

        Net.requestWithTarget(.getLikeList(openId: phone), successClosure: {(result, code, message) in
            if let arr = Mapper<ConetentLikeModel>().mapArray(JSONString: result as! String) {
                closure(arr)
            }
        })
    }
    
}
// 首页
extension ContentViewModel {
    //MARK: 请求顶部所有资源 接口
    func requestResourceAll() -> Observable<[ResourceAllModel]> {
        
        return Observable.create { observer -> Disposable in
            
            Net.requestWithTarget(.getResourceAll(), successClosure: { (result, code, message) in
                guard let result = result as? String else{
                    return
                }
                if let arr = Mapper<ResourceAllModel>().mapArray(JSONObject:result.json_Str()["body"].arrayObject) {
                    observer.onNext(arr)
    
                }
            }) { (errorMsg) in
//                if errorMsg == ERROR_TIMEOUT {
//                    self.loadingTimerOut = true
//                } else {
//                    self.loading = true
//                }
//                self.endRefresh()
            }
            
            return Disposables.create {
            }
            
        }
    }
   //MARK: 请求顶部banner 接口
    func requestResourceBanners() -> Observable<[ResourceBannerModel]> {
        
        return Observable.create { observer -> Disposable in
            
            Net.requestWithTarget(.getResourceBanner(customer: "zhiban"), successClosure: { (result, code, message) in
//                guard let result = result as? String else{
//                    return
//                }
                if let obj = Net.filterStatus(jsonString: result) {
                    if let banners = Mapper<ResourceBannerModel>().mapArray(JSONObject: obj.object) {
                      observer.onNext(banners)
                    }
                }

            }) { (errorMsg) in
                //                if errorMsg == ERROR_TIMEOUT {
                //                    self.loadingTimerOut = true
                //                } else {
                //                    self.loading = true
                //                }
                //                self.endRefresh()
            }
            
            return Disposables.create {
            }
            
        }
    }
    
    //MARK: 获取资源全部分类
    func requestResourceCategory() -> Observable<[ResourceAllModel]> {
        
        return Observable.create { observer -> Disposable in
            
            Net.requestWithTarget(.getResourceAll(), successClosure: { (result, code, message) in
                guard let result = result as? String else{
                    return
                }
                if let arr = Mapper<ResourceAllModel>().mapArray(JSONObject:result.json_Str()["body"].arrayObject) {
                     observer.onNext(arr)
                }
            }) { (errorMsg) in
//                if errorMsg == ERROR_TIMEOUT {
//                    self.loadingTimerOut = true
//                } else {
//                    self.loading = true
//                }
//                self.endRefresh()
            }
            
            return Disposables.create {
            }
            
        }
    }
    //MARK: 获取专辑排行列表
    func requestResourceTopList(req: [String: Any]) -> Observable<[ResourceTopListModel]> {
        
        return Observable.create { observer -> Disposable in
            
            Net.requestWithTarget(.getResourceListTop(req: req), successClosure: { (result, code, message) in
                guard let result = result as? String else{
                    return
                }
                if let arr = Mapper<ResourceTopListModel>().mapArray(JSONObject:result.json_Str()["body"]["content"].arrayObject) {
                    observer.onNext(arr)
                }
            }) { (errorMsg) in
                //                if errorMsg == ERROR_TIMEOUT {
                //                    self.loadingTimerOut = true
                //                } else {
                //                    self.loading = true
                //                }
                //                self.endRefresh()
            }
            
            return Disposables.create {
            }
            
        }
    }
    //MARK: 获取音频列表
    func requestResourceAudioList(req: [String: Any]) -> Observable<[ResourceAudioListModel]> {
        
        return Observable.create { observer -> Disposable in
            
            Net.requestWithTarget(.getAudioListTop(req: req), successClosure: { (result, code, message) in
                guard let result = result as? String else{
                    return
                }
                if let arr = Mapper<ResourceAudioListModel>().mapArray(JSONObject:result.json_Str()["body"]["content"].arrayObject) {
                    observer.onNext(arr)
                }
            }) { (errorMsg) in
                //                if errorMsg == ERROR_TIMEOUT {
                //                    self.loadingTimerOut = true
                //                } else {
                //                    self.loading = true
                //                }
                //                self.endRefresh()
            }
            
            return Disposables.create {
            }
            
        }
    }
}
