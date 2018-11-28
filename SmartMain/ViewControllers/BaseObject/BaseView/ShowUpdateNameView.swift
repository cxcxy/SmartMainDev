//
//  ShowUpdateNameView.swift
//  SmartMain
//
//  Created by mac on 2018/11/28.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class ShowUpdateNameView: ETPopupViewCustom {

    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var textView: XBTextView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        self.snp.makeConstraints { (make) in
            make.width.equalTo(MGScreenWidth - 40)
        }
        self.setCornerRadius(radius: 8)
        textView.radius_ll()
        textView.addBorder(width: 0.5, color: UIColor.init(hexString: "D2D2D2")!)
//        textView.textField.rx
        btnLogin.radius_ll()
    }
    // 弹出键盘
    override func showKeyBoard() {
        self.textView.textField.becomeFirstResponder()
    }
}
