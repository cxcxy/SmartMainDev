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
    var playUrls: ConetentSingPlayModel?
    var type: Int?
    var name: String?
    var isExpanded: Bool = false // 是否展开
    var isPlay: Bool = false // 是否播放
    override func mapping(map: Map) {
        length             <-    map["length"]
        content             <-    map["content"]
        artist          <-    map["artist"]
        favoriteId            <-    map["favoriteId"]
        resId            <-    map["resId"]
        playUrls            <-    map["playUrls"]
        type            <-    map["type"]
        name            <-    map["name"]
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
