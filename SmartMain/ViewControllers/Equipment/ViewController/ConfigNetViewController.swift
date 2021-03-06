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
import SVProgressHUD
class NetInfo: NSObject {
    
    var name: String = XBUtil.getUsedSSID()
    var password: String = ""
    
}
class ConfigNetViewController: XBBaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightLayout: NSLayoutConstraint!
//    @IBOutlet weak var tfWifiName: UITextField!
    
//    @IBOutlet weak var tfWifiPass: UITextField!
    
    var btnNextText : [String] = ["成功开启，下一步","成功链接，下一步","成功联网，下一步","开始配网"]
    
    @IBOutlet weak var btnOn: UIButton!
    
    @IBOutlet weak var btnNext: UIButton!
    var currentIndex: Int = 0 {
        didSet{
            btnNext.set_Title(btnNextText[currentIndex])
        }
    }
    var configNetInfo = NetInfo()
    var itemWidht = Int(MGScreenWidth * 0.7)
    var itemHeight = Int(MGScreenWidth * 0.7 * 1.5)
//    @IBOutlet weak var btnConfig: UIButton!
    var viewModel = EquimentViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func setUI() {
        super.setUI()
        title = "设备配网"
//        btnConfig.radius_ll()
        btnNext.radius_ll()
        btnOn.radius_ll()
        btnOn.addBorder(width: 0.5, color: viewColor)
//        self.configNetInfo.name = self.getUsedSSID()
        self.configCollectionView()
//        tfWifiName.text = self.getUsedSSID()
        btnNext.set_Title(btnNextText[currentIndex])
        view.backgroundColor = UIColor.init(hexString: "C0E1AB")
        self.configTopScrollView()
    }
    func configCollectionView()  {
        collectionView.cellId_register("ConfigNetCVCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        heightLayout.constant = CGFloat(itemHeight)
    }
    func configTopScrollView()  {
        let v = Cell_801_Product.loadFromNib()
        v.frame = CGRect.init(x: 0, y: 0, w: MGScreenWidth, h: MGScreenHeight - 100)
        let model1 = ConfigNetModel()
        model1.title = "第1步：开启设备"
        model1.des = "请将电源键打开至“ON”将设备开启"
        let model2 = ConfigNetModel()
        model2.title = "第2步：进入联网模式"
        model2.des = "请同时长安设备上“音量+”，“音量-”按键，直到听到“等待配置中”的提示音"
        let model3 = ConfigNetModel()
        model3.title = "第3步：配置网络"
        model3.des = "请点击“一键配网”设置您的无线网络"
        let model4 = ConfigNetModel()
        model4.title = "第4步：声波配网"
        model4.des = "请将手机靠近设备尽量选择安静的环境"
        v.dataSourceArray = [model1,model2,model3,model4]
        self.view.addSubview(v)
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
        XBHud.showConfigNetMsg()
        XBDelay.start(delay: 5) {
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
        guard XBUserManager.device_Id != "" else {
            XBHud.showWarnMsg("请先绑定设备")
            return
        }
        guard configNetInfo.name != "" else {
            XBHud.showMsg("请输入WIFI名称")
            self.currentIndex = 1
            let index = IndexPath.init(row: 1, section: 0)
            collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            return
        }
        guard configNetInfo.password != "" else {
            XBHud.showMsg("请输入WIFI密码")
            self.currentIndex = 1
            let index = IndexPath.init(row: 1, section: 0)
            collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            return
        }
        viewModel.requestGetVoice(ssid: configNetInfo.name, password: configNetInfo.password, openId: XBUserManager.userName, deviceId: XBUserManager.device_Id) {[weak self] (voiceURL) in
            guard let `self` = self else { return }
            self.playVoice(url: voiceURL)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickOnNextAction(_ sender: UIButton) {
        if currentIndex >= 3 {
            self.requestVoice()
            return
        }
        currentIndex = currentIndex + 1
        let index = IndexPath.init(row: currentIndex, section: 0)
        collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        print(self.configNetInfo.name,self.configNetInfo.password)
    }
    //MARK: 上一步
    @IBAction func clickOnAction(_ sender: UIButton) {
        if currentIndex == 0 {
            XBHud.showMsg("当前是第一步哦～")
            return
        }
        currentIndex = currentIndex - 1
        let index = IndexPath.init(row: currentIndex, section: 0)
        collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        print(self.configNetInfo.name,self.configNetInfo.password)
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
extension ConfigNetViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConfigNetCVCell", for: indexPath)as! ConfigNetCVCell
        cell.configNetInfo = self.configNetInfo
        cell.currentIndex = indexPath.row
        return cell
    }
    
    //最小item间距
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 20
//    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 50, bottom: 0, right: 50)
    }
    //item 的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemWidht , height: itemHeight)
    }
    //item 对应的点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
 
    }
    func clickOutAction(groupOwner: Bool,groupId: String)  {
   
    }
}
