//
//  DevicesListModel.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/27.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
import ObjectMapper
class DevicesListModel: XBDataModel {
 
    var deviceId: String?
    var name: String?
    var trackCount: Int?
    var downloadTrackCount: Int?
    var coverSmallUrl: String?
    var size: String?
    var play: Int?
    
    override func mapping(map: Map) {
        deviceId                <-    map["deviceId"]
        name                    <-    map["name"]
        trackCount              <-    map["trackCount"]
        downloadTrackCount      <-    map["downloadTrackCount"]
        coverSmallUrl           <-    map["coverSmallUrl"]
        size                    <-    map["size"]
        play                    <-    map["play"]
    }
}
