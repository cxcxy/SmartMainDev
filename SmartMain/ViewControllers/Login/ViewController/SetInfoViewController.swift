//
//  SetInfoViewController.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/19.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
import FCUUID

protocol SetInfoDelegate: class {
    func addSuccessAction(deviceId: String,model: XBDeviceBabyModel)
}

enum SetInfoType {
    case setUserInfo
    case editUserInfo
    case setDeviceInfo
    case editDeviceInfo
}

class SetInfoViewController: XBBaseViewController {

    @IBOutlet weak var btnWomen: UIButton!
    @IBOutlet weak var btnMan: UIButton!
    @IBOutlet weak var tfBirth: UITextField!
    @IBOutlet weak var tfNick: UITextField!
    @IBOutlet weak var btnSure: UIButton!
    @IBOutlet weak var imgPhoto: UIImageView!
    
    @IBOutlet weak var viewContainer: UIView!
    
    weak var delegate: SetInfoDelegate?
    
    var setInfoType: SetInfoType = .setUserInfo 
    
    var viewModel = LoginViewModel()
    var headImgUrl: String = ""
    var birth = ""
    var currentSex :Int = 1  // 0 - 男 1 - 女
    
    @IBOutlet weak var viewSex: UIView!
    @IBOutlet weak var viewBirthday: UIView!
    
    var deviceId: String!
    var isAdd: Bool = true // 是否未添加
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        ImageCache.default.removeImage(forKey: XBUserManager.dv_headimgurl)
        if let headImgUrl = user_defaults.get(for: .headImgUrl){
            ImageCache.default.removeImage(forKey: headImgUrl)
        }
    }
    //MARK: 相册选择器
    lazy var imagePicker: XBAddImagePickerFragment = {
        let img = XBAddImagePickerFragment.init()
        img.delegate = self
        return img
    }()
    @IBAction func btnManAction(_ sender: Any) {
        self.btnMan.isSelected      = true
        self.btnWomen.isSelected    = false
        self.currentSex             =  0
    }
    
    @IBAction func btnWomanAction(_ sender: Any) {
        self.btnWomen.isSelected    = true
        self.btnMan.isSelected      = false
        self.currentSex             = 1
    }
    override func setUI() {
        super.setUI()
        imgPhoto.roundView()
        viewContainer.setCornerRadius(radius: 8)
        view.backgroundColor = viewColor
        btnSure.radius_ll()
        imgPhoto.addTapGesture { [weak self] (sender) in
            guard let `self` = self else { return }
            self.choosePhotoAction()
        }
        viewBirthday.addTapGesture {[weak self]  (sender) in
            guard let `self` = self else { return }
            self.chooseBirthday()
        }
        configUIInfoWithType()
        request()
    }
    func configUIInfoWithType()  {
        switch setInfoType {
        case .editUserInfo:
            viewSex.isHidden = true
            viewBirthday.isHidden = true
            title = "用户信息"
            break
        case .setUserInfo:
            viewSex.isHidden = true
            viewBirthday.isHidden = true
            title = "用户信息"
            break
        case .editDeviceInfo:
            viewSex.isHidden = true
            viewBirthday.isHidden = true
            title = "宝贝信息"
            break
        case .setDeviceInfo:
            viewSex.isHidden = true
            viewBirthday.isHidden = true
            title = "宝贝信息"
            break
        }
    }
    override func request() {
        super.request()
        switch self.setInfoType {
        case .editUserInfo:
            getUserInfo()
            break
        case .setUserInfo:
            break
        case .editDeviceInfo:
            getDeviceBabyInfo()
            break
        case .setDeviceInfo:
            break
        }

    }
    func getUserInfo()  { // 获取用户信息
        viewModel.requestGetUserInfo(mobile: XBUserManager.userName) { [weak self] in
            guard let `self` = self else { return }
            self.configUIInfo()
        }
    }
    func getDeviceBabyInfo() { // 获取设备信息
        viewModel.requestGetBabyInfo(device_Id: deviceId) {[weak self](isTrue) in
            guard let `self` = self else { return }
            self.configUIInfo()
        }
    }
    func configUIInfo()  {
        switch self.setInfoType {
        case .editUserInfo:
            
            self.headImgUrl = user_defaults.get(for: .headImgUrl) ?? ""
            self.imgPhoto.set_Img_Url(user_defaults.get(for: .headImgUrl))
            self.tfNick.text = user_defaults.get(for: .nickname)

            break
        case .editDeviceInfo:
            
            self.headImgUrl = user_defaults.get(for: .dv_headimgurl) ?? ""
            self.birth = XBUserManager.dv_birthday
            
            self.imgPhoto.set_Img_Url(XBUserManager.dv_headimgurl)
            self.tfNick.text = XBUserManager.dv_babyname
            self.tfBirth.text = XBUserManager.dv_birthday
            
            if XBUserManager.dv_sex == "0" {
                self.btnMan.isSelected = true
                self.btnWomen.isSelected = false
                self.currentSex = 0
            }
            if XBUserManager.dv_sex == "1" {
                self.btnMan.isSelected = false
                self.btnWomen.isSelected = true
                self.currentSex = 1
            }

            break

        case .setUserInfo:
            break
        case .setDeviceInfo:
            break
        }
    }
    func chooseBirthday()  {
        tfNick.resignFirstResponder()
        let sheetView = WOWDatePickerView.loadFromNib()
        let str = birth
        sheetView.showPickerView(dateStr: str)
        sheetView.selectBlock = {[weak self](str,index) in
            guard let `self` = self else { return }
            self.birth = str
            self.tfBirth.text = str
        }
    }
    @IBAction func clickSureAction(_ sender: Any) {
        switch self.setInfoType {
        case .editUserInfo:
            self.requestUpdateUserInfo()
            break
        case .setUserInfo:
            self.requestUpdateUserInfo()
            break
        case .editDeviceInfo:
            self.requestUpdateBabyInfo()
            break
        case .setDeviceInfo:
            self.requestUpdateBabyInfo()
            break
        }

        
    }
    lazy var popWindow:UIWindow = {
        let w = UIApplication.shared.delegate as! AppDelegate
        return w.window!
    }()
    func toHome()  {
        
        let mainViewController   = ContentMainVC()
        let nav = XBBaseNavigation.init(rootViewController: mainViewController)
        self.popWindow.rootViewController = nav
    }
    //MARK: 更新用户信息
    func requestUpdateUserInfo()  {
        viewModel.requestUpdateUserInfo(mobile: XBUserManager.userName,
                                        headImgUrl: self.headImgUrl,
                                        nickname: tfNick.text!) {[weak self] isOK in
                                        guard let `self` = self else { return }
            if isOK {
                if self.setInfoType == .setUserInfo { // 完善用户信息， 注册成功
                    XBHud.showMsg("注册成功")
                    self.viewModel.loginSueecss(mobile: XBUserManager.userName, password: XBUserManager.password)
                    self.toHome()
                }
                if self.setInfoType == .editUserInfo {
                    XBHud.showMsg("修改成功")
                    self.popVC()
                }
            }
        }
    }
    //MARK: 更新设备信息
    func requestUpdateBabyInfo()  {
        viewModel.requestUpdateBabyInfo(device_Id: deviceId, babyname: tfNick.text!, headimgurl: self.headImgUrl) { model in
            if self.isAdd {
                print("新增成功")
                if let del = self.delegate {
                    del.addSuccessAction(deviceId: self.deviceId,model: model)
                    self.popVC()
                }
            }else {
                XBHud.showMsg("修改成功")
                self.popVC()
                XBUserManager.saveDeviceInfo(model)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension SetInfoViewController: XBImagePickerToolDelegate {
    //MARK: 点击选择照片
    func choosePhotoAction() {
        self.imagePicker.show(self)
    }

    //MARK: 代理方法， 拿到选择的照片
    func getImagePicker(image: UIImage) {
        //将选择的图片保存到Document目录下
        let fileManager = FileManager.default
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                           .userDomainMask, true)[0] as String
        let filePath = "\(rootPath)/pickedimage.png"
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)
        self.imgPhoto.image = image
        var openId = ""
        switch setInfoType {
        case .editDeviceInfo,.setDeviceInfo:
            openId = XBUserManager.device_Id + SetInfoViewController.getOnlyStr()
        case .setUserInfo,.editUserInfo:
            openId = XBUserManager.userName + SetInfoViewController.getOnlyStr()
        }
        if (fileManager.fileExists(atPath: filePath)){
            
            Net.requestWithTarget(.uploadAvatar(openId: openId, body: filePath), successClosure: { (result, code, message) in
                if let str = result as? String {
                    XBLog("上传成功 ==\(str)")
                    self.headImgUrl = str
                }
            })
        }
    }
    // 获取时间戳
    static func getTimeSince() -> String  {
        
        let timeStr         = Date.init().toString(format: "yyyyMMddHHmmss")
        
        return timeStr
        
    }
    // 获取唯一标示
    static func getOnlyStr() -> String  {
        
        let onlyStr         = FCUUID.uuidForDevice()  + getTimeSince()
        return onlyStr
        
    }
}
