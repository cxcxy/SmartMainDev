//
//  ContentMainVC.swift
//  SmartMain
//
//  Created by mac on 2018/9/4.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
import VTMagic
//全局风格统一 指示器
class VCVTMagic:VTMagicController{
    
    override func viewDidLoad() {
        magicView.backgroundColor = viewColor
        magicView.navigationHeight    = 40
        magicView.layoutStyle         = .divide
        magicView.sliderStyle         = .default
        magicView.sliderColor         = MGRgb(200, g: 231, b: 169)
        magicView.sliderHeight        = 5
        magicView.bubbleRadius  = 0
//        magicView.sliderWidth         = 50
        magicView.separatorColor      = MGRgb(239, g: 243, b: 246)
//        magicView.slider
    }
    
}
// 当前用户所拥有的喜欢列表
var userLikeList : [ConetentLikeModel] = []

// 当前机器正在播放的歌曲
var currentDeviceSongModel:ResourceDetailModel?  // 当前正在播放歌曲的信息



protocol ContentVCDelegate: class {
    func clickMenuAction()
}
class ContentMainVC: XBBaseViewController {
    var controllerArray     : [UIViewController] = []  // 存放controller 的array
    var v                   : VCVTMagic!  // 统一的左滑 右滑 控制View
    var bottomSongView = BottomSongView.loadFromNib()
    weak var delegate: ContentVCDelegate?
    @IBOutlet weak var bottomLayout: NSLayoutConstraint!
    
//    var navMessageView = ChatRedView.loadFromNib()
    let scoketModel = ScoketMQTTManager.share
    var currentDeviceId: String?
    
//    var currentSongModel:SingDetailModel? { // 当前正在播放歌曲的信息
//        didSet {
//            guard let m = currentSongModel else {
//                return
//            }
////            self.configBottomSongView(singsDetail: m)
//        }
//    }
    
    var viewModel = EquimentViewModel()
    var viewModelLogin = LoginViewModel()
    var trackList: [EquipmentModel] = []
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var navMessageView: UIView!
    @IBOutlet weak var viewMessageRed: UIView!
    
    @IBOutlet weak var layoutViewTop: NSLayoutConstraint!
    
    
    @IBOutlet weak var topItemStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentNavigationTitleColor = UIColor.white
        bottomLayout.adapterTop_X()
        self.setupSideMenu()
        self.adapterUI()
    }
    func adapterUI() {
        switch UIDevice.deviceType {
        case .dt_iPhone5:
            topItemStackView.spacing = 10
        default:
            break
        }
        layoutViewTop.constant = self.navigationBarHeight + StatusBarHight
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let currentDeviceId = currentDeviceId else {
            return
        }
        if currentDeviceId != XBUserManager.device_Id{  // 如果当前的设备ID有变化 重新拉去请求 ,重新拉去当前MQTT 命令，重新配置底部播放view
            self.currentDeviceId = XBUserManager.device_Id
            request()
            configResetBottomSongView()
            configScoketModel()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUnreadMessageCount()
        
    }
    lazy var popWindow:UIWindow = {
        let w = UIApplication.shared.delegate as! AppDelegate
        return w.window!
    }()
    fileprivate func setupSideMenu() {
        // Define the menus
        let two = DrawerViewController()
        
        let twonavigationController = UISideMenuNavigationController(rootViewController: two)
        SideMenuManager.default.menuLeftNavigationController = twonavigationController
//        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuWidth = MGScreenWidth * 0.75
        SideMenuManager.default.menuPresentMode = .viewSlideInOut
        SideMenuManager.default.menuAnimationFadeStrength = 0.5

    }

    //MARK: 设置未读消息数量
    func setupUnreadMessageCount()  {
        let conversations = EMClient.shared()?.chatManager.getAllConversations() as? [EMConversation]
        var unreadCount = 0
        for item in conversations ?? [] {
            unreadCount += Int(item.unreadMessagesCount)
        }
        if unreadCount > 0 {
            self.viewMessageRed.isHidden = false
        }else {
            self.viewMessageRed.isHidden = true
        }
        print("未读消息数量" , unreadCount)
    }
    
    @IBAction func clickMenuAction(_ sender: Any) {
//        self.maskAnimationFromLeft()
//        if let del = self.delegate {
//            del.clickMenuAction()
//        }
//        XBUserManager.cleanUserInfo()
//        XBUserManager.clearDeviceInfo()
//        if (EMClient.shared()?.logout(true)) == nil {
//            print("退出登录成功")
//        }
//        let sv = UIStoryboard.getVC("Main", identifier:"LoginNav") as! XBBaseNavigation
//        self.popWindow.rootViewController = sv
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    override func setUI() {
        super.setUI()
        self.currentNavigationHidden = true
        configMagicView()
        viewMessageRed.roundView()
        addBottomSongView()
        /// 当切换设备或者绑定设备的时候，重新订阅 scoket MQTT 信息
        _ = Noti(.refreshDeviceHistory).takeUntil(self.rx.deallocated).subscribe(onNext: {[weak self] (value) in
            guard let `self` = self else { return }
            self.configScoketModel()
            self.request()
        })
        
        
//        configNavBarItem()
        
        
        configChatMessage()
        
        
        
//        self.registerShowIntractiveWithEdgeGesture()
        
        XBDelay.start(delay: 1) {
            self.setupUnreadMessageCount()
            self.configScoketModel()
        }
        self.request()
        

    }


    //MARK: 请求预制列表数据
//    func requestTrackList() {
//        guard XBUserManager.device_Id != "" else {
//            endRefresh()
//            return
//        }
//        Net.requestWithTarget(.getTrackList(deviceId: XBUserManager.device_Id), successClosure: { (result, code, message) in
//            print(result)
//            if let arr = Mapper<EquipmentModel>().mapArray(JSONString: result as! String) {
//                self.endRefresh()
//                self.trackList = arr
////                self.tableView.reloadData()
//            }
//        })
//    }

    override func request()  {
        super.request()
        
        ContentViewModel().requestLikeListSong { (arr) in
            userLikeList = arr
        }
        
        guard XBUserManager.device_Id != "" else {
            self.loading = true
            endRefresh()
            self.title = "暂无绑定设备"
            return
        }
        viewModelLogin.requestGetUserInfo(mobile: XBUserManager.userName) { [weak self] in // 获取最新的用户信息
            guard let `self` = self else { return }
//            self.requestDevicesBabyInfo()
        }
        self.requestTrackList()

    }
    //MARK: 获取最新的设备信息
    func requestDevicesBabyInfo() {
        viewModelLogin.requestGetBabyInfo(device_Id: XBUserManager.device_Id) {[weak self] (isTrue)in
            guard let `self` = self else { return }
            self.title = XBUserManager.nickname + "的" +  XBUserManager.dv_babyname
        }
    }
    @objc func anchorLeft() {
//        slidingViewController.anchorTopViewToLeft(animated: true)
//        UIApplication.shared.sli
//        AppDelegate.init()
//        UIApplication.shared.sli
    }
    //MARK: 配置导航条左右Item
    func configNavBarItem()  {
        makeCustomerImageNavigationItem("iconmenu", left: true) {[weak self] in
            guard let `self` = self else { return }
//            self.maskAnimationFromLeft()
        }
        
//        makeCustomerImageNavigationItem("", left: false) {[weak self] in
//            guard let `self` = self else { return }
//            let vc = ChatMainViewController()
//            self.pushVC(vc)
//        }
//        navMessageView.addTapGesture { [weak self](sender) in
//            guard let `self` = self else { return }
//            let vc = ChatMainViewController()
//            self.pushVC(vc)
//        }
//        navMessageView.viewSearch.addTapGesture { [weak self](sender) in
//            guard let `self` = self else { return }
//            let vc = SearchViewController()
//            self.pushVC(vc)
//        }
//        makeRightNavigationItem(navMessageView, left: false)
    }
    //MARK: 配置环信聊天
    func configChatMessage()  {
        EMClient.shared().chatManager.add(self, delegateQueue: nil)
        navMessageView.addTapGesture { [weak self](sender) in
            guard let `self` = self else { return }
            let vc = ChatMainViewController()
            self.pushVC(vc)
        }
    }
    deinit {
        EMClient.shared()?.chatManager.remove(self)
        print("222222Xiaohui")
    }
    //MARK: 配置scoket 链接
    func configScoketModel() {
        guard XBUserManager.device_Id != "" else {
            configResetBottomSongView()
            return
        }
        scoketModel.sendGetTrack()
        scoketModel.sendPlayStatus()
        
        scoketModel.getPalyingSingsModel.asObservable().subscribe { [weak self] in
            guard let `self` = self else { return }
            guard let model = $0.element else { return }
            self.configBottomUI(singsDetail: model)
        }.disposed(by: rx_disposeBag)
        
        
        scoketModel.playStatus.asObserver().bind(to: bottomSongView.btnPlay.rx.isSelected).disposed(by: rx_disposeBag)
    }
    func requestResourcesDetail(trackId: Int)  {
        var params_task = [String: Any]()
        params_task["clientId"] = XBUserManager.device_Id
        params_task["resId"] = "aires:" + trackId.toString
        Net.requestWithTarget(.getResourceDetail(req: params_task),isShowLoding: false, successClosure: { [weak self] (result, code, message) in
            guard let `self` = self else { return }
            print(result)
            
            if let model = Mapper<ResourceDetailModel>().map(JSONObject: result) {
                self.configBottomUI(singsDetail: model)
                currentDeviceSongModel = model
            }
            
            //            self.currentSongModel = Mapper<SingDetailModel>().map(JSONString: result)
            //            self.allTimer = Float(self.currentSongModel?.duration ?? 0)
            //            self.resetTimer()
            //            // 获取播放状态
            //            self.scoketModel.sendPlayStatus()
        })
    }
    func configBottomUI(singsDetail: ResourceDetailModel) {
//        imgBackGround.set_Img_Url(singsDetail.album?.imgSmall)
//        imgSings.set_Img_Url(singsDetail.album?.imgSmall)
//        lbSingsTitle.set_text = singsDetail.name
//        lbAlbumName.set_text =  "来自:" + (singsDetail.album?.name ?? "")
//        lbSongProgress.set_text = XBUtil.getDetailTimeWithTimestamp(timeStamp: singsDetail.length)
//        self.resetTimer()
        bottomSongView.lbSingsTitle.set_text = singsDetail.name
        bottomSongView.imgSong.set_Img_Url(singsDetail.album?.imgSmall)
        // 计时器开始工作
        //        self.configTimer(songDuration: Float(singsDetail.duration ?? 0))
    }
    // 获取歌曲详情
    func requestSingsDetail(trackId: Int)  {
        Net.requestWithTarget(.getSingDetail(trackId: trackId),isShowLoding: false,isDissmissLoding: false, successClosure: { (result, code, message) in
            
            guard let result = result as? String else {
                return
            }
//            self.currentSongModel = Mapper<SingDetailModel>().map(JSONString: result)
        })
    }
     // 获取歌曲资源详情
//    func requestResourcesDetail(trackId: Int)  {
//        var params_task = [String: Any]()
//        params_task["clientId"] = XBUserManager.device_Id
//        params_task["resId"] = "aires:" + trackId.toString
//        Net.requestWithTarget(.getResourceDetail(req: params_task), successClosure: { [weak self] (result, code, message) in
//            guard let `self` = self else { return }
//            print(result)
//
//            if let model = Mapper<ResourceDetailModel>().map(JSONObject: result) {
//                self.configBottomSongView(singsDetail: model)
//            }
//
//            //            self.currentSongModel = Mapper<SingDetailModel>().map(JSONString: result)
//            //            self.allTimer = Float(self.currentSongModel?.duration ?? 0)
//            //            self.resetTimer()
//            //            // 获取播放状态
//            //            self.scoketModel.sendPlayStatus()
//        })
//    }
    // 是否隐藏底部 播放 组件
    func showBottomView()  {
        guard XBUserManager.device_Id != "" else {
            bottomSongView.isHidden = true
            return
        }
        bottomSongView.isHidden = false
    }
    //MARK: 添加底部播放视图
    func addBottomSongView()  {
        view.addSubview(bottomSongView)
        bottomSongView.snp.makeConstraints { (make) in
            make.height.equalTo(UIDevice.isX() ? 85 : 65)
            make.left.right.bottom.equalTo(0)
        }
        bottomSongView.btnClickPlay.addAction { [weak self] in
            guard let `self` = self else { return }
            self.toPlayerViewController()
        }
        bottomSongView.btnPlay.addAction {[weak self] in
            guard let `self` = self else { return }
            
            DeviceManager.isOnline { (isOnline, _)  in
                if isOnline {
                   self.bottomSongView.btnPlay.isSelected ?  self.scoketModel.sendPausePlay() : self.scoketModel.sendResumePlay()
                } else {
                    XBHud.showMsg("当前设备不在线")
                }
            }
            
        }
        bottomSongView.btnTrackList.addAction {[weak self] in
            guard let `self` = self else { return }
            DeviceManager.isOnline { (isOnline, _)  in
                if isOnline {
                    self.showTrackListScrollView()
                } else {
                    XBHud.showMsg("当前设备不在线")
                }
            }
            
        }
        bottomSongView.btnDown.addAction {[weak self] in
            guard let `self` = self else { return }
            DeviceManager.isOnline { (isOnline, _)  in
                if isOnline {
                    self.scoketModel.sendSongDown()
                } else {
                    XBHud.showMsg("当前设备不在线")
                }
            }
        }
    }
    //MARK: 底部弹出播放列表
    func showTrackListView(trackList: [EquipmentModel])  {
        let v = PlaySongListView.loadFromNib()
        v.listViewType = .trackList_main
        v.trackArr = trackList
        v.getTrackListIdBlock = {[weak self] (trackId, trackName) in
            guard let `self` = self else { return }
            v.hide()
            VCRouter.toEquipmentSubListVC(trackListId: trackId,navTitle: trackName,trackList: trackList)
            
        }
        v.show()
    }
    func showTrackListScrollView()  {
        let v = TrackListScrollView.loadFromNib()
        v.trackList = self.trackList
        v.show()
    }
    func requestTrackList()  {
        guard XBUserManager.device_Id != "" else {
            self.loading = true
            endRefresh()
            return
        }
        
        Net.requestWithTarget(.getTrackList(deviceId: XBUserManager.device_Id), successClosure: { (result, code, message) in
            print("播单",result)
            if let arr = Mapper<EquipmentModel>().mapArray(JSONString: result as! String) {
                self.loading = true
                self.endRefresh()
                self.trackList = arr
//                self.showTrackListView(trackList: arr)
            }
        }) { (errorMsg) in
 
            self.endRefresh()
        }
    }
    //MARK: 配置底部 播放view

    func configBottomSongView(singsDetail: ResourceDetailModel)  {
        
        bottomSongView.lbSingsTitle.set_text = singsDetail.name
        bottomSongView.imgSong.set_Img_Url(singsDetail.album?.imgSmall)
        
    }
    //MARK: 重置 底部 播放view
    func configResetBottomSongView()  {
        
        bottomSongView.lbSingsTitle.set_text = "暂无播放歌曲"
        bottomSongView.imgSong.set_Img_Url("")
        bottomSongView.btnPlay.isSelected = false
        
    }
    //MARK: 跳转音乐播放器页面
    func toPlayerViewController()  {
        if bottomSongView.lbSingsTitle.set_text == "暂无歌曲" {
            return
        }
        VCRouter.toPlayVC()

    }
    /**
     *   点击顶部按钮
     */
    @IBAction func clickTopNavItemAction(_ sender: UIButton) {
        for navItem in self.topItemStackView.subviews {
            if let navItem = navItem as? ContentTopNavItem {
                if navItem.tag == sender.tag {
                    navItem.isSelect = true
                }else {
                    navItem.isSelect = false
                }
            }
        }
        v.switch(toPage: UInt(sender.tag), animated: true)
    }

    //MARK:配置所对应的左右滑动ViewControler
    func configMagicView()  {
        v                                       = VCVTMagic()
        v.magicView.dataSource                  = self
        v.magicView.delegate                    = self
        v.magicView.needPreloading      = false
        v.magicView.navigationView.isHidden = true
        v.magicView.navigationHeight = 0
        let vc = ContentVC()
        let vc1 = LikeViewController()
        let vc2 = HistoryViewController()
        let vc3 = TrackListViewController()
        controllerArray = [vc3,vc,vc1,vc2]
        v.currentViewController = vc

        v.magicView.frame = CGRect.init(x: 0, y: 0, w: MGScreenWidth, h: viewContainer.height)
        self.viewContainer.addSubview(v.magicView)

        v.magicView.reloadData(toPage: 1)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        v.magicView.h = self.viewContainer.h
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
//MARK:VTMagicViewDataSource
extension ContentMainVC:VTMagicViewDataSource{
    var identifier_magic_view_bar_item : String {
        get {
            return "identifier_magic_view_bar_item"
        }
    }
    var identifier_magic_view_page : String {
        get {
            return "identifier_magic_view_page"
        }
    }
    func menuTitles(for magicView: VTMagicView) -> [String] {
        
        return ["内容","收藏","搜索","搜索"]
        
    }
    func magicView(_ magicView: VTMagicView, menuItemAt itemIndex: UInt) -> UIButton{
        let button = magicView .dequeueReusableItem(withIdentifier: self.identifier_magic_view_bar_item)
        
        if ( button == nil) {
            let width           = self.view.frame.width / 3
            let b               = UIButton(type: .custom)
            b.frame             = CGRect(x: 0, y: 0, width: width, height: 50)
            b.titleLabel!.font  =  UIFont.systemFont(ofSize: 14)
            b.setTitleColor(MGRgb(0, g: 0, b: 0, alpha: 0.3), for: UIControlState())
            b.setTitleColor(UIColor.white, for: .selected)
            b.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            
            return b
        }
        
        return button!
    }
    @objc func buttonAction(){
        //        DLog("button")
    }
    func magicView(_ magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController{
        return controllerArray[Int(pageIndex)]
    }
}
//MARK:VTMagicViewDelegate
extension ContentMainVC :VTMagicViewDelegate{
    
    func magicView(_ magicView: VTMagicView, viewDidAppear viewController: UIViewController, atPage pageIndex: UInt){
        print("pageIndex",pageIndex)
//        for sub_View in self.topItemStackView.subviews {  // 遍历 子View 找出Btn改变其状态
            for navItem in self.topItemStackView.subviews {
                if let navItem = navItem as? ContentTopNavItem {
                    if navItem.tag == pageIndex {
//                        b.isSelected = true
                        navItem.isSelect = true
                    }else {
                        navItem.isSelect = false
//                        navItem.lbName.font = UIFont.systemFont(ofSize: 14)
                    }
                }
            }
//        }
    }
    
    func magicView(_ magicView: VTMagicView, didSelectItemAt itemIndex: UInt){
        print("itemIndex",itemIndex)
    }
    
}
extension ContentMainVC: EMChatManagerDelegate {
    // 收到消息
    func messagesDidReceive(_ aMessages: [Any]!) {
        print("收到消息", aMessages)
        self.setupUnreadMessageCount()
    }
    
}
