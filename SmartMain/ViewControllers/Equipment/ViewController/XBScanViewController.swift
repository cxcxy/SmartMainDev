//
//  XBScanViewController.swift
//  XBPMDev
//
//  Created by mac on 2018/4/19.
//  Copyright © 2018年 mac-cx. All rights reserved.
//

import UIKit
enum XBScanEntrance {
    case main               // 主页扫一扫
    case transfer           // 划转扫一扫
    case AccountGive        // 发放扫一扫
    case exchange           // 兑换扫一扫
}
//typealias XBScanResultBlock = (_ friendModelArr: [FriendResModel]?,_ companyModel: XBCompDetResModel?,_ voucherModel: VoucherListResModel?) -> ()
class XBScanViewController: XBBaseViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var viewModel = LoginViewModel()
    var sessionManager:AVCaptureSessionManager?
    var link: CADisplayLink?
    var torchState = false
//    var viewModel: CenterViewModel = CenterViewModel()
//    var block: XBScanResultBlock?
    var entarnceType: XBScanEntrance = .main
    
    @IBOutlet weak var scanTop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        link = CADisplayLink(target: self, selector: #selector(scan))
        title = "扫描二维码"
        
        self.currentNavigationNone = true
        self.currentNavigationTitleColor = UIColor.white
        sessionManager = AVCaptureSessionManager(captureType: .AVCaptureTypeBoth, scanRect: CGRect.null, success: { (result) in
            if let r = result {
                self.showResult(result: r)
            }
        })
        sessionManager?.showPreViewLayerIn(view: view)
        sessionManager?.isPlaySound = true
        
//        let item = UIBarButtonItem(title: "相册", style: .plain, target: self, action: #selector(openPhotoLib))
//        navigationItem.rightBarButtonItem = item
        makeCustomerNavigationItem("相册", left: false) {[weak self] in
            self?.openPhotoLib()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        link?.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
        sessionManager?.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        link?.remove(from: RunLoop.main, forMode: RunLoopMode.commonModes)
        sessionManager?.stop()
    }
    
    @objc func scan() {
        scanTop.constant -= 1;
        if (scanTop.constant <= -170) {
            scanTop.constant = 170;
        }
    }
    
    @IBAction func changeState(_ sender: UIButton) {
        torchState = !torchState
        let str = torchState ? "关闭闪光灯" : "开启闪光灯"
        sessionManager?.turnTorch(state: torchState)
        sender.setTitle(str, for: .normal)
    }
    
    

    
    @objc func openPhotoLib() {
        AVCaptureSessionManager.checkAuthorizationStatusForPhotoLibrary(grant: {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }) {
            let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: { (action) in
                let url = URL(string: UIApplicationOpenSettingsURLString)
                UIApplication.shared.openURL(url!)
            })
            let con = UIAlertController(title: "权限未开启",
                                        message: "您未开启相册权限，点击确定跳转至系统设置开启",
                                        preferredStyle: UIAlertControllerStyle.alert)
            con.addAction(action)
            self.present(con, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        sessionManager?.start()
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true) {
            self.sessionManager?.start()
            self.sessionManager?.scanPhoto(image: info["UIImagePickerControllerOriginalImage"] as! UIImage, success: { (str) in
                print(str)
                if let result = str {

                    self.showResult(result: result)

                }else {
                    self.showResult(result: "未识别到二维码")
                }
            })
            
        }
    }

}
extension XBScanViewController {
    
    func showResult(result: String) {
        let arr = result.components(separatedBy: "#")

        var params_task = [String: Any]()
        params_task["openId"] = user_defaults.get(for: .userName)
        var current_deviceId:String = ""
        if arr.count > 1 {
           current_deviceId  = arr[1]
        }
        guard current_deviceId != "" else {
            XBHud.showMsg("未获取设备ID")
            return
        }
        params_task["deviceId"] = current_deviceId
        
        self.checkBabyInfo(device_Id: current_deviceId)

//        Net.requestWithTarget(.joinEquiment(req: params_task), successClosure: { (result, code, message) in
//            print(result)
//            if let str = result as? String {
//                if str == "ok" {
//                    print("加入成功")
//                    self.requestJoinEaseGroup(username: user_defaults.get(for: .userName), deviceId: current_deviceId)
//                }else {
//                    XBHud.showMsg("第一步加入失败")
//                }
//            }
//        })
//        user_defaults.get(for: .deviceId)
    }
    
    func requestJoinEaseGroup(username: String?,deviceId:String, model: XBDeviceBabyModel)  {
        var params_task = [String: Any]()
        
        params_task["username"] = username
        params_task["deviceId"] = deviceId
        
        Net.requestWithTarget(.joinEquimentGroup(req: params_task), successClosure: { (result, code, message) in
            print(result)
            if let str = result as? String {
                if str == "ok" {
                    print("加入成功")
                    user_defaults.set(deviceId, for: .deviceId)
                    XBHud.showMsg("加入成功")
                    Noti_post(.refreshUserData)
                    self.popVC()
                   
                }else {
                    XBHud.showMsg("第二步加入失败")
                }
            }
        })
    }
    func checkBabyInfo(device_Id: String)  {

        Net.requestWithTarget(.getBabyInfo(deviceId: device_Id), successClosure: { (result, code, message) in
            if let result = result as? String {
                guard let status = result.json_Str()["status"].int else {
                    return
                }
                if status == 404 {
                    XBHud.showMsg("请完善设备信息")
                    
                    let vc = SetInfoViewController()
                    vc.deviceId = device_Id
                    vc.isAdd = true
                    vc.delegate = self
                    self.pushVC(vc)
                    
                } else if status == 200 {
                    if let obj = Net.filterStatus(jsonString: result as AnyObject) {
                        if let model = Mapper<XBDeviceBabyModel>().map(JSONObject: obj.object) {
                            self.requestJoinEaseGroup(username: user_defaults.get(for: .userName), deviceId: device_Id, model: model)
                        }
                    }
                    
                }
            }


//            if let obj = Net.filterStatus(jsonString: result) {
//                if let model = Mapper<XBDeviceBabyModel>().map(JSONObject: obj.object) {
//                    XBUserManager.saveDeviceInfo(model)
//                    closure()
//                }
//            }
        })
    }
}
extension XBScanViewController: SetInfoDelegate {
    
    func addSuccessAction(deviceId: String, model: XBDeviceBabyModel) {
        self.requestJoinEaseGroup(username: user_defaults.get(for: .userName), deviceId: deviceId, model: model)
    }
    
}
