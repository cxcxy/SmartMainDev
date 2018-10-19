//
//  ContentSingSongCell.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/10/16.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class ContentSingSongCell: BaseTableViewCell {
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var imgRight: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgIcon.roundView()
        // Initialization code
        imgRight.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
