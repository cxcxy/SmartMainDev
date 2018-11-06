//
//  TwoItemCVCell.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/30.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class TwoItemCVCell: UICollectionViewCell {
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    //内容图片的宽高比约束
    @IBOutlet weak var aspectConstraint : NSLayoutConstraint!
//    //内容图片的宽高比约束

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        imgIcon.setCornerRadius(radius: 5)
//        self.setNeedsLayout()
//        self.layoutIfNeeded()
//         self.contentView.layoutIfNeeded()
//        imgIcon.roundView()
//        self.setNeedsLayout()
//         self.layoutIfNeeded()
    }

}
