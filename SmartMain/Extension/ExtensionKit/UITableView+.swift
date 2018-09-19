//
//  UITableView+.swift
//  BSMaster
//
//  Created by 陈旭 on 2017/9/29.
//  Copyright © 2017年 陈旭. All rights reserved.
//

import UIKit
public extension UINib{
    // 通过name 取Nib
    class func nibName(_ name:String) ->UINib{
        return UINib(nibName: name, bundle: Bundle.main)
    }
}

extension UIScrollView {
    /// 适配iOS 11
    func config_adjustInset()  {
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        }
    }
}

extension UITableView {
    // 注册CellId -Nib
    func cellId_register(_ cellId:String)    {
        self.register(UINib.nibName(cellId), forCellReuseIdentifier: cellId)
    }
    // 配置 系统默认的tableView 分割线
    func config_cellLine()  {
        self.separatorStyle = .singleLine
        self.separatorColor = XBCellLineColor
    }

    func dequeueReusable_Cell<T: UITableViewCell>(indexPath: IndexPath, reuseIdentifier: String = String(describing: T.self)) -> T {
        return self.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! T
    }
    func reloadSection(_ setionIndex:IndexSet)  {
        self.beginUpdates()
        self.reloadSections(setionIndex, with: .automatic)
        self.endUpdates()
    }
    func reloadRow(_ rowIndex:[IndexPath])  {
        self.beginUpdates()
        self.reloadRows(at: rowIndex, with: .automatic)
        self.endUpdates()
    }
    
}

extension UICollectionView {
   // 注册CellId -Nib
    func cellId_register(_ cellId:String)    {
        self.register(UINib.nibName(cellId), forCellWithReuseIdentifier: cellId)
    }
    
}
class BaseTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
