//
//  DeviceChooseCell.swift
//  SmartMain
//
//  Created by mac on 2018/10/11.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class DeviceChooseCell: UICollectionViewCell {

    @IBOutlet weak var imgManagerWidth: NSLayoutConstraint!
    
//    @IBOutlet weak var imgPhotoWidth: NSLayoutConstraint!
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var imgManager: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbCurrent: UILabel!
    @IBOutlet weak var btnDel: UIButton!
    
    var model : XBDeviceBabyModel? {
        didSet {
            guard let m = model else {
                return
            }
            lbName.set_text = m.babyname
            imgPhoto.set_Img_Url(m.headimgurl,.photo)
//            viewContainer.backgroundColor = m.isCurrent ? UIColor.init(hexString: "BEDEA9") : UIColor.init(hexString: "ECBD9C")
//            imgManager.isHidden = m.isCurrent ? false : true
            btnDel.isHidden = m.isCurrent ? false : true

            if m.onLine || m.isCurrent{ // 当在线的时候 或者是当前所使用的
                imgManager.isHidden = false
                if m.isCurrent {
                     imgManager.set_img = "icon_use"
                    imgManagerWidth.constant = 68
                } else {
                    imgManager.set_img = "icon_online"
                    imgManagerWidth.constant = 48
                }
                
            } else {
                imgManager.isHidden = true
            }
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        if UIDevice.deviceType == .dt_iPhone5 {
////            imgPhotoWidth.constant = 60/
//            imgPhoto.layoutIfNeeded()
//            imgPhoto.roundView()
//        } else {
//            imgPhoto.layoutIfNeeded()
//            imgPhoto.roundView()
//        }
        
        imgPhoto.setNeedsUpdateConstraints()
        viewContainer.setCornerRadius(radius: 8)
        viewContainer.addBorder(width: 0.5, color: UIColor.init(hexString: "eaeaea")!)
        btnDel.isHidden = false
//        lbCurrent.isHidden = true
    }
    override func layoutSubviews() {
        super.layoutSubviews()
//        imgPhoto.layoutIfNeeded()
        imgPhoto.roundView()
//
//        btnCenterNew.frame.size.height  = 49 - 3
//        btnHomeNew.frame.size.height    = 49 - 3
//        btnCode.frame.size.height       = QRCodeBtnWidth
        
//        btnHomeNew.setButtonImageTitleStyle(.top, padding: 3)
//        btnCenterNew.setButtonImageTitleStyle(.top, padding: 3)
    }
}
