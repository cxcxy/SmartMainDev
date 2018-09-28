//
//  ContentShowCVCell.swift
//  SmartMain
//
//  Created by mac on 2018/9/4.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class ContentShowCVCell: UICollectionViewCell {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var btnDel: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnDel.isHidden = true
    }

}
