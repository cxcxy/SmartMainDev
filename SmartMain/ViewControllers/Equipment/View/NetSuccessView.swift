//
//  NetSuccessView.swift
//  SmartMain
//
//  Created by mac on 2018/10/9.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class NetSuccessView: ETPopupView {
     @IBOutlet weak var btnSuccess: UIButton!
     @IBOutlet weak var btnError: UIButton!
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
            make.width.equalTo(viewWidth)
            make.height.equalTo(viewHeight)
        }
        ETPopupWindow.sharedWindow().touchWildToHide = true
        self.setCornerRadius(radius: 5.0)
        self.layoutIfNeeded()
    }
}
