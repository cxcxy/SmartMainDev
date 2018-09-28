//
//  ConfigNetViewController.swift
//  SmartMain
//
//  Created by mac on 2018/9/27.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import SystemConfiguration
import SystemConfiguration.CaptiveNetwork
class ConfigNetViewController: XBBaseViewController {

    @IBOutlet weak var tfWifiName: UITextField!
    
    @IBOutlet weak var tfWifiPass: UITextField!
    
    @IBOutlet weak var btnConfig: UIButton!
    var viewModel = EquimentViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func setUI() {
        super.setUI()
        title = "设备配网"
        btnConfig.radius_ll()
        tfWifiName.text = self.getUsedSSID()
    }
    ///
    /// - Returns: 当前手机链接的wifi名称
    func getUsedSSID() -> String {
        let interfaces = CNCopySupportedInterfaces()
        var ssid = ""
        if interfaces != nil {
            let interfacesArray = CFBridgingRetain(interfaces) as! Array<AnyObject>
            if interfacesArray.count > 0 {
                let interfaceName = interfacesArray[0] as! CFString
                let ussafeInterfaceData = CNCopyCurrentNetworkInfo(interfaceName)
                if (ussafeInterfaceData != nil) {
                    let interfaceData = ussafeInterfaceData as! Dictionary<String, Any>
                    ssid = interfaceData["SSID"]! as! String
                }
            }
        }
        return ssid
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
        
        XBDelay.start(delay: 5) {
            self.sureVoiceDevice(url: url)
        }
    }
    func sureVoiceDevice(url: String) {
        let alertC = UIAlertController(title: "温馨提示", message: "机器是否配网成功？", preferredStyle: .alert)
        let alertSure = UIAlertAction(title: "是的", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
        })
        let alertCancel = UIAlertAction(title: "没有", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            self.playVoice(url: url)
        })
        alertC.addAction(alertCancel)
        alertC.addAction(alertSure)
        
        self.presentVC(alertC)
    }
    func requestVoice()  {
        guard XBUserManager.device_Id != "" else {
            XBHud.showWarnMsg("请先绑定设备")
            return
        }
        viewModel.requestGetVoice(ssid: tfWifiName.text!, password: tfWifiPass.text!, openId: XBUserManager.userName, deviceId: XBUserManager.device_Id) {[weak self] (voiceURL) in
            guard let `self` = self else { return }
            self.playVoice(url: voiceURL)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
