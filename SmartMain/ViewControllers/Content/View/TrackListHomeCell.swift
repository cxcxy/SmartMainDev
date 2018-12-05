//
//  TrackListHomeCell.swift
//  SmartMain
//
//  Created by mac on 2018/10/11.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class TrackListHomeCell: BaseTableViewCell {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lbTatal: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        imgIcon.setCornerRadius(radius: 8)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
