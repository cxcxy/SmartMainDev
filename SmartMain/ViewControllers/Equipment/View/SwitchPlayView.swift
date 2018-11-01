//
//  SwitchPlayView.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/10/31.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class SwitchPlayView: ETPopupView {

    @IBOutlet weak var imgAll: UIImageView!
    @IBOutlet weak var imgSing: UIImageView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewSing: UIView!
    @IBOutlet weak var viewAll: UIView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContainer.setCornerRadius(radius: 8)
        animationDuration = 0.3
        type = .sheet
        self.snp.makeConstraints { (make) in
            make.width.equalTo(MGScreenWidth)
            make.height.equalTo(120)
        }
        ETPopupWindow.sharedWindow().touchWildToHide = true
        self.setCornerRadius(radius: 5.0)
        self.layoutIfNeeded()
    }

}
