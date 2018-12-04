//
//  NetConfigTipView.swift
//  SmartMain
//
//  Created by mac on 2018/12/4.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class NetConfigTipView: ETPopupViewAlert {

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
            make.width.equalTo(MGScreenWidth - 60)
//            make.height.equalTo(260)
        }
        
        self.setCornerRadius(radius: 5.0)
        
        
    }
}
