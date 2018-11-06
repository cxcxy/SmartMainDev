//
//  NetSuccessView.swift
//  SmartMain
//
//  Created by mac on 2018/10/9.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
enum NetSuccessViewType {
    case configNet
    case updateVersion
}
class NetSuccessView: ETPopupView {
     @IBOutlet weak var btnSuccess: UIButton!
     @IBOutlet weak var btnError: UIButton!
     @IBOutlet weak var lbTitle: UILabel!
     @IBOutlet weak var imgIcon: UIImageView!
    var viewType: NetSuccessViewType = .configNet {
        didSet {
            switch viewType {
            case .configNet:
                lbTitle.set_text = "机器人收到网络信息了吗？"
                btnSuccess.set_Title("成功配网")
                btnError.set_Title("配网不成功")
                break
            case .updateVersion:
                imgIcon.set_img = "update"
                btnSuccess.set_Title("立刻升级")
                btnError.set_Title("跳过此版本")
                break
            }
        }
    }
//     @IBOutlet weak var btnError: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        btnSuccess.radius_ll()
        btnError.addBorder(width: 0.5, color: viewColor)
        btnError.radius_ll()
        animationDuration = 0.3
        type = .alert
        let viewWidth = MGScreenWidth - 60
        let viewHeight = viewWidth * 3 / 2
        self.snp.makeConstraints { (make) in
            make.width.equalTo(300)
            make.height.equalTo(410)
        }
        ETPopupWindow.sharedWindow().touchWildToHide = true
        self.setCornerRadius(radius: 5.0)
        self.layoutIfNeeded()
    }
}
