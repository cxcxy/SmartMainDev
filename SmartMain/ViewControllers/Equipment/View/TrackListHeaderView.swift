//
//  TrackListHeaderView.swift
//  SmartMain
//
//  Created by mac on 2018/10/10.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class TrackListHeaderView: UIView {
    @IBOutlet weak var lbTotal: UILabel!
    @IBOutlet weak var viewDefault: UIView!
    @IBOutlet weak var btnDefault: UIButton!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        viewDefault.addBorder(width: 0.5, color: viewColor)
        viewDefault.radius_l()
    }
}
