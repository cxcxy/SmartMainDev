//
//  HistorySongContentCell.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/25.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class HistorySongContentCell: BaseTableViewCell {
    
    @IBOutlet weak var viewAdd: UIView!
    @IBOutlet weak var viewDel: UIView!
    @IBOutlet weak var viewLike: UIView!
    @IBOutlet weak var lbLike: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
