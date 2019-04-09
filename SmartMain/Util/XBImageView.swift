//
//  BSImageView.swift
//  BSMaster
//
//  Created by 陈旭 on 2017/9/29.
//  Copyright © 2017年 陈旭. All rights reserved.
//

import Foundation
enum XBImgPlaceholder:String {
    
    case photo              = "icon_touxiang"   // 默认头像
    case merchant           = "icon_shangjia"    // 默认公司
    case none               = "icon_photo"  // 默认展位图
    case phone              = "icon_touxiangmr2"  // 手机通讯录默认头像
}
import Accelerate
extension UIImageView {

    //MARK: 扩展加载图片方法
    func set_Img_Url(_ url:String?,
                     _ placeHolder:XBImgPlaceholder = .none)  {
        let img = UIImage.init(named: placeHolder.rawValue)
        guard let urlNew = url else {
            self.image = img
            return
        }
        if let url_request = URL(string: urlNew.urlEncodedNew()) {
            
            self.kf.setImage(with: url_request,
                         placeholder: img)

        }else {
             self.image = img
        }
    }
   
}
