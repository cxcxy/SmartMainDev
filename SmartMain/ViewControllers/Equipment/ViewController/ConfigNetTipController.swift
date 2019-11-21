//
//  ConfigNetTipController.swift
//  SmartMain
//
//  Created by mac on 2018/9/27.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import SVProgressHUD

class ConfigNetTipController: XBBaseViewController {
    
    @IBOutlet weak var viewSrollViewContainer: UIView!
    @IBOutlet weak var btnNext: UIButton!
    var viewModel = EquimentViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setUI() {
        super.setUI()
        title = "设备配网"
        btnNext.radius_ll()
        self.configTopScrollView()
        makeCustomerImageNavigationItem("icon_net_tip", left: false) { [weak self] in
            guard let `self` = self else { return }
            self.showTipView()
        }
    }
    func showTipView()  {
        let v = NetConfigTipView.loadFromNib()
        v.show()
    }
    func configTopScrollView()  {
        let v = Cell_801_Product.loadFromNib()
        v.frame = self.viewSrollViewContainer.bounds
        let model1 = ConfigNetModel()
        model1.title = "第1步：开启设备"
        model1.des = "请将电源键打开至“ON”将设备开启"
        model1.img = "net-1"
        let model2 = ConfigNetModel()
        model2.title = "第2步：进入联网模式"
        model2.des = "请同时长安设备上“音量+”，“音量-”按键，直到听到“等待配置中”的提示音"
        model2.img = "net-2"
        let model3 = ConfigNetModel()
        model3.title = "第3步：配置网络"
        model3.des = "请点击“一键配网”设置您的无线网络"
        model3.img = "net-3"
        let model4 = ConfigNetModel()
        model4.title = "第4步：声波配网"
        model4.des = "请将手机靠近设备尽量选择安静的环境"
        model4.img = "net-4"
        v.dataSourceArray = [model1,model2,model3,model4]
        self.viewSrollViewContainer.addSubview(v)
    }
    @IBAction func clickConfigAction(_ sender: Any) {
        self.requestVoice()
    }
    func playVoice(url: String)  {
        guard let urlTask =  URL.init(string: url) else {
            XBLog("url 转化失败")
            return
        }
        let playerItem:AVPlayerItem = AVPlayerItem.init(url: urlTask)
        // 创建 AVPlayer 播放器
        let player:AVPlayer = AVPlayer(playerItem: playerItem)
        // 将 AVPlayer 添加到 AVPlayerLayer 上
        let playerLayer:AVPlayerLayer = AVPlayerLayer(player: player)
        // 设置播放页面大小
        playerLayer.frame = CGRect.init(x: 10, y: 30, w: self.view.bounds.size.width - 20, h: 200)
        // 设置画面缩放模式
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        // 在视图上添加播放器
        self.view.layer.addSublayer(playerLayer)
        // 开始播放
        player.play()
        //        SVProgressHUD.showProgress(5, status: "配置网络中")
//        XBHud.showConfigNetMsg()
        let v = NetConfigLoading.loadFromNib()
        v.show()
        XBDelay.start(delay: 5) {
            v.hide()
            self.sureVoiceDevice(url: url)
        }
    }
    func sureVoiceDevice(url: String) {
        XBHud.dismiss()
        let v = NetSuccessView.loadFromNib()
        v.btnSuccess.addAction {[weak self] in
            guard let `self` = self else { return }
            v.hide()
            self.sureNetSuccess()
        }
        v.btnError.addAction {[weak self] in
            guard let `self` = self else { return }
            v.hide()
            self.playVoice(url: url)
        }
        v.show()
        
    }
    func sureNetSuccess()  {
        self.popVC()
    }
    func requestVoice()  {
//        guard XBUserManager.device_Id != "" else {
//            XBHud.showWarnMsg("请先绑定设备")
//            return
//        }
//        guard configNetInfo.name != "" else {
//            XBHud.showMsg("请输入WIFI名称")
//            self.currentIndex = 1
//            let index = IndexPath.init(row: 1, section: 0)
//            //            collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
//            return
//        }
//        guard configNetInfo.password != "" else {
//            XBHud.showMsg("请输入WIFI密码")
//            self.currentIndex = 1
//            let index = IndexPath.init(row: 1, section: 0)
//            //            collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
//            return
//        }
//        viewModel.requestGetVoice(ssid: configNetInfo.name, password: configNetInfo.password, openId: XBUserManager.userName, deviceId: XBUserManager.device_Id) {[weak self] (voiceURL) in
//            guard let `self` = self else { return }
//            self.playVoice(url: voiceURL)
//        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: 一键配网
    @IBAction func clickOnNextAction(_ sender: UIButton) {
        let vc = ConfigNetInfoController()
        self.pushVC(vc)
    }
   
}
