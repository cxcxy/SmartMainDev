//
//  ChatRedView.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/10/8.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class ChatRedView: UIView {
    @IBOutlet weak var viewSearch: UIImageView!
    @IBOutlet weak var viewMessage: UIImageView!
    @IBOutlet weak var viewRed: UIView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        viewRed.roundView()
    }
}
