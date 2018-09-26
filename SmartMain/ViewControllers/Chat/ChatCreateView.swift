//
//  ChatCreateView.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/20.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class ChatCreateView: UIView {

    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var viewInput: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var tfName: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewInput.setCornerRadius(radius: 8)
//        viewInput.addBorderTop(size: 0.5, color: lineColor)
        viewInput.addBorder(width: 0.5, color: lineColor)
        btnAdd.setCornerRadius(radius: 12)
    }
}
