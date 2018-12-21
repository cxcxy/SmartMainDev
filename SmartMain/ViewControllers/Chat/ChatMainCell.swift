//
//  ChatMainCell.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/20.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class ChatMainCell: BaseTableViewCell {
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbDes: UILabel!
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var lbMessage: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code、
        viewContainer.setCornerRadius(radius: 5.0)
        viewMessage.setCornerRadius(radius: 10)
        imgPhoto.roundView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
