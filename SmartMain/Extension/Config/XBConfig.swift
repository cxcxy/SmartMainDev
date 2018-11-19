//
//  BSConfig.swift
//  BSMaster
//
//  Created by 陈旭 on 2017/9/29.
//  Copyright © 2017年 陈旭. All rights reserved.
//

import Foundation

//MARK:  print -- log
let XBDEBUG = XBUtil.getHermesConfiguration("LogPrint")
public func XBLog<T> (_ value: T , fileName : String = #file, function:String = #function, line : Int32 = #line ){
 
    if XBDEBUG == "0" {
        print("file：\(URL(string: fileName)?.lastPathComponent ?? "")\nline:- \(line)\nfunction:- \(function)\nlog: \(value)\n")
    }
}

public func XBApiLog<T> (_ value: T , fileName : String = #file, function:String = #function, line : Int32 = #line ){
    
    if XBDEBUG == "0" {
        print("\(value)")
    }
}
//let testDeviceId = "3010290000045007_1275"

let testDeviceId = user_defaults.get(for: .deviceId) ?? ""

//MARK:   延迟多少秒 回掉
struct XBDelay {
    static func start(delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
    
}

public let MGScreenWidth:CGFloat        = UIScreen.main.bounds.size.width
public let MGScreenHeight:CGFloat       = UIScreen.main.bounds.size.height
public let MGScreenWidthHalf:CGFloat    = MGScreenWidth / 2
public let MGScreenHeightHalf:CGFloat   = MGScreenHeight / 2


//／ 最小值 类似 0.0001
let XBMin:CGFloat = CGFloat.leastNormalMagnitude





//MARK: tableView 无数据展示状态
let XBNoDataTitle:NSAttributedString    =   NSAttributedString(string: "暂无数据",
                                                               attributes:[NSAttributedStringKey.foregroundColor:MGRgb(0, g: 0, b: 0, alpha: 0.5),
                                                                           NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14)])


let XBStatusBarHight                = UIApplication.shared.statusBarFrame.height


//MARK: 全局分页行数
let XBPageSize:Int                  =  15
//MARK: 全局行间距
let XBLineBreak: CGFloat            = 1.3
//MARK: 全局行间距
let XBLineBreakNumber: CGFloat            = 5

//MARK: 全局下线弹框状态,1:已出现
var XBLoginShow:Int                 =  0
// 全局背景 墨绿色
let viewColor = UIColor.init(hexString: "7ECC3B")!
// 全局背景 墨绿色
let lineColor = MGRgb(229, g: 229, b: 229)
// 全局背景 导航栏顶部标题颜色
let navTitleColor = UIColor.white



// 全局背景 导航栏顶部标题字体
let navTitleFont = UIFont.systemFont(ofSize: 18)

// 获取验证码 / 圆角 小角度
let radius_nl:CGFloat = 14
// 登录 /  圆角 中角度
let radius_nll:CGFloat = 20

//TODO: 全局tableView 背景色
let tableColor                      =  UIColor.white

//MARK: 导航栏背景色

let XBNavColor                      = UIColor.white

//MARK: 描边背景色  红色

let XBBorderColor                   = UIColor.init(hexString: "E43D39")!

//MARK: tableViewCell Line颜色
let XBCellLineColor                 = MGRgb(221, g: 226, b: 228)
//MARK: 评分标题
let XBScoreTitleArray: [String]     = ["极差","差","一般","较好","好","极好"]
//MARK: 评分
let XBScoreArray: [Int]             = [-5,-3,1,2,3,5]

let XBScoreNone : String            = "暂未达到评分标准"

typealias XBActionClosure           = () -> ()
typealias XBObjectActionClosure     = (_ object:AnyObject) ->()

let XBNavImg = UIImage.init()

