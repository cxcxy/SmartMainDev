//
//  XBRxSectionManager.swift
//  XBPMDev
//
//  Created by mac on 2018/4/10.
//  Copyright © 2018年 mac-cx. All rights reserved.
//

import UIKit
/**
 *   单元格类型， 仅仅表示Cell的类型
 */
enum XBCellTypeItem {
    
    case type(Int)  // 用 0，1，2，3... 表示cell的类型
    
}

//／自定义单元格类型Section
struct XBSection {
    var header: String
    var items: [XBCellTypeItem]
    init(header: String = "", items: [XBCellTypeItem]) {
        self.header = header
        self.items = items
    }
}
//／自定义单元格类型 Rx扩展
extension XBSection : SectionModelType {
    
    typealias Item = XBCellTypeItem
    init(original: XBSection, items: [Item]) {
        self = original
        self.items = items
    }
    
}
