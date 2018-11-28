//
//  EquipmentSetHeaderCell.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/4.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class EquipmentSetHeaderCell: BaseTableViewCell {
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbElectricity: UILabel!
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var viewPhoto: UIView!
    
    @IBOutlet weak var viewName: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgPhoto.roundView()
        
//        lbTitle.set_text = XBUserManager.dv_babyname
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
