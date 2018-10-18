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
class ContentMainVC: XBBaseViewController {
    var controllerArray     : [UIViewController] = []  // 存放controller 的array
    var v                   : VCVTMagic!  // 统一的左滑 右滑 控制View
    var bottomSongView = BottomSongView.loadFromNib()
    var navMessageView = ChatRedView.loadFromNib()
    let scoketModel = ScoketMQTTManager.share
     var currentDeviceId: String?
    var currentSongModel:SingDetailModel? { // 当前正在播放歌曲的信息
        didSet {
            guard let m = currentSongModel else {
                return
            }
            self.configBottomSongView(singsDetail: m)
        }
    }
    var viewModel = EquimentViewModel()
    var viewModelLogin = LoginViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentNavigationTitleColor = UIColor.white
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let currentDeviceId = currentDeviceId else {
            return
        }
        if currentDeviceId != XBUserManager.device_Id{  // 如果当前的设备ID有变化 重新拉去请求 ,重新拉去当前MQTT 命令，重新配置底部播放view
            request()
            configResetBottomSongView()
            configScoketModel()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUnreadMessageCount()
    }
    //MARK: 设置未读消息数量
    func setupUnreadMessageCount()  {
        let conversations = EMClient.shared()?.chatManager.getAllConversations() as? [EMConversation]
        var unreadCount = 0
        for item in conversations ?? [] {
            unreadCount += Int(item.unreadMessagesCount)
        }
        if unreadCount > 0 {
            self.navMessageView.viewRed.isHidden = false
        }else {
            self.navMessageView.viewRed.isHidden = true
        }
        print("未读消息数量" , unreadCount)
    }
    override func setUI() {
        super.setUI()
        configMagicView()
        addBottomSongView()
        /// 当切换设备或者绑定设备的时候，重新订阅 scoket MQTT 信息
        _ = Noti(.refreshDeviceHistory).takeUntil(self.rx.deallocated).subscribe(onNext: {[weak self] (value) in
            guard let `self` = self else { return }
            self.configScoketModel()
        })
        configScoketModel()
        configNavBarItem()
        configChatMessage()
//        self.registerShowIntractiveWithEdgeGesture()
        XBDelay.start(delay: 1) {
            self.setupUnreadMessageCount()
        }
        self.request()
    }
    
    override func request()  {
        super.request()

        self.currentDeviceId = XBUserManager.device_Id
        guard XBUserManager.device_Id != "" else {
            self.loading = true
            endRefresh()
            self.title = "暂无绑定设备"
            return
        }
        viewModelLogin.requestGetUserInfo(mobile: XBUserManager.userName) { [weak self] in // 获取最新的用户信息
            guard let `self` = self else { return }
            self.requestDevicesBabyInfo()
        }

    }
    //MARK: 获取最新的设备信息
    func requestDevicesBabyInfo() {
        viewModelLogin.requestGetBabyInfo(device_Id: XBUserManager.device_Id) {[weak self] in
            guard let `self` = self else { return }
            self.title = XBUserManager.nickname + "的" +  XBUserManager.dv_babyname
        }
    }
    //MARK: 配置导航条左右Item
    func configNavBarItem()  {
        makeCustomerImageNavigationItem("iconmenu", left: true) {[weak self] in
            guard let `self` = self else { return }
            self.maskAnimationFromLeft()
        }
        
        navMessageView.viewMessage.addTapGesture { [weak self](sender) in
            guard let `self` = self else { return }
            let vc = ChatMainViewController()
            self.pushVC(vc)
        }
        navMessageView.viewSearch.addTapGesture { [weak self](sender) in
            guard let `self` = self else { return }
            let vc = SearchViewController()
            self.pushVC(vc)
        }
        makeRightNavigationItem(navMessageView, left: false)
    }
    //MARK: 配置环信聊天
    func configChatMessage()  {
        EMClient.shared().chatManager.add(self, delegateQueue: nil)
    }
    deinit {
        EMClient.shared()?.chatManager.remove(self)
    }
    //MARK: 配置scoket 链接
    func configScoketModel() {
        guard XBUserManager.device_Id != "" else {
            configResetBottomSongView()
            return
        }
        scoketModel.sendGetTrack()
        scoketModel.sendPlayStatus()
        scoketModel.getPalyingSingsId.asObservable().subscribe { [weak self] in
            guard let `self` = self else { return }
            print("getPalyingSingsId ===：", $0.element ?? 0)
            self.requestSingsDetail(trackId: $0.element ?? 0)
        }.disposed(by: rx_disposeBag)
        scoketModel.playStatus.asObserver().bind(to: bottomSongView.btnPlay.rx.isSelected).disposed(by: rx_disposeBag)
    }
    // 获取歌曲详情
    func requestSingsDetail(trackId: Int)  {
        Net.requestWithTarget(.getSingDetail(trackId: trackId),isShowLoding: false,isDissmissLoding: false, successClosure: { (result, code, message) in
            
            guard let result = result as? String else {
                return
            }
            self.currentSongModel = Mapper<SingDetailModel>().map(JSONString: result)
        })
    }
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
            make.height.equalTo(80)
            make.left.right.bottom.equalTo(0)
        }
        bottomSongView.imgSong.addTapGesture {[weak self] (sender) in
            guard let `self` = self else { return }
            self.toPlayerViewController()
        }
        bottomSongView.btnPlay.addAction {[weak self] in
            guard let `self` = self else { return }
            self.bottomSongView.btnPlay.isSelected ?  self.scoketModel.sendPausePlay() : self.scoketModel.sendResumePlay()
        }
        bottomSongView.btnTrackList.addAction {[weak self] in
            guard let `self` = self else { return }
            self.requestTrackList()
        }
        bottomSongView.btnDown.addAction {[weak self] in
            guard let `self` = self else { return }
            self.scoketModel.sendSongDown()
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
//            let model = dataArr[indexPath.row]
            VCRouter.toEquipmentSubListVC(trackListId: trackId,navTitle: trackName,trackList: trackList)
            
        }
        v.show()
    }
    func requestTrackList()  {
        guard XBUserManager.device_Id != "" else {
            self.loading = true
            endRefresh()
            return
        }
        
        Net.requestWithTarget(.getTrackList(deviceId: XBUserManager.device_Id), successClosure: { (result, code, message) in
            if let arr = Mapper<EquipmentModel>().mapArray(JSONString: result as! String) {
                self.loading = true
                self.endRefresh()
                self.showTrackListView(trackList: arr)
            }
        }) { (errorMsg) in
 
            self.endRefresh()
        }
    }
    //MARK: 配置底部 播放view
    func configBottomSongView(singsDetail: SingDetailModel)  {
        
        bottomSongView.lbSingsTitle.set_text = singsDetail.title
        bottomSongView.imgSong.set_Img_Url(singsDetail.coverSmallUrl)
        
    }
    //MARK: 重置 底部 播放view
    func configResetBottomSongView()  {
        
        bottomSongView.lbSingsTitle.set_text = "暂无播放歌曲"
        bottomSongView.imgSong.set_Img_Url("")
        bottomSongView.btnPlay.isSelected = false
        
    }
    //MARK: 跳转音乐播放器页面
    func toPlayerViewController()  {
        VCRouter.toPlayVC()
//        DeviceManager.isOnline { (isOnline, _)  in
//            if isOnline {
//                let vc = SmartPlayerViewController()
//                self.pushVC(vc)
//            } else {
//
//                XBHud.showMsg("当前设备不在线")
//            }
//        }
        
    }
    func maskAnimationFromLeft() {
        let drawerViewController = DrawerViewController()
        self.cw_showDrawerViewController(drawerViewController,
                                         animationType: .mask,
                                         configuration: CWLateralSlideConfiguration())
    }
    func registerShowIntractiveWithEdgeGesture()  {
        self.cw_registerShowIntractive(withEdgeGesture: true) {[weak self] (direction) in
             guard let `self` = self else { return }
            if direction == .fromLeft {
                self.maskAnimationFromLeft()
            }
        }
    }
    //MARK:配置所对应的左右滑动ViewControler
    func configMagicView()  {
        v                                       = VCVTMagic()
        v.magicView.dataSource                  = self
        v.magicView.delegate                    = self
        v.magicView.needPreloading      = false
        let vc = ContentVC.init(style: .grouped)
//        let vc_list = TrackListViewController()
        let vc1 = LikeViewController()
        let vc2 = HistoryViewController()
        
        controllerArray = [vc,vc1,vc2]
        v.magicView.reloadData()
        self.addChildViewController(v)
        self.view.addSubview(v.magicView)
        v.magicView.snp.makeConstraints {[weak self] (make) -> Void in
            if let strongSelf = self {
                make.size.equalTo(strongSelf.view)
                
            }
        }
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
        
        return ["内容","收藏","历史"]
        
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
        
    }
    
    func magicView(_ magicView: VTMagicView, didSelectItemAt itemIndex: UInt){
        
    }
    
}
extension ContentMainVC: EMChatManagerDelegate {
    // 收到消息
    func messagesDidReceive(_ aMessages: [Any]!) {
        print("收到消息", aMessages)
        self.setupUnreadMessageCount()
    }
}
