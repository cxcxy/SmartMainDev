//
//  XBLoginOutView.swift
//  XBShinkansen
//
//  Created by mac on 2017/12/11.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit

class XBLoginOutView: ETPopupView {
    var cancelBlock:XBActionClosure?
    var sureBlock:XBActionClosure?
    var delay : Double = 0.0
    @IBOutlet weak var lbTitleDes: UILabel!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnOut: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        animationDuration = 0.3
        type = .alert
        
        self.snp.makeConstraints { (make) in
            make.width.equalTo(MGScreenWidth - 70)
        }
        ETPopupWindow.sharedWindow().touchWildToHide = true
        UIApplication.shared.keyWindow?.endEditing(true)
        self.setCornerRadius(radius: 5.0)
        self.layoutIfNeeded()
        
    }
    func  setUI_Title(_ titleStr: String) {
        lbTitleDes.set_text = titleStr
    }

    @IBAction func clickCancelAction(_ sender: Any) {
        self.hide()
        
        if let block = self.cancelBlock {
            XBDelay.start(delay: delay) {
                block()
            }
        }
    }
    
    @IBAction func clickContinueAction(_ sender: Any) {
        self.hide()
        XBDelay.start(delay: delay) {
            if let block = self.sureBlock {
                block()
            }
        }
    }
}
