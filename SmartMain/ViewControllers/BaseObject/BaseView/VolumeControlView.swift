//
//  VolumeControlView.swift
//  SmartMain
//
//  Created by mac on 2018/9/28.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class VolumeControlView: ETPopupView {
    @IBOutlet weak var sliderVolume: UISlider!
    @IBOutlet weak var lbVolume: UILabel!
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var btnSure: UIButton!
    
    let scoketModel = ScoketMQTTManager.share
    override func awakeFromNib() {
        super.awakeFromNib()
        animationDuration = 0.3
        type = .alert
        self.snp.makeConstraints { (make) in
            make.width.equalTo(MGScreenWidth)
            make.height.equalTo(MGScreenHeight)
        }
        ETPopupWindow.sharedWindow().touchWildToHide = true
        self.layoutIfNeeded()
        self.addTapGesture { (sender) in
            self.hide()
        }
        btnSure.radius_ll()
        self.configVolume()
    }
    func configVolume()  {
        scoketModel.sendGetVolume()
        scoketModel.getPlayVolume.asObservable().subscribe { [weak self] in
            guard let `self` = self else { return }
            print("getPalyingVolume ===：", $0.element ?? 0)
            let volumeValue: Float = Float($0.element ?? 0) / 100
            self.sliderVolume.setValue(volumeValue, animated: true)
            self.lbVolume.set_text       = Int($0.element ?? 0).toString
            }.disposed(by: rx_disposeBag)
    }
    @IBAction func sliderVolumeValueChanged(_ sender: Any) {
        lbVolume.set_text       = Int(sliderVolume.value * 100).toString
        scoketModel.setVolumeValue(value: Int(sliderVolume.value * 100))
    }
    
}
