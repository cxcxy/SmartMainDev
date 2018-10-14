//
//  ConfigNetCVCell.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/10/5.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class ConfigNetCVCell: UICollectionViewCell,UITextFieldDelegate {
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewTopLayer: UIView!
    @IBOutlet weak var lbTop: UILabel!
    @IBOutlet weak var lbNumber: UILabel!
    @IBOutlet weak var lbBottom: UILabel!
    @IBOutlet weak var viewCenter: UIView!
    @IBOutlet weak var viewConfigNet: UIView!
    
    @IBOutlet weak var viewWifiName: UIView!
    @IBOutlet weak var viewWifiPass: UIView!
    
    @IBOutlet weak var tfWifiName: UITextField!

    @IBOutlet weak var tfWifiPass: UITextField!
    var configNetInfo:NetInfo? {
        didSet{
            guard let configNetInfo = configNetInfo else {
                return
            }
            tfWifiName.text = configNetInfo.name
            tfWifiPass.text = configNetInfo.password
        }
    }
    var currentIndex: Int? {
        didSet {
            guard let currentIndex = currentIndex else {
                return
            }
            viewConfigNet.isHidden = currentIndex == 1 ? false : true
            viewCenter.isHidden = currentIndex == 1 ? true : false
            switch currentIndex {
            case 0:
                lbTop.set_text = "请将电源键打开至“ON”"
                lbBottom.set_text = "将设备开启"
                viewTop.backgroundColor = MGRgb(119, g: 177, b: 241)
                lbNumber.set_text = "第一步"
                break
            case 1:
                lbTop.set_text = "请设置您的无线网"
                lbBottom.set_text = "并连接"
                viewTop.backgroundColor = MGRgb(247, g: 161, b: 167)
                lbNumber.set_text = "第二步"
                break
            case 2:
                lbTop.set_text = "请长按配网键3秒"
                lbBottom.set_text = "开启联网模式"
                viewTop.backgroundColor = MGRgb(224, g: 161, b: 252)
                lbNumber.set_text = "第三步"
                break
            case 3:
                lbTop.set_text = "请将手机靠近设备"
                lbBottom.set_text = "尽量选择安静的环境"
                viewTop.backgroundColor = MGRgb(249, g: 193, b: 92)
                lbNumber.set_text = "第四步"
                break
            default:
                break
            }
            viewTopLayer.backgroundColor = viewTop.backgroundColor
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewTop.setCornerRadius(radius: 15)
        viewWifiName.radius_l()
        viewWifiPass.radius_l()
        viewWifiName.addBorder(width: 0.5, color: lineColor)
        viewWifiPass.addBorder(width: 0.5, color: lineColor)
        tfWifiPass.delegate = self
        tfWifiName.delegate = self
        tfWifiName.tintColor = viewColor
        tfWifiPass.tintColor = viewColor
    }

}
extension ConfigNetCVCell {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == tfWifiName {
            self.configNetInfo?.name = tfWifiName.text ?? ""
        }
        if textField == tfWifiPass {
            self.configNetInfo?.password = tfWifiPass.text ?? ""
        }
    }
}
