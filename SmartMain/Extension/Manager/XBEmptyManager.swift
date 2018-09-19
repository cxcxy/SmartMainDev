//
//  XBEmptyManager.swift
//  XBShinkansen
//
//  Created by mac on 2017/12/14.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit
import Reachability.Swift
struct XBEmptyManager {
    
    static let emptyStr:String = "暂无"

    static let emptyArr = [""]
}


typealias NotReachable = (_ NotReachable:Bool?) ->()
struct NetWorkType {
    
    static var reach: Reachability?
    
    static func netWorkType(isNotReachable: NotReachable){
        self.reach = Reachability()
        if let netWork =  self.reach?.connection{// 判断有无网络，
            switch netWork {
            case .none:// 无网络
                
                isNotReachable(false)
                
            default:
                isNotReachable(true)
            }
        }
        
    }
    static func getNetWorkType() -> Bool{
        self.reach = Reachability()
        if let netWork =  self.reach?.connection{// 判断有无网络，
            switch netWork {
            case .none:// 无网络
                
                return false
                
            default:
                return true
            }
        }
        return false
    }
        
    
    
}



