//
//  DrawerViewController.swift
//  SmartMain
//
//  Created by mac on 2018/9/20.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
class DrawerSectionItme: NSObject {
    var section: Int = 0
    var items: [XBStyleCellModel] = []
}
class DrawerViewController: XBBaseViewController {
    var one1    = XBStyleCellModel.init(title: "儿童锁", imgIcon: "icon_menu_unlock",isSwitchOpen: false, cellType: 11)
    var one2    = XBStyleCellModel.init(title: "呼吸灯", imgIcon: "icon_menu_unlamp",isSwitchOpen: false, cellType: 12)
    var one3    = XBStyleCellModel.init(title: "音量调整", imgIcon: "icon_menu_volume", content: "",cellType: 13)
    var one4    = XBStyleCellModel.init(title: "定时休眠", imgIcon: "icon_menu_unsleep", content: "",cellType: 14)
    
    @IBOutlet weak var imgNext: UIImageView!
    var eqOne    = XBStyleCellModel.init(title: "设备连接", imgIcon: "icon_menu_connection",cellType: 1)
    var eqTwo    = XBStyleCellModel.init(title: "绑定设备", imgIcon: "icon_group2",cellType: 2)
    var eqThree  = XBStyleCellModel.init(title: "选择设备", imgIcon: "icon_menu_cloose",cellType: 3)
    var eqFour   = XBStyleCellModel.init(title: "设备成员", imgIcon: "icon_menu_member",cellType: 7)
    var accountOne  = XBStyleCellModel.init(title: "用户信息", imgIcon: "icon_menu_info",cellType: 4)
    var accountTwo  = XBStyleCellModel.init(title: "关于", imgIcon: "icon_menu_about",cellType: 5)
    var accountThree  = XBStyleCellModel.init(title: "退出登录", imgIcon: "icon_group6",cellType: 6)
    var eqArr: [XBStyleCellModel] = []
    var accountArr: [XBStyleCellModel] = []

    var sectionData: [DrawerSectionItme] = []
    
    @IBOutlet weak var imgWifi: UIImageView!
//    @IBOutlet weak var imgElectricity: UIImageView!
    @IBOutlet weak var lbElectricity: UILabel!
     @IBOutlet weak var imgElectricity: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var lbDvnick: UILabel!
    
    @IBOutlet weak var bottomLayout: NSLayoutConstraint!
    @IBOutlet weak var viewTopInfo: UIView!
//    @IBOutlet weak var lbLock: UILabel!
//    @IBOutlet weak var imgLight: UIImageView!
//    @IBOutlet weak var lbLight: UILabel!
    
//    @IBOutlet weak var mneuStackview: UIStackView!
//    @IBOutlet weak var heightMneuLayout: NSLayoutConstraint!
    
//    @IBOutlet weak var leftMnueLayout: NSLayoutConstraint!
//    @IBOutlet weak var rightMnueLayout: NSLayoutConstraint!
    
//    @IBOutlet weak var btnLock: UIButton!
//    @IBOutlet weak var btnLight: UIButton!
//    @IBOutlet weak var btnVolume: UIButton!
//    @IBOutlet weak var btnSleep: UIButton!
    
    
    @IBOutlet weak var topTableLayout: NSLayoutConstraint!
    
    let scoketModel = ScoketMQTTManager.share
    
    var viewModel = LoginViewModel()
    var deviceOnline:Bool = false {
        didSet {
            imgWifi.set_img = deviceOnline ? "icon_wifi" : "icon_unwifi"
        }
    }
    lazy var popWindow:UIWindow = {
        let w = UIApplication.shared.delegate as! AppDelegate
        return w.window!
    }()
    var viewDeviceModel = EquimentViewModel()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
////        ImageCache.default.removeImage(forKey: XBUserManager.dv_headimgurl)
//        if let headImgUrl = user_defaults.get(for: .headImgUrl){
//            ImageCache.default.removeImage(forKey: headImgUrl)
//        }
        self.cofigDeviceInfo()
        self.getDeviceBabyInfo()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if UIDevice.deviceType == .dt_iPhone5 {
//            heightMneuLayout.constant = 80
//            mneuStackview.spacing = 8
//            leftMnueLayout.constant = 8
//            rightMnueLayout.constant = 8
//        }
        self.currentNavigationHidden = true
        bottomLayout.adapterTop_X()
    }
    
    override func setUI() {
        super.setUI()

        self.configTableView(tableView, register_cell: ["DrawFromCell"])
        self.cofigDeviceInfo()
        view.backgroundColor = viewColor
        viewTopInfo.addTapGesture {[weak self] (sender) in
            guard let `self` = self else { return }
//            let vc = EquipmentSettingVC()
//            self.pushVC(vc)
            if XBUserManager.device_Id != ""  {
                VCRouter.toEquipmentSettingVC()
            }
            
        }
        
        self.getDeviceBabyInfo()
        


    }
    func getDeviceBabyInfo() { // 获取设备信息
//        guard XBUserManager.device_Id != "" else {
//            self.getDeviceBabyInfo()
//            return
//        }
        viewModel.requestGetBabyInfo(device_Id: XBUserManager.device_Id) {[weak self] (isTrue)in
            guard let `self` = self else { return }
            self.configUserInfo()
        }
        DeviceManager.isOnline(isCheckDevices: false) { (isOnline, electricity)  in
            self.deviceOnline = isOnline
            //            if electricity == 101 { // 当前正在充电
            //                self.lbElectricity.isHidden = true
            //                self.imgElectricity.set_img = "icon_charging"
            //            }else {
            //                self.lbElectricity.isHidden = false
            //                self.lbElectricity.set_text = electricity.toString
            //                self.imgElectricity.set_img = "icon_electricity"
            //            }
            
        }
    }
//    override func request() {
//        super.request()
//        viewModel.requestGetUserInfo(mobile: XBUserManager.userName) { [weak self] in
//            guard let `self` = self else { return }
//            self.cofigDeviceInfo()
//        }
//    }
    // 配置 设备信息 数据
    func cofigDeviceInfo()  { // ！ 这个应该在首页写
        if XBUserManager.userDevices.count > 0 && XBUserManager.device_Id != ""  { // 有绑定设备
                topTableLayout.constant = 0
            
                let model1 = DrawerSectionItme.init()
                model1.section = 1
                model1.items = [one1,one2,one3,one4]
                let model2 = DrawerSectionItme.init()
                model2.section = 2
                model2.items = [eqOne,eqThree,eqFour]
                let model3 = DrawerSectionItme.init()
                model3.section = 3
                model3.items = [accountOne, accountTwo]
                self.sectionData = [model1,model2,model3]
            
                eqArr       = [eqOne,eqTwo, eqThree, eqFour]
                accountArr  = [accountOne, accountTwo]
                getMQTT()
            
        } else {
            let model3 = DrawerSectionItme.init()
            model3.section = 3
            model3.items = [accountOne, accountTwo]
            self.sectionData = [model3]
//            topTableLayout.constant = 0
//            eqArr       = [eqTwo]
//            accountArr  = [accountTwo,accountThree]
        }
//        self.configUserInfo()
        
    }
    func configUserInfo()  {
        imgPhoto.roundView()
        
//        lbDvnick.set_text = XBUserManager.nickname
        if XBUserManager.device_Id == ""{
            lbDvnick.set_text = "未绑定设备"
            imgNext.isHidden = true
            imgPhoto.image = UIImage.init(named: "icon_photo")
        }else {
            lbDvnick.set_text = XBUserManager.dv_babyname
            imgNext.isHidden = false
            imgPhoto.set_Img_Url(user_defaults.get(for: .dv_headimgurl))
        }
        
        self.tableView.reloadData()
    }
    
    @IBAction func clickBindingAction(_ sender: Any) {
        self.toQRCodeVC()
    }
    
    @IBAction func clickLoginOutAction(_ sender: Any) {
        loginOutAction()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension DrawerViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionData.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sectionData[section].items.count
        
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return section == 0 ? XBMin : 0.5
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 0 ? nil : getAccountView()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrawFromCell", for: indexPath) as! DrawFromCell
        let item  = sectionData[indexPath.section].items[indexPath.row]
        cell.modelData = item
        cell.delegate = self
        
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = sectionData[indexPath.section].items[indexPath.row]
        print(model.title)
        switch model.cellType {
        case 13:
            self.toVolumeAction()
            break
        case 14:
            self.toSleepAction()
            break
        case 1:
            let vc = ConfigNetTipController()
            self.pushVC(vc)

        case 2:
            self.toQRCodeVC()
        case 3:
            let vc = EquipmentListViewController()
            self.pushVC(vc)
        case 4:
//            let vc = SetInfoViewController()
//            vc.setInfoType = .editUserInfo
//            self.pushVC(vc)
             VCRouter.toEquipmentSettingVC(settingType: .user)
            
        case 5:
            let vc = AccountInfoViewController()
            self.pushVC(vc)
        case 6:
            
            break
        case 7:
            let vc = MemberManagerVC()
            self.pushVC(vc)
            break
        default:
            break
        }
    }
    func loginOutAction()  {
        let out = XBLoginOutView.loadFromNib()
        out.sureBlock = { [weak self] in
            guard let `self` = self else { return }
            XBUserManager.cleanUserInfo()
            XBUserManager.clearDeviceInfo()
            if (EMClient.shared()?.logout(true)) == nil {
                print("退出登录成功")
            }
            self.dismissVC(completion: {[weak self] in
                guard let `self` = self else { return }
                let sv = UIStoryboard.getVC("Main", identifier:"LoginNav") as! XBBaseNavigation
                self.popWindow.rootViewController = sv
            })

            
        }
        out.show()
    }
    // 解除设备操作，第一步，查询当前用户是否为 管理员
    func quitEquimentAction()  {
        Net.requestWithTarget(.getFamilyMemberList(deviceId: XBUserManager.device_Id), successClosure: { (result, code, msg) in
            print(result)
            if let arr = Mapper<FamilyMemberModel>().mapArray(JSONObject: JSON.init(parseJSON: result as! String).arrayObject) {

                var isAdmin = "0"
                for item in arr {
                    if item.easeadmin == "1" {
                        if item.username == XBUserManager.userName {
                            isAdmin = "1"
                            break
                        }
                    }
                }
                self.requestQuitEquiment(isAdmin: isAdmin)

            }
        })
        
    }
     // 调取接口 解除设备
    func requestQuitEquiment(isAdmin: String) {
        Net.requestWithTarget(.quitEquiment(openId: XBUserManager.userName, isAdmin: isAdmin == "1" ? true : false), successClosure: { (result, code, message) in
            if let str = result as? String {
                if str == "ok" {
                    print("解除成功")
                    XBHud.showMsg("解除成功")
                    XBUserManager.clearDeviceInfo()
                    XBDelay.start(delay: 0.5, closure: {
                        self.cofigDeviceInfo()
                    })
                }else {
                    XBHud.showMsg("解除失败")
                }
            }
        })

    }
    func getControlHeaderView() -> DrawControlHeader {
        let v = DrawControlHeader.loadFromNib()
        return v
    }
    func getAccountView() -> UIView {
        let v = UIView()
        v.frame = CGRect.init(x: 0, y: 0, w: tableView.w, h: 0.5)
        v.addBorderTop(size: 0.5, color: MGRgb(229, g: 229, b: 229))
        return v
    }
}
extension DrawerViewController {
    func getMQTT() {
        
        scoketModel.sendLight()
        scoketModel.sendGetLock()
        scoketModel.sendGetVolume()
        scoketModel.getLight.asObservable().subscribe { [weak self] in
            guard let `self` = self else { return }
            print("getLight ===：", $0.element ?? 0)
            if let Lamp = $0.element {
//                self.imgLight.set_img = light == 1 ? "icon_groupNight_on" : "icon_lamp"
//                self.lbLight.set_text = light == 1 ? "关呼吸灯" : "开呼吸灯"
                self.reloadDeviceLamp(isLamp: Lamp == 1)
            }
//            self.btnLight.isSelected = ($0.element ?? 0) == 1 ? true : false
            }.disposed(by: rx_disposeBag)
        scoketModel.getLock.asObservable().subscribe { [weak self] in
            guard let `self` = self else { return }
            print("getLock ===：", $0.element ?? 0)
            if let Lock = $0.element {
//                self.imgLock.set_img = light == 1 ? "icon_groupLaght_on" : "icon_groupLaght"
//                self.lbLock.set_text = light == 1 ? "关闭童锁" : "打开童锁"
                self.reloadDeviceLock(isLock: Lock == 1)
            }
//            self.btnLock.isSelected = ($0.element ?? 0) == 1 ? true : false
        }.disposed(by: rx_disposeBag)
        scoketModel.getPlayVolume.asObservable().subscribe { [weak self] in
            guard let `self` = self else { return }
            print("getPalyingVolume ===：", $0.element ?? 0)
//            self.currentVolume = $0.element ?? 0
            self.reloadDeviceVolume(volume: $0.element ?? 0)
            }.disposed(by: rx_disposeBag)

        
    }
    // 刷新tableView 儿童锁状态
    func reloadDeviceLock(isLock: Bool) {
        one1.isSwitchOpen = isLock
        one1.imgIcon = isLock ? "icon_menu_lock" : "icon_menu_unlock"
        tableView.reloadData()
    }
    // 刷新tableView 呼吸灯状态
    func reloadDeviceLamp(isLamp: Bool) {
        one2.isSwitchOpen = isLamp
        one2.imgIcon = isLamp ? "icon_menu_lamp" : "icon_menu_unlamp"
        tableView.reloadData()
    }
    // 刷新tableView 音量状态
    func reloadDeviceVolume(volume: Int) {
        one3.content = "音量" + (volume.mapPercentage().toString)
        tableView.reloadData()
    }
    
    
//    @IBAction func clickLockAction(_ sender: Any) {
//        guard self.deviceOnline else {
//            XBHud.showMsg("当前设备不在线")
//            return
//        }
//
//        if btnLock.isSelected {
//            scoketModel.sendCortolLock(0)
//            self.imgLock.set_img =  "icon_groupLaght"
//            self.lbLock.set_text = "打开童锁"
//        }else {
//            scoketModel.sendCortolLock(1)
//            self.imgLock.set_img =  "icon_groupLaght_on"
//            self.lbLock.set_text = "关闭童锁"
//        }
//       btnLock.isSelected = !btnLock.isSelected
//
//
//    }
//
//    @IBAction func btnLightAction(_ sender: Any) {
//        guard self.deviceOnline else {
//            XBHud.showMsg("当前设备不在线")
//            return
//        }
//        if btnLight.isSelected {
//            scoketModel.sendClooseLight(0)
//            self.imgLight.set_img = "icon_lamp"
//            self.lbLight.set_text = "开呼吸灯"
//        }else {
//            scoketModel.sendClooseLight(1)
//            self.imgLight.set_img = "icon_groupNight_on"
//            self.lbLight.set_text = "关呼吸灯"
//        }
//        btnLight.isSelected = !btnLight.isSelected
//    }
//
    func toVolumeAction() {
        guard self.deviceOnline else {
            XBHud.showMsg("当前设备不在线")
            return
        }
        let v = VolumeControlView.loadFromNib()
        v.delegate = self
        v.show()
        v.configVolume()
    }

    func toSleepAction() {
        guard self.deviceOnline else {
            XBHud.showMsg("当前设备不在线")
            return
        }
        let v = ScreenControlView.loadFromNib()
        v.show()
    }
    
}
extension DrawerViewController: DrawFromCellDelegate,VolumeControlDelegate {
    func toQRCodeVC()  {
        let vc = OpenEquViewController()
        self.pushVC(vc)
//        self.cw_present(alertC)
    }
    func switchValueChangeAction(modelData: XBStyleCellModel,isSwitch: Bool) {
        if modelData.cellType == 11 {
            self.reloadDeviceLock(isLock: isSwitch)
            scoketModel.sendCortolLock(isSwitch ? 1 : 0)
//            scoketModel.getLock
            scoketModel.sendGetLock()
          
        }
        if modelData.cellType == 12 {
            self.reloadDeviceLamp(isLamp: isSwitch)
            scoketModel.sendClooseLight(isSwitch ? 1 : 0)
            scoketModel.sendLight()
        }
    }
    func getVolumeNumber(volume: Int) {
        self.reloadDeviceVolume(volume: volume)
    }
}

