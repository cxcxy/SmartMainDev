//
//  DrawerViewController.swift
//  SmartMain
//
//  Created by mac on 2018/9/20.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
class DrawerViewController: XBBaseViewController {
    var eqOne    = XBStyleCellModel.init(title: "设备连接", imgIcon: "",cellType: 1)
    var eqTwo    = XBStyleCellModel.init(title: "绑定设备", imgIcon: "",cellType: 2)
    var eqThree  = XBStyleCellModel.init(title: "选择设备", imgIcon: "",cellType: 3)
    
    var accountOne  = XBStyleCellModel.init(title: "宝宝信息", imgIcon: "",cellType: 4)
    var accountTwo  = XBStyleCellModel.init(title: "关于", imgIcon: "",cellType: 5)
    var accountThree  = XBStyleCellModel.init(title: "退出登录", imgIcon: "",cellType: 6)
    var eqArr: [XBStyleCellModel] = []
    var accountArr: [XBStyleCellModel] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var lbDvnick: UILabel!
    
    @IBOutlet weak var btnLock: UIButton!
    
    @IBOutlet weak var btnLight: UIButton!
    
    @IBOutlet weak var btnVolume: UIButton!
    
    @IBOutlet weak var btnSleep: UIButton!
    
    let scoketModel = ScoketMQTTManager.share
    
    lazy var popWindow:UIWindow = {
        let w = UIApplication.shared.delegate as! AppDelegate
        return w.window!
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setUI() {
        super.setUI()
        eqArr       = [eqOne,eqTwo,eqThree]
        accountArr  = [accountOne,accountTwo,accountThree]
        self.configTableView(tableView, register_cell: ["DrawFromCell"])
        imgPhoto.roundView()
        imgPhoto.set_Img_Url(XBUserManager.dv_headimgurl)
        lbDvnick.set_text = XBUserManager.device_Id == "" ? "暂未绑定设备" : XBUserManager.userName
        
        getMQTT()
        
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
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = indexPath.section == 0 ? eqArr[indexPath.row] : accountArr[indexPath.row]
        print(model.title)
        switch model.cellType {
        case 2:
            self.toQRCodeVC()
        case 4:
            let vc = SetInfoViewController()
            self.cw_push(vc)
        case 5:
            let vc = AccountInfoViewController()
            self.cw_push(vc)
        case 6:
            user_defaults.clear(.userName)
            user_defaults.clear(.deviceId)
            let sv = UIStoryboard.getVC("Main", identifier:"LoginNav") as! XBBaseNavigation
            popWindow.rootViewController = sv
            break
        default:
            break
        }
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
            self.btnLight.isSelected = ($0.element ?? 0) == 1 ? true : false
            }.disposed(by: rx_disposeBag)
        scoketModel.getLock.asObservable().subscribe { [weak self] in
            guard let `self` = self else { return }
            print("getLight ===：", $0.element ?? 0)
            //            self.requestSingsDetail(trackId: $0.element ?? 0)
            self.btnLock.isSelected = ($0.element ?? 0) == 1 ? true : false
            }.disposed(by: rx_disposeBag)
        

        
    }
    @IBAction func clickLockAction(_ sender: Any) {
        
        if btnLock.isSelected {
            scoketModel.sendCortolLock(0)
        }else {
            scoketModel.sendCortolLock(1)
        }
        btnLock.isSelected = !btnLock.isSelected
        
        
    }
    
    @IBAction func btnLightAction(_ sender: Any) {
        if btnLight.isSelected {
            scoketModel.sendClooseLight(0)
        }else {
            scoketModel.sendClooseLight(1)
        }
        btnLight.isSelected = !btnLight.isSelected
    }
    
    @IBAction func clickVolumeAction(_ sender: Any) {
        let v = ScreenControlView.loadFromNib()
        v.show()
    }
    
    @IBAction func clickSleepAction(_ sender: Any) {
        
    }
    
}
extension DrawerViewController {
    func toQRCodeVC()  {
        let vc = OpenEquViewController()
        self.cw_push(vc)
//        self.cw_present(alertC)
    }
}
