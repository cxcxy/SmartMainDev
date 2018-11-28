//
//  EquipmentListCell.swift
//  SmartMain
//
//  Created by mac on 2018/9/4.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class EquipmentListCell: BaseTableViewCell {

    @IBOutlet weak var btnItme: UIButton!
    @IBOutlet weak var viewBtn: UIView!
    @IBOutlet weak var tfDes: UITextField!
//    @IBOutlet weak var lbNumber: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    
     @IBOutlet weak var lbLine: UILabel!
    
    @IBOutlet weak var imgRight: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnItme.setCornerRadius(radius: 8)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
