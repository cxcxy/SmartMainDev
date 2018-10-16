//
//  ContentNineGridItem.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/10/16.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class ContentNineGridItem: UICollectionViewCell {
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgIcon.setCornerRadius(radius: 12)
    }

}
