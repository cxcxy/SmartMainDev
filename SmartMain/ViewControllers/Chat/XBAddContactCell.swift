//
//  XBAddContactCell.swift
//  XBPMDev
//
//  Created by mike.sun on 2018/4/9.
//  Copyright © 2018年 mac-cx. All rights reserved.
//

import UIKit

class XBAddContactCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgDelete: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    
//    var modelData:ApproveUserListModel! {
//        didSet {
//            imgView.set_Img_Url(modelData.logo)
//            titleLab.text = modelData.dispname
//        }
//    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgView.roundView()
        imgView.addBorder(width: 1.0, color: UIColor.init(hexString: "e5e5e5")!)
    }
}
