//
//  ContentSongsTopCell.swift
//  SmartMain
//
//  Created by mac on 2018/12/6.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class ContentSongsTopCell: BaseTableViewCell {
    @IBOutlet weak var lbTopDes: UILabel!
    @IBOutlet weak var lbTopTotal: UILabel!
    
    @IBOutlet weak var heightLayout: NSLayoutConstraint!
    @IBOutlet weak var imgTop: UIImageView!
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var btnAddAll: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        heightLayout.adapterTop_X()
        print(btnAddAll.frame)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
