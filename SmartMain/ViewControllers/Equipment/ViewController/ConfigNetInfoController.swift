//
//  ConfigNetInfoController.swift
//  SmartMain
//
//  Created by mac on 2018/12/4.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import SVProgressHUD
class ConfigNetInfoController: XBBaseViewController {

    @IBOutlet weak var btnSure: UIButton!
    @IBOutlet weak var textName: XBTextView!
    @IBOutlet weak var textPass: XBTextView!
     var viewModel = EquimentViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "配置网络"
    }
    override func setUI() {
        super.setUI()
        btnSure.radius_ll()
    }
    @IBAction func clickSureAction(_ sender: Any) {
        self.requestVoice()
    }
    func requestVoice()  {
        guard XBUserManager.device_Id != "" else {
            XBHud.showWarnMsg("请先绑定设备")
            return
        }
        guard textName.text != "" else {
            XBHud.showMsg("请输入WIFI名称")
            return
        }
        guard textPass.text != "" else {
            XBHud.showMsg("请输入WIFI密码")
            return
        }
        viewModel.requestGetVoice(ssid: textName.text!, password: textPass.text!, openId: XBUserManager.userName, deviceId: XBUserManager.device_Id) {[weak self] (voiceURL) in
            guard let `self` = self else { return }
            self.playVoice(url: voiceURL)
        }
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
        self.popToRootVC()
    }
}
