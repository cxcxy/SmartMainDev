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
        
        return section == 0 ? 100 : 40
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 0 ? getControlHeaderView() : getAccountView()
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
            let vc = AboutMeVC()
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
    func toQRCodeVC()  {
        let scanVC = XBScanViewController()
        let device = AVCaptureDevice.default(for: .video)
        if device != nil {
            let status: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
            switch status {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video, completionHandler: {(_ granted: Bool) -> Void in
                    if granted {
                        DispatchQueue.main.sync(execute: {() -> Void in
//                            topVC?.pushVC(scanVC)
                            self.cw_push(scanVC)
                        })
                        print("用户第一次同意了访问相机权限 - - \(Thread.current)")
                    } else {
                        print("用户第一次拒绝了访问相机权限 - - \(Thread.current)")
                    }
                })
            case .authorized:
                self.cw_push(scanVC)
            case .denied:
                
                let alertC = UIAlertController(title: "温馨提示", message: "请去-> [设置 - 隐私 - 相机] 打开访问开关", preferredStyle: .alert)
                let alertA = UIAlertAction(title: "确定", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                })
                alertC.addAction(alertA)
                self.cw_present(alertC)
                
            case .restricted:
                print("因为系统原因, 无法访问相册")
                
            }
            return
        }
        let alertC = UIAlertController(title: "温馨提示", message: "未检测到您的摄像头", preferredStyle: .alert)
        let alertA = UIAlertAction(title: "确定", style: .default, handler: {(_ action: UIAlertAction) -> Void in
        })
        alertC.addAction(alertA)
        self.cw_present(alertC)
    }
}
