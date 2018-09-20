//
//  BottomSongView.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/20.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class BottomSongView: UIView {
    @IBOutlet weak var imgSong: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        imgSong.roundView()
         bottomView.addBorderTop(size: 0.5, color: MGRgb(229, g: 229, b: 229))
    }
}
