//
//  ShowChooseView.swift
//  SmartMain
//
//  Created by mac on 2018/9/11.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class ShowChooseView: ETPopupView {
    @IBOutlet weak var btnDelTrackList: UIButton!
    
    @IBOutlet weak var btnAddTrackList: UIButton!
    
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnCancleLike: UIButton!
    @IBOutlet weak var btnDeleteDemand: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        //        UIApplication.shared.keyWindow?.endEditing(true)
        animationDuration = 0.3
        type = .sheet
        self.snp.makeConstraints { (make) in
            make.width.equalTo(MGScreenWidth)
            make.height.equalTo(200)
        }
        ETPopupWindow.sharedWindow().touchWildToHide = true
        self.setCornerRadius(radius: 2.0)
        self.layoutIfNeeded()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
