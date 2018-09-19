//
//  ContentTitleCVCell.swift
//  SmartMain
//
//  Created by mac on 2018/9/6.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class ContentTitleCVCell: UICollectionViewCell {
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var viewBack: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewBack.setCornerRadius(radius: 5.0)
        self.viewBack.layer.shadowOpacity = 0.8
        self.viewBack.layer.shadowColor = UIColor.black.cgColor
        self.viewBack.layer.shadowOffset = CGSize(width: 1, height: 1)
        
    }

}
