//
//  XBBaseTableViewController.swift
//  XBShinkansen
//
//  Created by mac on 2017/11/7.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit
/**
 *   只有一个tableView 时，可使用此基础类。
 */
class XBBaseTableViewController: XBBaseViewController{
    var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setUI() {
        super.setUI()
        self.configTableView(tableView)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { [weak self](make) in
            guard let `self` = self else { return }
            
           if #available(iOS 11.0, *) { // ios 11 ,安全区域，
                make.edges.equalTo(self.view.safeAreaInsets)
            } else {
                make.edges.equalTo(self.view)
            }
            
        }
    }
    func registerCells(register_cells: [String]) {
        for cell_id in register_cells {
            tableView.cellId_register(cell_id)
        }
    }
    // 重写父类的init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)方法
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // 实例化 plain 风格的tableView
    init() {
        super.init(nibName: nil, bundle: nil)
        tableView = UITableView.init(frame: CGRect.zero, style: .plain)
    }
    // 实例化 group 风格的tableView
    init(style: UITableViewStyle = .plain) {
        super.init(nibName: nil, bundle: nil)
        tableView = UITableView.init(frame: CGRect.zero, style: style)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /**
     *   为tableView 配置 MJHeader
     */
    public func cofigMjHeader() {
        self.tableView.mj_header            = mj_header
    }
    
    /**
     *   为tableView 配置 MJFooter
     */
   public func cofigMjFooter() {
        self.tableView.mj_footer            = mj_footer
    }
    /**
     *   为tableView 配置 MJHeader MJFooter
     */
    public func cofigMJRefresh() {
        self.tableView.mj_header            = mj_header
        self.tableView.mj_footer            = mj_footer
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


