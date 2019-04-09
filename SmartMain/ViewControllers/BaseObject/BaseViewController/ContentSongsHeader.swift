//
//  ContentSongsHeader.swift
//  SmartMain
//
//  Created by mac on 2018/11/27.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
/// 没用，用了ContentSongsTopCell
class ContentSongsHeader: UIView {
    @IBOutlet weak var lbTopDes: UILabel!
    @IBOutlet weak var lbTopTotal: UILabel!

    @IBOutlet weak var imgTop: UIImageView!
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var btnAddAll: UIButton!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        self.w = MGScreenWidth
        print(btnAddAll.frame)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.w = MGScreenWidth
        print(btnAddAll.frame)
    }

}
