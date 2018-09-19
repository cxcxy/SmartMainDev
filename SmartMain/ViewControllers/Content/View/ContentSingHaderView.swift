//
//  ContentSingHaderView.swift
//  SmartMain
//
//  Created by mac on 2018/9/5.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class ContentSingHaderView: UIView {

    @IBOutlet weak var btnAddAll: UIButton!
    @IBOutlet weak var lbTotal: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        btnAddAll.setCornerRadius(radius: 8)
        btnAddAll.addBorder(width: 0.5, color: tableColor)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
