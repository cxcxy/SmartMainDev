//
//  TwoItemCVCell.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/30.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class TwoItemCVCell: UICollectionViewCell {
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    //内容图片的宽高比约束
    @IBOutlet weak var aspectConstraint : NSLayoutConstraint!
//    //内容图片的宽高比约束
//    internal var aspectConstraint : NSLayoutConstraint? {
//        didSet {
//            if oldValue != nil {
//                //删除旧的约束
//                LayoutConstraint.deactivate([oldValue!])
//            }
//            if aspectConstraint != nil {
//                LayoutConstraint.activate([aspectConstraint!])
//
//            }
//        }
//    }
//    func showData(_ secondaryImg: ModulesResModel?) {
//        if let m = secondaryImg {
//            if let img = m.icon {
//                if img.isEmpty {
//                    self.imgIcon.isHidden = true
//                    aspectConstraint = NSLayoutConstraint(item: self.imgIcon,
//                                                          attribute: .width, relatedBy: .equal,
//                                                          toItem: self.imgIcon, attribute: .height,
//                                                          multiplier: 1000 , constant: 0.0)
//                    
//                }else {
//                    self.imgIcon.isHidden = false
//                    aspectConstraint = NSLayoutConstraint(item: self.imgIcon,
//                                                          attribute: .width, relatedBy: .equal,
//                                                          toItem: self.imgIcon, attribute: .height,
//                                                          multiplier: m.imageAspect , constant: 0.0)
//                    
//                    imgIcon.set_Img_Url(img)
//                    
//                }
//            }else {
//                self.imgIcon.isHidden = true
//                aspectConstraint = NSLayoutConstraint(item: self.imgIcon,
//                                                      attribute: .width, relatedBy: .equal,
//                                                      toItem: self.imgIcon, attribute: .height,
//                                                      multiplier: 1000 , constant: 0.0)
//            }
//        }
//
//        
//    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgIcon.setCornerRadius(radius: 5)
    }

}
