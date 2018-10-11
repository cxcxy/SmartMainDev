//
//  UserModel.swift
//  SmartMain
//
//  Created by mac on 2018/10/11.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
import ObjectMapper
class UserModel: XBDataModel {
    
    var id:Int?
    var username: String?
    var password: String?
    var nickname: String?
    var headImgUrl: String?

    
    override func mapping(map: Map) {
        
        id             <-    map["id"]
        username             <-    map["username"]
        password          <-    map["password"]
        nickname            <-    map["nickname"]
        headImgUrl            <-    map["headImgUrl"]

    }
}
