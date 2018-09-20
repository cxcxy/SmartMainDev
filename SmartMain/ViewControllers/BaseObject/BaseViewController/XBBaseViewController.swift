//
//  XBBaseViewController.swift
//  XBShinkansen
//
//  Created by mac on 2017/11/7.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit
public enum RefreshStatus: Int {
    case PushSuccess         // 下拉刷新成功
    case PullSuccess         // 上拉加载成功
    case RefreshFailure      // 刷新失败
    case NoMoreData          // 没有更多的数据
    case Unknown             // 未知错误
}
@objcMembers class XBBaseViewController: UIViewController {
    var pageIndex = 1 //翻页
     var mqttSession: MQTTSession!
    /// 记录当前页面是否网络请求过，区别是第一次进网络请求，还是下拉刷新进入网络请求
    var isCurrentRequest : Bool = false
    
    /// 当前导航栏的颜色,默认为nil
    var currentNavigationColor:UIColor?
    /// 当前导航栏标题的颜色,默认为nil
    var currentNavigationTitleColor:UIColor = navTitleColor
    /// 当前导航条是否透明,默认为false
    var currentNavigationNone:Bool = false
    
    /// 当前导航条是否隐藏,默认为false
    var currentNavigationHidden:Bool = false
    
    /// 是否更换当前导航条背景图片,默认为nil
    var currentNavigationBackgroudImg: UIImage?
    
    /// 是否禁止当前页面的左滑返回,默认为false
    var currentEnabledPopGesture:Bool = false
    
    var dicCellHeight = Dictionary<IndexPath, CGFloat>() //空字典
    
    var loading:Bool = false {
        didSet {
            if let tableViewNew = tableViewNew {
                tableViewNew.reloadEmptyDataSet()
            }
        }
    }
    var tableViewNew:UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomerBack()
        setUI()
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if currentEnabledPopGesture {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.keyWindow?.endEditing(true)
        
        if currentNavigationHidden {
            hiddenTopNav()
        }else {
            showTopNav()
        }
        
        if currentNavigationNone {
            translucentTopNav()
        }else if let img = currentNavigationBackgroudImg {
            self.configNavBackgroundImage(defaultImg: img)
        }else if let current_color = self.currentNavigationColor {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.barTintColor = current_color
        }
        
        //         self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.navigationBar.titleTextAttributes  = [NSAttributedStringKey.foregroundColor : currentNavigationTitleColor,
                                                                         NSAttributedStringKey.font: navTitleFont];
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.keyWindow?.endEditing(true)
        if currentNavigationNone {
            reductionTopNav()
        }
        if let img = currentNavigationBackgroudImg {
            self.configNavBackgroundImage()
            //            return
        }
        if currentEnabledPopGesture {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
        if self.currentNavigationColor != nil {
            
            self.configNavBackgroundImage()
            self.navigationController?.navigationBar.barTintColor = XBNavColor
            
        }
    }
    func hiddenTopNav()  {
        self.navigationController?.navigationBar.isHidden = true
    }
    func showTopNav()  {
        self.navigationController?.navigationBar.isHidden = false
        reductionTopNav()
    }
    /// 透明顶部导航条
    func translucentTopNav()  {
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    /// 还原顶部导航条  -- 由透明变成不透明
    func reductionTopNav()  {
        
        self.navigationController?.navigationBar.isTranslucent  = false
        self.configNavBackgroundImage()
        
    }
    /// 配置顶部导航栏背景图片  默认配置 全局样式 背景图片
    func configNavBackgroundImage(defaultImg: UIImage = XBNavImg)  {
        self.navigationController?.navigationBar.setBackgroundImage(defaultImg.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0 ,right: 0), resizingMode: .stretch), for: UIBarMetrics.default)
    }
    /**
     *   配置 UI
     */
    func setUI()  {
        if #available(iOS 11.0, *) {
            
        }else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.view.backgroundColor = tableColor
    }
    
    //MARK: 返回按钮
    func setCustomerBack(_ backIconName:String = "icon_fanhui") {
        if let count = navigationController?.viewControllers.count {
            if count > 1 {
                let img = UIImage.init(named: backIconName)?.withRenderingMode(.alwaysOriginal) // 使用原图渲染方式
                let item = UIBarButtonItem(image: img, style:.plain, target: self, action:#selector(navBack))
                navigationItem.leftBarButtonItem = item
            }
        }
    }
    /**
     *   配置tableView的相关属性 注册cellId
     */
    func configTableView(_ tableView:UITableView,register_cell:[String]? = nil)  {
        
        self.tableViewNew = tableView
        tableView.config_adjustInset()
        tableView.backgroundColor      = tableColor
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource   = self
        tableView.delegate             = self
        tableView.dataSource           = self
        tableView.estimatedRowHeight   = 200
        tableView.rowHeight            = UITableViewAutomaticDimension
        tableView.separatorStyle       = .none
        tableView.keyboardDismissMode  = .onDrag
        tableView.showsVerticalScrollIndicator = false
//        self.edgesForExtendedLayout     = .top  // 底部不被tabbar遮挡， 延伸到屏幕顶部
        if let cellArr = register_cell {
            for registerId in cellArr {
                tableView.cellId_register(registerId)
            }
        }
        
    }

    @objc func navBack() {
        _ = navigationController?.popViewController(animated: true)
    }
    // 返回 自当前页面的 前 N 个页面
    func popToIndexVC(_ index:Int)  {
        if let currentIndex = self.navigationController?.viewControllers.index(of: self) {
            if let pop_VC = self.navigationController?.viewControllers.get(at: currentIndex - index) {
                self.navigationController?.popToViewController(pop_VC, animated: true)
                return
            }
        }
        self.popToRootVC()
    }
    func request()  {
        if !isCurrentRequest {
            isCurrentRequest = true
        }

    }
    /**
     *   tableView 的 MJHeader
     */
    lazy var mj_header:MJRefreshNormalHeader = {
        
        let h = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(pullToRefresh))
        h?.lastUpdatedTimeLabel.isHidden = true
        h?.stateLabel.isHidden = true
        
        return h!
    }()
    /**
     *   tableView 的 MJ_Footer
     */
    lazy var mj_footer:MJRefreshAutoNormalFooter = {
        let f = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction:#selector(loadMore))!
        return f
    }()
    /**
     *   上拉加载， 自动加1
     */
    @objc func loadMore() {
        pageIndex += 1
        request()
    }
    /**
     *   下拉刷新， 从第一页开始
     */
    @objc func pullToRefresh() {
        pageIndex = 1
        request()
    }
    /**
     *   结束刷新 ，停止动作
     */
    func endRefresh() {
        mj_header.endRefreshing()
        mj_footer.endRefreshing()
    }
    /**
     *   根据状态来处理 上拉刷新，下来加载的控件展示与否
     */
    func refreshStatus(status:RefreshStatus){
        switch status {
        case .PullSuccess:
            self.mj_footer.isHidden = false
            endRefresh()
        case .PushSuccess:
            self.mj_footer.isHidden = false
            endRefresh()
        case .RefreshFailure:
            endRefresh()
            self.mj_footer.isHidden = true
        case .NoMoreData :
            endRefresh()
            self.mj_footer.isHidden = true
            
        case .Unknown: break
        }
    }
    deinit {
        XBLog("Title: == \(String(describing: self.title))\nVC: == \(self.identifier())  --- 销毁")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
// 默认分组间隔
extension XBBaseViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return XBMin
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return XBMin
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    // 记录行高
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.dicCellHeight[indexPath] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let h = self.dicCellHeight[indexPath]
        if let h = h {
            return h
        }else {
            return 200
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// 空白展位图
extension XBBaseViewController:DZNEmptyDataSetDelegate,DZNEmptyDataSetSource{
    @objc(titleForEmptyDataSet:) func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        guard self.loading else {
            return NSAttributedString.init()
        }
        return XBNoDataTitle
    }
    @objc(backgroundColorForEmptyDataSet:) func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return tableColor
    }
//    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
//        guard self.loading else {
//            return UIView()
//        }
////        if WOWNetWorkType.getNetWorkType() {
////            let viewNoneTask =  ArchivesNoDataView.loadFromNib()
////            viewNoneTask.lbContent.text = XBEmptyManager.emptyArr[self.identifier()]
////            viewNoneTask.lbContent.setXBLine_Style()
////            return viewNoneTask
////        }else {
//            return UIView()
////        }
//    }
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}
//wss://zb.mqtt.athenamuses.cn:1893/storybox/3010290000045007_1275/client



extension XBBaseViewController: MQTTSessionDelegate {
    func mqttDidReceive(message: MQTTMessage, from session: MQTTSession) {
        print("data received on topic \(message.topic) message \(message.stringRepresentation ?? "<>")")
    }
    
    func mqttDidAcknowledgePing(from session: MQTTSession) {
        print("Keep-alive ping 链接.")
    }
    
    func mqttDidDisconnect(session: MQTTSession, error: MQTTSessionError) {
         print("Keep-alive ping 断开.")
    }
    

    
    
    func establishConnection() {
        let now = Date()
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval).toString
        print(timeStamp)
        mqttSession = MQTTSession(host: socket_host, port: socket_port, clientID: timeStamp, cleanSession: true, keepAlive: 15, useSSL: false)
        mqttSession.delegate = self
        mqttSession.connect { (error) in
            if  error == .none {
                print("Connected.")
                self.subscribeToChannel()
            } else {
                print("Connected error.")
            }
        }
    }
    
    func subscribeToChannel() {
        let channel = "storybox/\(XBUserManager.device_Id)/client"
        mqttSession.subscribe(to: channel, delivering: .atLeastOnce) { (error) in
            if error == .none {
                print("Subscribed to \(channel)")
            } else {
                
            }
        }
    }
    func sendPressed(socketModel: XBSocketModel)  {
        let channel = "storybox/\(XBUserManager.device_Id)/server/page"
        
        guard let message = socketModel.toJSONString() else {
            return
        }
        guard  let data = message.data(using: .utf8) else {
            return
        }
        mqttSession.publish(data, in: channel, delivering: .atMostOnce, retain: false) { (error) in
            if error == .none {
                print("Published \(message) on channel \(channel)")
            }
        }
    }
}
