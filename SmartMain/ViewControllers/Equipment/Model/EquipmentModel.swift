//
//  EquipmentModel.swift
//  SmartMain
//
//  Created by mac on 2018/9/6.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
import ObjectMapper
class EquipmentModel: XBDataModel {
    var id:Int?
    var deviceId: String?
    var name: String?
    var trackCount: Int?
    var downloadTrackCount: Int?
    var coverSmallUrl: String?
    var size: String?
    var play: Int?
    
    override func mapping(map: Map) {
        id             <-    map["id"]
        deviceId             <-    map["deviceId"]
        name          <-    map["name"]
        trackCount            <-    map["trackCount"]
        downloadTrackCount            <-    map["downloadTrackCount"]
        coverSmallUrl            <-    map["coverSmallUrl"]
        size            <-    map["size"]
        play            <-    map["play"]
    }
}
//MARK: 设备信息
class EquipmentInfoModel: XBDataModel {
    var id:String?
    var name: String?
    var net: String?
    var cardAvailable: Int?
    var cardTotal: Int?
    var electricity: Int?
    var firmwareVersion: String?
    var volume: Int?
    var online: Int?
    
    override func mapping(map: Map) {
        id             <-    map["id"]
        name          <-    map["name"]
        net            <-    map["net"]
        cardAvailable            <-    map["cardAvailable"]
        cardTotal            <-    map["cardTotal"]
        electricity            <-    map["electricity"]
        firmwareVersion            <-    map["firmwareVersion"]
        volume            <-    map["volume"]
        online            <-    map["online"]
    }
}
class EquipmentSingModel: XBDataModel {
    var id:Int?
    var title: String?
    var coverSmallUrl: String?
    var duration: Int?
    var albumTitle: String?
    var albumCoverSmallUrl: String?
    var url: String?
    var downloadUrl: String?
    var downloadUrlHashCode: String?
    var downloadSize: Int?
    var status: Int?
    var isExpanded: Bool = false // 是否展开
    var isPlay: Bool = false
    var isLike: Bool = false
    override func mapping(map: Map) {
        id             <-    map["id"]
        title             <-    map["title"]
        coverSmallUrl          <-    map["coverSmallUrl"]
        duration            <-    map["duration"]
        albumTitle            <-    map["albumTitle"]
        albumCoverSmallUrl            <-    map["albumCoverSmallUrl"]
        url            <-    map["url"]
        downloadUrl            <-    map["downloadUrl"]
        downloadUrlHashCode            <-    map["downloadUrlHashCode"]
        downloadSize            <-    map["downloadSize"]
        status            <-    map["status"]
    }
}

class FamilyMemberModel: XBDataModel {

    var id: Int?
    var groupid: String?
    var easegroupname: String?
    var easedesc: String?
    var easeadmin: String?
    var recordtime: String?
    var username: String?
    var deviceid: String?
    var headImgUrl: String?
    var nickname: String?
    override func mapping(map: Map) {
        id             <-    map["id"]
        groupid             <-    map["groupid"]
        easegroupname          <-    map["easegroupname"]
        easedesc            <-    map["easedesc"]
        easeadmin            <-    map["easeadmin"]
        recordtime            <-    map["recordtime"]
        username            <-    map["username"]
        deviceid            <-    map["deviceid"]
        headImgUrl            <-    map["headImgUrl"]
        nickname            <-    map["nickname"]
    }
}
class GetTrackListDefault: XBDataModel {
    
    var cmd: String?
    var trackListId: Int?
    var name: String?
    var trackIds: [Int]?

    override func mapping(map: Map) {
        
        cmd             <-    map["cmd"]
        trackListId             <-    map["trackListId"]
        name          <-    map["name"]
        trackIds            <-    map["trackIds"]
        
    }
}
class SingDetailModel: XBDataModel {
    
    var id: Int?
    var title: String?
    var coverSmallUrl: String?
    var duration: Int?
    var albumTitle: String?
    var albumCoverSmallUrl: String?
    var url: String?
    var downloadUrl: String?
    var downloadUrlHashCode: String?
    var downloadSize: String?
    var status: Int?
    var isAudition: Bool = false
    override func mapping(map: Map) {
        
        id             <-    map["id"]
        title             <-    map["title"]
        coverSmallUrl          <-    map["coverSmallUrl"]
        duration            <-    map["duration"]
        albumTitle            <-    map["albumTitle"]
        albumCoverSmallUrl            <-    map["albumCoverSmallUrl"]
        url            <-    map["url"]
        downloadUrl            <-    map["downloadUrl"]
        downloadUrlHashCode            <-    map["downloadUrlHashCode"]
        downloadSize            <-    map["downloadSize"]
        status            <-    map["status"]
    }
}
class ResourceDetailModel: XBDataModel {
    
    var length: Int?
    var content: String?
    var artist: String?
    var favoriteId: String?
    var resId: String?
    var playUrls: ResourceNormal?
    var album: AlbumDetailModel?
    var type: Int?
    var name: String?
    var trackId: Int?
    var isAudition: Bool = false // 是否在试听
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
        album            <-    map["album"]
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
class ResourceNormal: XBDataModel {
    
    var normal: ResourceNormal?
    var url: String?
    var size: Int?
    
    
    
    override func mapping(map: Map) {
        
        normal             <-    map["normal"]
        url             <-    map["url"]
        size          <-    map["size"]
        
    }
}


class AlbumDetailModel: XBDataModel {
    
    var id: String?
    var imgSmall: String?
    var name: String?
    var imgLarge: String?

    
    override func mapping(map: Map) {
        
        id             <-    map["id"]
        imgSmall             <-    map["imgSmall"]
        name          <-    map["name"]
        imgLarge            <-    map["imgLarge"]
        
    }
}
