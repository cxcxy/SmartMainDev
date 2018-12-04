//
//  WOW_SingProductView.swift
//  WOWScrollView
//
//  Created by 陈旭 on 2016/10/19.
//  Copyright © 2016年 陈旭. All rights reserved.
//

import UIKit
class ConfigNetModel: NSObject {
    var title: String = ""
    var des: String = ""
    var img: String = ""
}
typealias ClickImgBlock =  (_ productId: Int) -> ()
class WOW_SingProductView: UIView {
    var productIdBlock :ClickImgBlock!

    @IBOutlet weak var priceLabel: UILabel!

    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lb_SingTodayName: UILabel!

    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var imgVieww: UIImageView!
    var model: ConfigNetModel?
    override func awakeFromNib() {
        super.awakeFromNib()

        self.snp.makeConstraints { (make) in
            make.width.equalTo(MGScreenWidth)
        }
         self.layoutIfNeeded()

    }
}
