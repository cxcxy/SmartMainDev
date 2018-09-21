//
//  SetInfoViewController.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/19.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class SetInfoViewController: XBBaseViewController {

    @IBOutlet weak var btnWomen: UIButton!
    @IBOutlet weak var btnMan: UIButton!
    @IBOutlet weak var tfBirth: UITextField!
    @IBOutlet weak var tfNick: UITextField!
    @IBOutlet weak var btnSure: UIButton!
    @IBOutlet weak var imgPhoto: UIImageView!
    var viewModel = LoginViewModel()
    var headImgUrl: String = ""
    var birth = ""
     var currentSex :Int = 1  // 0 - 男 1 - 女
    @IBOutlet weak var viewBirthday: UIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
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
        self.title = "宝贝信息"
        imgPhoto.roundView()
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
        request()
    }
    override func request() {
        super.request()
        viewModel.requestGetBabyInfo {[weak self] in
            guard let `self` = self else { return }
            self.configUIInfo()
        }
    }
    func configUIInfo()  {
        self.imgPhoto.set_Img_Url(XBUserManager.dv_headimgurl)
        self.tfNick.text = XBUserManager.dv_babyname
        self.tfBirth.text = XBUserManager.dv_birthday
        if XBUserManager.dv_sex == "0" {
            self.btnMan.isSelected = true
            self.btnWomen.isSelected = false
        }
        if XBUserManager.dv_sex == "1" {
            self.btnMan.isSelected = false
            self.btnWomen.isSelected = true
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
        viewModel.requestUpdateBabyInfo(babyname: tfNick.text!, headimgurl: self.headImgUrl, sex: currentSex, birthday: self.birth) {
            print("成功")
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
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)
        self.imgPhoto.image = image
        if (fileManager.fileExists(atPath: filePath)){
            Net.requestWithTarget(.uploadAvatar(openId: XBUserManager.userName, body: filePath), successClosure: { (result, code, message) in
                if let str = result as? String {
                    self.headImgUrl = str
                }
            })
        }
    }
}
