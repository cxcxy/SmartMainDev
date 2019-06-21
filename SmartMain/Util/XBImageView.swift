//
//  BSImageView.swift
//  BSMaster
//
//  Created by 陈旭 on 2017/9/29.
//  Copyright © 2017年 陈旭. All rights reserved.
//

import Foundation
enum XBImgPlaceholder:String {
    /// 头像默认图片
    case photo              = "icon_photo"
    /// 设备默认图片
    case equipment           = "icon_none_equipment"
    /// 默认图片
    case none               = "placeholder_product"
}
import Accelerate
extension UIImageView {

    //MARK: 扩展加载图片方法
    func set_Img_Url(_ url:String?,
                     _ placeHolder:XBImgPlaceholder = .equipment)  {
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
