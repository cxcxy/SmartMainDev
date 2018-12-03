//
//  SmartHindView.swift
//  SmartMain
//
//  Created by mac on 2018/12/3.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
enum SmartHindType {
    case out // tuichu
    case delete // 删除
    case reset // 清空
    case resetDefault // 恢复默认列表
}
typealias SmartHindActionBloack = (_ isSure: Bool) -> ()
class SmartHindView: ETPopupViewCustom {
    var hindType: SmartHindType = .out {
        didSet{
            switch hindType {
            case .delete:
                lbTitle.set_text = "是否删除？"
            case .out:
                lbTitle.set_text = "是否退出？"
            case .resetDefault:
                lbTitle.set_text = "是否恢复默认列表？"
            case .reset:
                lbTitle.set_text = "是否清空？"
            }
        }
    }
    var block : SmartHindActionBloack?
    @IBOutlet weak var viewSure: UIView!
    @IBOutlet weak var viewCancel: UIView!
    
    @IBOutlet weak var lbTitle: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        viewSure.setCornerRadius(radius: 20)
        viewCancel.setCornerRadius(radius: 20)
        viewCancel.addBorder(width: 0.5, color: UIColor.init(hexString: "7ecc3b")!)
        self.snp.makeConstraints { (make) in
            make.height.equalTo(160)
            make.width.equalTo(MGScreenWidth - 40)
        }
        self.setCornerRadius(radius: 8)

    }
    @IBAction func clickSureAction(_ sender: Any) {
        self.hide()
        if let block = self.block {
            block(true)
        }
    }
    @IBAction func clickCancelAction(_ sender: Any) {
        self.hide()
        if let block = self.block {
            block(false)
        }
    }
}
