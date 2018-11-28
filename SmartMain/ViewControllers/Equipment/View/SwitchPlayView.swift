//
//  SwitchPlayView.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/10/31.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
enum SwitchPlayType {
    case track // 预制列表
    case songs // 歌单
    case playing // 播放界面
    case photo // 选择照片
}
class SwitchPlayView: ETPopupView {

    @IBOutlet weak var imgAll: UIImageView!
    @IBOutlet weak var imgSing: UIImageView!
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var viewSing: UIView!
    @IBOutlet weak var viewAll: UIView!
    @IBOutlet weak var viewThree: UIView!
    
    @IBOutlet weak var lbOne: UILabel!
    @IBOutlet weak var lbTwo: UILabel!
    @IBOutlet weak var lbThree: UILabel!
    
    var switchPlayType: SwitchPlayType = .playing {
        didSet {
            switch switchPlayType {
            case .playing:
                lbOne.set_text = "单曲循环"
                lbTwo.set_text = "顺序播放"
                viewThree.isHidden = true
            case .track:
                lbOne.set_text = "收藏"
                lbTwo.set_text = "删除"
                imgAll.isHidden = true
                imgSing.isHidden = true
                viewThree.isHidden = true
            case .songs:
                lbOne.set_text = "试听"
                lbTwo.set_text = "添加到播单"
                lbThree.set_text = "收藏"
                imgAll.isHidden = true
                imgSing.isHidden = true
                viewThree.isHidden = false
            case .photo:
                lbOne.set_text = "拍照上传"
                lbTwo.set_text = "相册选择"
                imgAll.isHidden = true
                imgSing.isHidden = true
                viewThree.isHidden = true

            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContainer.setCornerRadius(radius: 8)
        animationDuration = 0.3
        type = .sheet
        
        self.snp.makeConstraints { (make) in
            make.width.equalTo(MGScreenWidth)
        }
        
        ETPopupWindow.sharedWindow().touchWildToHide = true
        self.setCornerRadius(radius: 5.0)
        self.layoutIfNeeded()
    }

}
