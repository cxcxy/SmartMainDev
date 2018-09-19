//
//  BSButton.swift
//  BSMaster
//
//  Created by 陈旭 on 2017/9/29.
//  Copyright © 2017年 陈旭. All rights reserved.
//

import Foundation
enum XBBtnPlaceholder:String {
    
    case photo              = "icon_touxiang"   // 默认头像
    case merchant           = "icon_default"    // 默认公司
    case none               = "placeholder_product"  // 默认展位图
    
}
import Accelerate
extension UIButton {
    
    //MARK: 扩展加载图片方法
    func set_Img_Url(_ url:String?,
                     _ placeHolder:XBImgPlaceholder = .none)  {
        let img = UIImage.init(named: placeHolder.rawValue)
        guard let url = url else {
            self.setImage(img, for: .normal)
            return
        }
        //        var url_new = url
        //        let arr = url.components(separatedBy: "&attname")
        //        if arr.count > 1 {
        //            url_new = arr[0]
        //        }
        if let url_request = URL(string: url) {
            self.kf.setBackgroundImage(with: url_request, for: .normal, placeholder: img, options: nil, progressBlock: nil, completionHandler: nil)
        
//            self.kf.setImage(with: url_request, for: .normal)
        }else {
            self.setImage(img, for: .normal)
        }
    }
    
}

