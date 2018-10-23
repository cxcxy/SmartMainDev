//
//  DrawerViewController.swift
//  SmartMain
//
//  Created by mac on 2018/9/20.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
class DrawerViewController: XBBaseViewController {
    var eqOne    = XBStyleCellModel.init(title: "设备配网", imgIcon: "icon_group1",cellType: 1)
    var eqTwo    = XBStyleCellModel.init(title: "绑定设备", imgIcon: "icon_group2",cellType: 2)
    var eqThree  = XBStyleCellModel.init(title: "切换设备", imgIcon: "icon_group3",cellType: 3)
    var eqFour   = XBStyleCellModel.init(title: "设备成员", imgIcon: "icon_member",cellType: 7)
    var accountOne  = XBStyleCellModel.init(title: "设备信息", imgIcon: "icon_group4",cellType: 4)
    var accountTwo  = XBStyleCellModel.init(title: "关于", imgIcon: "icon_group5",cellType: 5)
    var accountThree  = XBStyleCellModel.init(title: "退出登录", imgIcon: "icon_group6",cellType: 6)
    var eqArr: [XBStyleCellModel] = []
    var accountArr: [XBStyleCellModel] = []

    
    @IBOutlet weak var imgWifi: UIImageView!
//    @IBOutlet weak var imgElectricity: UIImageView!
    @IBOutlet weak var lbElectricity: UILabel!
     @IBOutlet weak var imgElectricity: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var lbDvnick: UILabel!
    
    @IBOutlet weak var imgLock: UIImageView!
    @IBOutlet weak var lbLock: UILabel!
    @IBOutlet weak var imgLight: UIImageView!
    @IBOutlet weak var lbLight: UILabel!
    
    
    @IBOutlet weak var btnLock: UIButton!
    @IBOutlet weak var btnLight: UIButton!
    @IBOutlet weak var btnVolume: UIButton!
    @IBOutlet weak var btnSleep: UIButton!
    
    
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
//        ImageCache.default.removeImage(forKey: XBUserManager.dv_headimgurl)
        if let headImgUrl = user_defaults.get(for: .headImgUrl){
            ImageCache.default.removeImage(forKey: headImgUrl)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setUI() {
        super.setUI()
//        request()
        self.configTableView(tableView, register_cell: ["DrawFromCell"])
        self.cofigDeviceInfo()
        view.backgroundColor = viewColor
        imgPhoto.addTapGesture {[weak self] (sender) in
            guard let `self` = self else { return }
            let vc = SetInfoViewController()
            vc.setInfoType = .editUserInfo
            self.cw_push(vc)
        }

        DeviceManager.isOnline(isCheckDevices: false) { (isOnline, electricity)  in
            self.deviceOnline = isOnline
            if electricity == 101 { // 当前正在充电
                self.lbElectricity.isHidden = true
                self.imgElectricity.set_img = "icon_charging"
            }else {
                self.lbElectricity.isHidden = false
                self.lbElectricity.set_text = electricity.toString
                self.imgElectricity.set_img = "icon_electricity"
            }
            
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
                topTableLayout.constant = 110
                eqArr       = [eqOne,eqTwo,eqThree,eqFour]
                accountArr  = [accountOne,accountTwo,accountThree]
                getMQTT()
            
        } else {
            topTableLayout.constant = 0
            eqArr       = [eqTwo]
            accountArr  = [accountTwo,accountThree]
        }
        self.configUserInfo()
        
    }
    func configUserInfo()  {
        imgPhoto.roundView()
        imgPhoto.set_Img_Url(user_defaults.get(for: .headImgUrl))
//        lbDvnick.set_text = XBUserManager.nickname
        if XBUserManager.device_Id == "" &&  XBUserManager.dv_babyname == ""{
            lbDvnick.set_text = XBUserManager.nickname
        }else {
            lbDvnick.set_text = XBUserManager.nickname + "的" +  XBUserManager.dv_babyname
        }
        
        self.tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension DrawerViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? eqArr.count : accountArr.count
        
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return section == 0 ? XBMin : 40
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 0 ? nil : getAccountView()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrawFromCell", for: indexPath) as! DrawFromCell
        cell.lbDes.set_text = indexPath.section == 0 ? eqArr[indexPath.row].title : accountArr[indexPath.row].title
        cell.imgIcon.set_img = indexPath.section == 0 ? eqArr[indexPath.row].imgIcon : accountArr[indexPath.row].imgIcon
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = indexPath.section == 0 ? eqArr[indexPath.row] : accountArr[indexPath.row]
        print(model.title)
        switch model.cellType {
        case 1:
            let vc = ConfigNetViewController()
            self.cw_push(vc)
        case 2:
            self.toQRCodeVC()
        case 3:
            let vc = EquipmentListViewController()
            self.cw_push(vc)
        case 4:
            let vc = EquipmentSettingVC()
//            vc.isAdd = false
//            vc.deviceId = XBUserManager.device_Id
//            vc.setInfoType = .editDeviceInfo
            self.cw_push(vc)
            
        case 5:
            let vc = AccountInfoViewController()
            self.cw_push(vc)
        case 6:
            loginOutAction()
            break
        case 7:
            let vc = MemberManagerVC()
            self.cw_push(vc)
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
            let sv = UIStoryboard.getVC("Main", identifier:"LoginNav") as! XBBaseNavigation
            self.popWindow.rootViewController = sv
            
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
        v.frame = CGRect.init(x: 0, y: 0, w: tableView.w, h: 40)
        v.addBorderTop(size: 0.5, color: MGRgb(229, g: 229, b: 229))
        let title = UILabel.init(x: 15, y: 0, w: 85, h: 40)
        title.set_text = "账号设置"
        title.font = UIFont.systemFont(ofSize: 14)
        title.textColor = viewColor
        v.addSubview(title)
        return v
    }
}
extension DrawerViewController {
    func getMQTT() {
        
        scoketModel.sendLight()
        scoketModel.sendGetLock()
        scoketModel.getLight.asObservable().subscribe { [weak self] in
            guard let `self` = self else { return }
            print("getLight ===：", $0.element ?? 0)
            //            self.requestSingsDetail(trackId: $0.element ?? 0)
            if let light = $0.element {
                self.imgLight.set_img = light == 1 ? "icon_groupNight_on" : "icon_lamp"
                self.lbLight.set_text = light == 1 ? "关呼吸灯" : "开呼吸灯"
            }
            self.btnLight.isSelected = ($0.element ?? 0) == 1 ? true : false
            }.disposed(by: rx_disposeBag)
        scoketModel.getLock.asObservable().subscribe { [weak self] in
            guard let `self` = self else { return }
            print("getLock ===：", $0.element ?? 0)
            if let light = $0.element {
                self.imgLock.set_img = light == 1 ? "icon_groupLaght_on" : "icon_groupLaght"
                self.lbLock.set_text = light == 1 ? "关闭童锁" : "打开童锁"
            }
            //            self.requestSingsDetail(trackId: $0.element ?? 0)
            self.btnLock.isSelected = ($0.element ?? 0) == 1 ? true : false
            }.disposed(by: rx_disposeBag)
        

        
    }
    @IBAction func clickLockAction(_ sender: Any) {
        guard self.deviceOnline else {
            XBHud.showMsg("当前设备不在线")
            return
        }
        
        if btnLock.isSelected {
            scoketModel.sendCortolLock(0)
            self.imgLock.set_img =  "icon_groupLaght"
            self.lbLock.set_text = "打开童锁"
        }else {
            scoketModel.sendCortolLock(1)
            self.imgLock.set_img =  "icon_groupLaght_on"
            self.lbLock.set_text = "关闭童锁"
        }
       btnLock.isSelected = !btnLock.isSelected
        
        
    }
    
    @IBAction func btnLightAction(_ sender: Any) {
        guard self.deviceOnline else {
            XBHud.showMsg("当前设备不在线")
            return
        }
        if btnLight.isSelected {
            scoketModel.sendClooseLight(0)
            self.imgLight.set_img = "icon_lamp"
            self.lbLight.set_text = "开呼吸灯"
        }else {
            scoketModel.sendClooseLight(1)
            self.imgLight.set_img = "icon_groupNight_on"
            self.lbLight.set_text = "关呼吸灯"
        }
        btnLight.isSelected = !btnLight.isSelected
    }
    
    @IBAction func clickVolumeAction(_ sender: Any) {
        guard self.deviceOnline else {
            XBHud.showMsg("当前设备不在线")
            return
        }
        let v = VolumeControlView.loadFromNib()
        v.show()
    }
    
    @IBAction func clickSleepAction(_ sender: Any) {
        guard self.deviceOnline else {
            XBHud.showMsg("当前设备不在线")
            return
        }
        let v = ScreenControlView.loadFromNib()
        v.show()
    }
    
}
extension DrawerViewController {
    func toQRCodeVC()  {
        let vc = OpenEquViewController()
        self.cw_push(vc)
//        self.cw_present(alertC)
    }
}
