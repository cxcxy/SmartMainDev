//
//  EquipmentSettingVC.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/4.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class EquipmentSettingVC: XBBaseTableViewController {
    var sourceArr : [[XBStyleCellModel]] = []
    var equimentModel: EquipmentInfoModel?
    let cell_photo = XBStyleCellModel.init(title: "头像", cellType: 1, isHidden: false)
    let cell_name = XBStyleCellModel.init(title: "名字",isEdit: true, cellType: 2, isHidden: false)
    let cell_device = XBStyleCellModel.init(title: "设备号", cellType: 3, isHidden: true)
    let cell_memory = XBStyleCellModel.init(title: "存储空间", cellType: 4, isHidden: true)
    let cell_version = XBStyleCellModel.init(title: "固件版本", cellType: 5, isHidden: true)
    let cell_net = XBStyleCellModel.init(title: "所在网络", cellType: 6, isHidden: true)
    let cell_dian = XBStyleCellModel.init(title: "电量", cellType: 6, isHidden: true)
    
    var viewModel = LoginViewModel()
    var babyname:String = ""
    var headimgurl:String = ""
    
    var newVersionURL: String = ""
    var newVersion: String = ""
    
     let scoketModel = ScoketMQTTManager.share
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setUI() {
        super.setUI()
        self.title = "设备信息"
        tableView.cellId_register("EquipmentListCell")
        tableView.cellId_register("EquipmentSetHeaderCell")
        request()

        let setion_two = [cell_device,cell_memory,cell_version]
        let setion_four = [cell_net,cell_dian]
        sourceArr = [setion_two,setion_four]
        scoketModel.getDeviceVersion.asObservable().subscribe { [weak self] in
            guard let `self` = self else { return }
            print("firmwareVersion ===：", $0.element ?? "")
            //            self.requestSingsDetail(trackId: $0.element ?? 0)
            self.compareVersion(currentDeviceVersion: $0.element ?? "")
        }.disposed(by: rx_disposeBag)
    }
    override func request() {
        super.request()
        Net.requestWithTarget(.getEquimentInfo(deviceId: XBUserManager.device_Id), successClosure: { (result, code, message) in
            if let model = Mapper<EquipmentInfoModel>().map(JSONString: result as! String) {
                self.endRefresh()
                self.equimentModel = model
                self.configElectricity(equimentModel: model)
                self.cell_net.content = model.net ?? ""
                self.cell_version.content = model.firmwareVersion ?? ""
                let cardAvailable = model.cardAvailable?.toString ?? ""
                let cardTotal = model.cardTotal?.toString ?? ""
                self.cell_memory.content = cardAvailable + "MB/" + cardTotal + "MB"
                self.cell_device.content = model.id ?? ""
                self.getDeviceBabyInfo()

            }
        })
        Net.requestWithTarget(.getDevicesVersion(deviceId: XBUserManager.device_Id), successClosure: { (result, code, message) in
         
            if let str = result as? String {
                 let jsonObj = JSON.init(parseJSON: str).arrayValue
                self.newVersion = jsonObj[0].string ?? ""
                self.newVersionURL = jsonObj[1].string ?? ""
                if self.newVersion != "" && self.newVersionURL != "" {
                     self.scoketModel.sendGetDeviceVersion()
                }
               
            }
        })
    }
    func configElectricity(equimentModel: EquipmentInfoModel)  {
        if equimentModel.online == 1 {
            if equimentModel.electricity == 101 { // 当前正在充电
//                cell.lbElectricity.set_text = "正在充电"
                cell_dian.content = "正在充电"
            }else {
                let electricity = equimentModel.electricity?.toString  ?? ""
                cell_dian.content = electricity + "%"
            }
        }else {
            cell_dian.content = "当前设备不在线"
        }
//        self.tableView.reloadData()

    }
    /**
     *   currentDeviceVersion 当前机器发送过来的 版本号
     */
    func compareVersion(currentDeviceVersion: String) {
        guard currentDeviceVersion != "" && self.newVersion != "" else {
            return
        }
        if currentDeviceVersion.compare(self.newVersion).rawValue == 0 { // 版本号相同
            
        }
        if currentDeviceVersion.compare(self.newVersion).rawValue == -1 { // 机器版本号，小于，服务器版本号
            self.cell_version.isHidden = false
            self.tableView.reloadData()
        }
        if currentDeviceVersion.compare(self.newVersion).rawValue == 1 { // 机器版本号，大于，服务器版本号
            
        }
    }
    func getDeviceBabyInfo() { // 获取设备信息
        
        viewModel.requestGetBabyInfo(device_Id: XBUserManager.device_Id) {[weak self] in
            guard let `self` = self else { return }
//            self.configUIInfo()
            self.cell_name.content = XBUserManager.dv_babyname
            self.tableView.reloadData()
        }
    }
    //MARK: 更新设备信息
    func requestUpdateBabyInfo(babyName: String, headImgUrl: String)  {
        
        viewModel.requestUpdateBabyInfo(device_Id: XBUserManager.device_Id,
                                        babyname: babyName,
                                        headimgurl: headImgUrl) { model in

                XBHud.showMsg("修改成功")
                XBUserManager.saveDeviceInfo(model)
                self.cell_name.content = XBUserManager.dv_babyname
                self.tableView.reloadData()

        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func requestQuitEquiment()  {
        Net.requestWithTarget(.quitEquiment(openId: XBUserManager.userName, isAdmin: false), successClosure: { (result, code, message) in
            print(result)
        })
    }
    //MARK: 相册选择器
    lazy var imagePicker: XBAddImagePickerFragment = {
        let img = XBAddImagePickerFragment.init()
        img.delegate = self
        return img
    }()
}
extension EquipmentSettingVC: XBImagePickerToolDelegate {
    func clickUpdateName()  {
        print("修改名字")
        let v = ShowUpdateNameView.loadFromNib()
        v.textView.text = XBUserManager.dv_babyname
        v.btnLogin.addAction {[weak self] in
            guard let `self` = self else { return }
            if v.textView.text! == "" {
                XBHud.showMsg("请输入昵称")
            }else {
                v.hide()
                self.requestUpdateBabyInfo(babyName: v.textView.text ?? "", headImgUrl: XBUserManager.dv_headimgurl)
            }
            
        }
        v.show()
    }
    //MARK: 点击选择照片
    func choosePhotoAction() {
        let v = SwitchPlayView.loadFromNib()
        v.switchPlayType = .photo
        v.viewSing.addAction { [weak self] in
            guard let `self` = self else { return }
            v.hide()
            self.imagePicker.showCamera(self)
            
        }
        v.viewAll.addAction { [weak self] in
            guard let `self` = self else { return }
            v.hide()
            self.imagePicker.showPhotoLibrary(self)
        }

        v.show()
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
//        self.imgPhoto.image = image
        let  openId = XBUserManager.device_Id + SetInfoViewController.getOnlyStr()

        if (fileManager.fileExists(atPath: filePath)){
            
            Net.requestWithTarget(.uploadAvatar(openId: openId, body: filePath), successClosure: { (result, code, message) in
                if let str = result as? String {
                    XBLog("上传成功 ==\(str)")

//                    XBHud.showMsg("修改头像成功")
                    if let headImgUrl = user_defaults.get(for: .dv_headimgurl){
                        ImageCache.default.removeImage(forKey: headImgUrl)
                    }
                    self.requestUpdateBabyInfo(babyName: XBUserManager.dv_babyname, headImgUrl: str)
//                    XBUserManager.dv_headimgurl = str
//                    self.tableView.reloadData()
                }
            })
        }
    }
}

extension EquipmentSettingVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sourceArr.count > 0 ? sourceArr.count + 1 : 0
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == sourceArr.count {
            return XBMin
        }
        return 10
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return sourceArr.count > 0 ? sourceArr[section - 1].count : 0
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EquipmentSetHeaderCell", for: indexPath) as! EquipmentSetHeaderCell
            cell.viewPhoto.addTapGesture { [weak self](sender) in
                guard let `self` = self else { return }
                self.choosePhotoAction()
            }
            cell.viewName.addTapGesture { [weak self](sender) in
                guard let `self` = self else { return }
                self.clickUpdateName()
            }
            cell.imgPhoto.set_Img_Url(XBUserManager.dv_headimgurl)
            cell.lbTitle.set_text = XBUserManager.dv_babyname
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "EquipmentListCell", for: indexPath) as! EquipmentListCell
        let model = sourceArr[indexPath.section - 1]
        let item = model[indexPath.row]
        cell.lbTitle.text = item.title
        cell.tfDes.isUserInteractionEnabled = false
//        cell.imgRight.isHidden = !item.isEdit
        cell.tfDes.text = item.content
        cell.viewBtn.isHidden = item.isHidden
        let btnText = item.cellType == 5 ? "升级" : "修改"
        cell.btnItme.set_Title(btnText)
        cell.lbLine.isHidden = item.cellType == 5
        cell.btnItme.addAction { [weak self]in
            guard let `self` = self else { return }
            if item.cellType == 1 {
                self.choosePhotoAction()
            }
            if item.cellType == 2 {
                if cell.tfDes.text! != XBUserManager.dv_babyname {
                    self.requestUpdateBabyInfo(babyName: cell.tfDes.text!, headImgUrl: XBUserManager.dv_headimgurl)
                }

            }
            if item.cellType == 5 { // 用户点击升级 版本
                self.clickUpdateVersionAction()
            }
        }
        return cell
        
    }
    func clickUpdateVersionAction()  {
        let v = NetSuccessView.loadFromNib()
        v.lbTitle.set_text = "是否升级" + self.newVersion + "?"
        v.viewType = .updateVersion
        v.btnSuccess.addAction {[weak self] in
            guard let `self` = self else { return }
            v.hide()
            self.scoketModel.sendUpdateDevice(self.newVersion, url: self.newVersionURL)
        }
        v.btnError.addAction {[weak self] in
            guard let `self` = self else { return }
            v.hide()
        }
        v.show()
    }
    func clickChangeAction(celltype: Int)  {
        switch celltype {
        case 1:
            
            break
        case 2:
            self.requestUpdateBabyInfo(babyName: "", headImgUrl: XBUserManager.dv_headimgurl)
            break
        default:
            break
        }
    }
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch indexPath.row {
//        case 1:
//            if let equimentModel = self.equimentModel {
//                VCRouter.toEquipmentInfoVC(equimentModel: equimentModel)
//            }
//        case 3:
//            print("解除绑定设备")
//            requestQuitEquiment()
//        case 4:
//            let vc = MemberManagerVC()
//            self.pushVC(vc)
//        default:
//            break
//        }
//    }

}
