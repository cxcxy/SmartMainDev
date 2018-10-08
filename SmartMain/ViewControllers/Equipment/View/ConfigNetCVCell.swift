//
//  ConfigNetCVCell.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/10/5.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class ConfigNetCVCell: UICollectionViewCell {
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lbTop: UILabel!
    @IBOutlet weak var lbBottom: UILabel!
    @IBOutlet weak var viewCenter: UIView!
    var currentIndex: Int? {
        didSet {
            guard let currentIndex = currentIndex else {
                return
            }
            switch currentIndex {
            case 0:
                lbTop.set_text = "请将电源键打开至“ON”"
                lbBottom.set_text = "将设备开启"
                viewTop.backgroundColor = MGRgb(119, g: 177, b: 241)
                break
            case 1:
                lbTop.set_text = "请设置您的无线网"
                lbBottom.set_text = "并连接"
                viewTop.backgroundColor = MGRgb(247, g: 161, b: 167)
                break
            case 2:
                lbTop.set_text = "请长按配网键3秒"
                lbBottom.set_text = "开启联网模式"
                viewTop.backgroundColor = MGRgb(224, g: 161, b: 252)
                break
            case 3:
                lbTop.set_text = "请将手机靠近设备"
                lbBottom.set_text = "尽量选择安静的环境"
                viewTop.backgroundColor = MGRgb(249, g: 193, b: 92)
                break
            default:
                break
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
