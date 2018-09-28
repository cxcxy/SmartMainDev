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
    let scoketModel = ScoketMQTTManager.share
    var currentSongModel:SingDetailModel? { // 当前正在播放歌曲的信息
        didSet {
            guard let m = currentSongModel else {
                return
            }
            self.configBottomSongView(singsDetail: m)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentNavigationTitleColor = UIColor.white
    }
    override func setUI() {
        super.setUI()
        self.title = "内容"
       
        configMagicView()
        addBottomSongView()
        configScoketModel()
        makeCustomerImageNavigationItem("icon-dr", left: true) {[weak self] in
            guard let `self` = self else { return }
            self.maskAnimationFromLeft()
        }
        //MARK: 点击添加商家
        makeCustomerImageNavigationItem("icon_tianjia", left: false) {
//            VCRouter.qrCodeScanVC()
            let vc = ChatMainViewController()
            self.pushVC(vc)
        }

    }
    func configScoketModel() {
        guard XBUserManager.device_Id != "" else {
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
        Net.requestWithTarget(.getSingDetail(trackId: trackId), successClosure: { (result, code, message) in
            
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
    func addBottomSongView()  {
        view.addSubview(bottomSongView)
        bottomSongView.snp.makeConstraints { (make) in
            make.height.equalTo(80)
            make.left.right.bottom.equalTo(0)
        }
        bottomSongView.imgSong.addTapGesture { (sender) in
            let vc = SmartPlayerViewController()
            self.pushVC(vc)
        }
        bottomSongView.btnPlay.addAction {[weak self] in
            guard let `self` = self else { return }
            self.bottomSongView.btnPlay.isSelected ?  self.scoketModel.sendPausePlay() : self.scoketModel.sendResumePlay()
        }
    }
    func configBottomSongView(singsDetail: SingDetailModel)  {
//        imgSings.set_Img_Url(singsDetail.coverSmallUrl)
//        lbSingsTitle.set_text = singsDetail.title
//        lbSongProgress.set_text = XBUtil.getDetailTimeWithTimestamp(timeStamp: singsDetail.duration)
        bottomSongView.lbSingsTitle.set_text = singsDetail.title
        bottomSongView.imgSong.set_Img_Url(singsDetail.coverSmallUrl)
        
    }
    func maskAnimationFromLeft() {
        let drawerViewController = DrawerViewController()
        self.cw_showDrawerViewController(drawerViewController,
                                         animationType: .mask,
                                         configuration: CWLateralSlideConfiguration())
    }
    //MARK:配置所对应的左右滑动ViewControler
    func configMagicView()  {
        v                                       = VCVTMagic()
        v.magicView.dataSource                  = self
        v.magicView.delegate                    = self
        v.magicView.needPreloading      = false
        let vc = ContentVC()
        let vc_list = TrackListViewController()
        let vc1 = LikeViewController()
        let vc2 = HistoryViewController()
        
        controllerArray = [vc,vc_list,vc1,vc2]
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
        
        return ["内容","歌单","收藏","历史"]
        
    }
    func magicView(_ magicView: VTMagicView, menuItemAt itemIndex: UInt) -> UIButton{
        let button = magicView .dequeueReusableItem(withIdentifier: self.identifier_magic_view_bar_item)
        
        if ( button == nil) {
            let width           = self.view.frame.width / 3
            let b               = UIButton(type: .custom)
            b.frame             = CGRect(x: 0, y: 0, width: width, height: 50)
            b.titleLabel!.font  =  UIFont.systemFont(ofSize: 14)
            b.setTitleColor(MGRgb(128, g: 140, b: 155), for: UIControlState())
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
