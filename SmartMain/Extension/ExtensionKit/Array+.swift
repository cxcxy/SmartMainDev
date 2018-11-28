//
//  Array+.swift
//  BSMaster
//
//  Created by 陈旭 on 2017/10/20.
//  Copyright © 2017年 陈旭. All rights reserved.
//

import Foundation
public extension Int {
  
    fileprivate var selfDate : Date {
        return Date(timeIntervalSince1970: TimeInterval(self))
    }

    /// 是否是今天
    var isToday : Bool {
        return Calendar.current.isDateInToday(selfDate)
    }
    
    /// 是否是昨天
    var isYesterday : Bool {
        return Calendar.current.isDateInYesterday(selfDate)
    }
    
    /// 是否是今年
    var isYear: Bool {
        let nowComponent = Calendar.current.dateComponents([.year], from: Date())
        let component = Calendar.current.dateComponents([.year], from: selfDate)
        return (nowComponent.year == component.year)
    }
    /// 时间戳 返回 时分 格式
    func formartHHMM() -> String {
        let format = DateFormatter()
        format.dateFormat = "HH:mm"
        return format.string(from: selfDate)
    }
    /// 时间戳 返回 月日 格式
    func formartMMdd() -> String {
        let format = DateFormatter()
        format.dateFormat = "MM-dd"
        return format.string(from: selfDate)
    }
    /// 时间戳 返回 月日时分 格式
    func formartMMddHHMM() -> String {
        let format = DateFormatter()
        format.dateFormat = "MM-dd HH:mm"
        return format.string(from: selfDate)
    }
    /// 时间戳 返回 年月日时分 格式
    func formartyyyyMMddHHMM() -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm"
        return format.string(from: selfDate)
    }
    /// 时间戳 返回 年月 格式
    func formartyyyyMMStr() -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy年MM月"
        return format.string(from: selfDate)
    }
    /// 时间戳 返回 年月日 格式
    func formartyyyyMMdd() -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        return format.string(from: selfDate)
    }
    func yearTimeStr() -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy年前"
        return format.string(from: selfDate)
    }
    
    /// 时间戳 返回 特定 格式 今天 返回 HHMM， 不是今年 显示 yyyyMMdd
    func formart_style() -> String {
        
        if self.isToday {
            return self.formartHHMM()
        }
        if self.isYear == false {
            return self.formartyyyyMMdd()
        }
        return self.formartMMdd()

    }
    
}

extension Array {
        /**
         *   检查上拉刷新，下拉加载状态 ，判断是否有下一页
         */
    func checkRefreshStatus(_ pageIndex:Int, paseSize: Int = XBPageSize) -> RefreshStatus{
            if pageIndex == 1 && self.count == 0{
                return .noneData
            }
            if self.count < paseSize  {
                return .NoMoreData
            }

            if pageIndex == 1 && self.count == paseSize{
                return .PullSuccess
            }
            if pageIndex > 1 && self.count == paseSize {
                return .PushSuccess
            }
            return .NoMoreData
        }
    /**
     *   一行排number个，根据总数返回多少行
     */
    func getParityCellNumber(_ number:Int) -> Int {
        return  ((self.count % number) == 0 ? (self.count / number) : ((self.count / number) + 1))
    }
    
    /**
     *   删除数组内所有元素，当数组内有值时
     */
    mutating func remove_All()  {
        if self.count > 0 {
            self.removeAll()
        }
        return
    }

    
    
}
protocol Copying {
    init(original: Self)
}

extension Copying {
    func copy() -> Self {
        return Self.init(original: self)
    }
}
extension Array where Element: Copying {  // 深 copy
    func clone() -> Array {
        var copiedArray = Array<Element>()
        for element in self {
            copiedArray.append(element.copy())
        }
        return copiedArray
    }
}
