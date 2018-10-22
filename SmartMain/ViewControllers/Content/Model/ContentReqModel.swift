//
//  ContentReqModel.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/4.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
import ObjectMapper
class ContentReqModel: XBDataModel {
    var appId:String?
    var token: String?
    var clientId: String?
    var userId: String?
    var tag: [String] = []
    
    override func mapping(map: Map) {
        appId             <-    map["appId"]
        token             <-    map["token"]
        clientId          <-    map["clientId"]
        userId            <-    map["userId"]
        tag            <-    map["tag"]
    }
}
class ModulesResModel: XBDataModel {
    var id:String?
    var name: String?
    var icon: String?
    var imageAspect:CGFloat = 0
    var contents: [ModulesConetentModel]?
    override func mapping(map: Map) {
        id             <-    map["id"]
        name             <-    map["name"]
        icon          <-    map["icon"]
        contents <-    map["contents"]
    }
    
    func calImageHeight(){
        //定义NSURL对象
        
        let url = URL(string: icon ?? "")
        
        if let url = url {
            
            DispatchQueue.global(qos: .background).async {
                do{
                    
                    let data = try Data(contentsOf: url)
                    if let image = UIImage(data: data ) {
                        //计算原始图片的宽高比
                        
                        self.imageAspect = image.size.width / image.size.height
                        //            //设置imageView宽高比约束
                        //            //加载图片
                        //
                    }
                }catch let e {
//                    DLog(e)
                }
                
            }
            
        }
    }
}
class ModulesConetentModel: XBDataModel {
    var id:String?
    var type: String?
    var name: String?
    var imgLarge: String?
    var imgSmall: String?
    var total: Int?
    var albumType: Int?
    override func mapping(map: Map) {
        id             <-    map["id"]
        type             <-    map["type"]
        name          <-    map["name"]
        total  <-    map["total"]
        imgLarge            <-    map["imgLarge"]
        imgSmall            <-    map["imgSmall"]
        albumType            <-    map["albumType"]
    }
}
class ConetentSingModel: XBDataModel {
    var length:Int?
    var content: String?
    var artist: String?
    var favoriteId: String?
    var resId: String?
    var trackId: Int?
    var playUrls: ConetentSingPlayModel?
    var type: Int?
    var name: String?
    var isExpanded: Bool = false // 是否展开
    var isPlay: Bool = false // 是否播放
    var isLike: Bool = false // 是否喜欢
    override func mapping(map: Map) {
        length             <-    map["length"]
        content             <-    map["content"]
        artist          <-    map["artist"]
        favoriteId            <-    map["favoriteId"]
        resId            <-    map["resId"]
        if let resId = resId {
            self.transfromTrackId(resId: resId)
        }
        playUrls            <-    map["playUrls"]
        type            <-    map["type"]
        name            <-    map["name"]
    }
    func transfromTrackId(resId: String)  {
//        if let arr =  {
        let arr = resId.components(separatedBy: ":")
        if arr.count > 0 {
            self.trackId = arr[1].toInt()
        }
//        }
    }
}
class AddSongTrackReqModel: XBDataModel {
    var id:Int?
    var title: String?
    var coverSmallUrl: String?
    var duration: Int?
    var albumTitle: String?
    var albumCoverSmallUrl: String?
    var url: String?
    var downloadUrl: String?
    var downloadSize: Int?
    
    override func mapping(map: Map) {
        id             <-    map["id"]
        title             <-    map["title"]
        coverSmallUrl          <-    map["coverSmallUrl"]
        duration            <-    map["duration"]
        albumTitle            <-    map["albumTitle"]
        albumCoverSmallUrl            <-    map["albumCoverSmallUrl"]
        url            <-    map["url"]
        downloadUrl            <-    map["downloadUrl"]
        downloadSize            <-    map["downloadSize"]
    }
}

class ConetentSingAlbumModel: XBDataModel {
    var imgLarge:String?
    var imgSmall: String?
    var albumId: String?
    var name: String?
    var description: String?
    var total: Int?
    override func mapping(map: Map) {
        imgLarge             <-    map["imgLarge"]
        imgSmall             <-    map["imgSmall"]
        albumId             <-    map["albumId"]
        name             <-    map["name"]
        description             <-    map["description"]
        total             <-    map["total"]
    }
}
class ConetentSingPlayModel: XBDataModel {
    var size:Int?
    var url: String?
    override func mapping(map: Map) {
        size             <-    map["size"]
        url             <-    map["url"]
    }
}
class ConetentLikeModel: Mappable {
    var openId:String?
    var trackId: Int?
    var title: String?
    var coverSmallUrl: String?
    var duration: Int?
    var albumTitle: String?
    var albumCoverSmallUrl: String?
    var url: String?
    var downloadUrl: String?
    var downloadSize: String?
    var opDate: String?
    var isExpanded: Bool = false
    var isPlay: Bool = false
    init() {
        
    }
    required init?(map: Map) {
        
    }

    func mapping(map: Map) {
        openId             <-    map["openId"]
        trackId             <-    map["trackId"]
        title          <-    map["title"]
        coverSmallUrl            <-    map["coverSmallUrl"]
        duration            <-    map["duration"]
        albumTitle            <-    map["albumTitle"]
        albumCoverSmallUrl            <-    map["albumCoverSmallUrl"]
        url            <-    map["url"]
        downloadUrl            <-    map["downloadUrl"]
        downloadSize            <-    map["downloadSize"]
        opDate            <-    map["opDate"]
    }
}

//MARK: 图灵全部资源 一级model
class ResourceAllModel: Mappable {

    var id: Int?
    var name: String?
    var imgLarge:String?
    var categories: [ResourceAllModel]?

    init() {
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id                  <-    map["id"]
        name                <-    map["name"]
        categories          <-    map["categories"]

    }
}
//MARK: 资源 顶部banner model
class ResourceBannerModel: Mappable {
    
    var id: Int?
    var name: String?
    var customer: String?
    var desc: String?
    var linkurl:String?
    var picture:String?
    var sortid:Int?
    var status:Int?
    
    init() {
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id                  <-    map["id"]
        name                <-    map["name"]
        customer          <-    map["customer"]
        desc          <-    map["desc"]
        linkurl          <-    map["linkurl"]
        picture          <-    map["picture"]
        sortid          <-    map["sortid"]
        status          <-    map["status"]
        
    }
}
//MARK: 搜索 资源 model
class SearchResourceModel: Mappable {
    
    var id: Int?
    var name: String?
    var downloadUrl: String?
    var duration: Int?
    var desc: String?
    var linkurl:String?
    var picCover:String?
//    var duration:Int?
    var sortid:Int?
    var status:Int?
    var categoryName: String?
    init() {
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id                  <-    map["id"]
        name                <-    map["name"]
        duration          <-    map["duration"]
        desc          <-    map["desc"]
        linkurl          <-    map["linkurl"]
        picCover          <-    map["picCover"]
        duration        <-    map["duration"]
        sortid          <-    map["sortid"]
        status          <-    map["status"]
        categoryName <-    map["categoryName"]
    }
}
//MARK: 专辑排行榜 相当于 二级列表
class ResourceTopListModel: Mappable {
    
    var id: Int?
    var name: String?
    var picCover:String?
    var description:String?
    var categoryId:Int?
    var audioTotal:Int?
    
    init() {
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id                  <-    map["id"]
        name                <-    map["name"]
        picCover          <-    map["picCover"]
        description          <-    map["description"]
        categoryId          <-    map["categoryId"]
        audioTotal          <-    map["audioTotal"]

    }
}
//public protocol TransformType {
//    associatedtype Object
//    associatedtype JSON
//
//    func transformFromJSON(_ value: Any?) -> Object?
//    func transformToJSON(_ value: Object?) -> JSON?
//}
//open class DateTransform: TransformType {
//    public typealias Object = Date
//    public typealias JSON = Double
//
//    public init() {}
//
//    open func transformFromJSON(_ value: Any?) -> Date? {
//        if let timeInt = value as? Double {
//            return Date(timeIntervalSince1970: TimeInterval(timeInt))
//        }
//
//        if let timeStr = value as? String {
//            return Date(timeIntervalSince1970: TimeInterval(atof(timeStr)))
//        }
//
//        return nil
//    }
//
//    open func transformToJSON(_ value: Date?) -> Double? {
//        if let date = value {
//            return Double(date.timeIntervalSince1970)
//        }
//        return nil
//    }
//}
//MARK: 音频列表 相当于 三级列表
class ResourceAudioListModel: Mappable {
    
    var id: Int?
    var name: String?
    var picCover:String?
    var description:String?
    var categoryId:Int?
    var audioTotal:Int?
    var duration: Int?
    var downloadUrl: String?
    
    
    var isPlay: Bool = false
    var isExpanded: Bool = false
    init() {
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id                  <-    map["id"]
        name                <-    map["name"]
        picCover          <-    map["picCover"]
        description          <-    map["description"]
        categoryId          <-    map["categoryId"]
        audioTotal          <-    map["audioTotal"]
        duration <-    map["duration"]
        downloadUrl      <-    map["downloadUrl"]
        
        
        if let duration = duration {
             self.tranfromDuration(duration: duration)
        }
       
    }
    func tranfromDuration(duration: Int)  {
        self.duration = duration / 1000
    }
}
//MARK: 搜索 资源 专辑 model
class SearchResourceAlbumModel: Mappable {
    
    var id: Int?
    var name: String?
    var customer: String?
    var desc: String?
    var linkurl:String?
    var picCover:String?
    var sortid:Int?
    var status:Int?
    
    init() {
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id                  <-    map["id"]
        name                <-    map["name"]
        customer          <-    map["customer"]
        desc          <-    map["desc"]
        linkurl          <-    map["linkurl"]
        picCover          <-    map["picCover"]
        sortid          <-    map["sortid"]
        status          <-    map["status"]
        
    }
}
