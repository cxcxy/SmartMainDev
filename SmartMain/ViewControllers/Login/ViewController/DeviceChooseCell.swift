//
//  DeviceChooseCell.swift
//  SmartMain
//
//  Created by mac on 2018/10/11.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class DeviceChooseCell: UICollectionViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbCurrent: UILabel!
    @IBOutlet weak var btnDel: UIButton!
    
    var model : XBDeviceBabyModel? {
        didSet {
            guard let m = model else {
                return
            }
            lbName.set_text = m.babyname
            imgPhoto.set_Img_Url(m.headimgurl)
            viewContainer.backgroundColor = m.isCurrent ? UIColor.init(hexString: "BEDEA9") : UIColor.init(hexString: "ECBD9C")
            lbCurrent.isHidden = m.isCurrent ? false : true
            btnDel.isHidden = m.isCurrent ? false : true
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewContainer.layoutIfNeeded()
        viewContainer.setCornerRadius(radius: 8)
        imgPhoto.roundView()
        btnDel.isHidden = false
    }

}
