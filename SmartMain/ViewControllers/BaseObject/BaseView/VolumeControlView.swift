//
//  VolumeControlView.swift
//  SmartMain
//
//  Created by mac on 2018/9/28.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class VolumeControlView: ETPopupView,SectionedSliderDelegate {
//    @IBOutlet weak var sliderVolume: UISlider!
    @IBOutlet weak var lbVolume: UILabel!
    
//    @IBOutlet weak var btnAdd: UIButton!
//    @IBOutlet weak var btnCut: UIButton!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var btnSure: UIButton!
    
    @IBOutlet weak var sliderView: SectionedSlider!
    var currentVolume: Int = 0
    
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
        
        sliderView.sections = 100
        sliderView.delegate = self
        //        sliderView.
        sliderView.layer.cornerRadius = 30
        sliderView.layer.masksToBounds = true
        
        self.configVolume()
    }
    func configVolume()  {
        scoketModel.sendGetVolume()
        scoketModel.getPlayVolume.asObservable().subscribe { [weak self] in
            guard let `self` = self else { return }
            print("getPalyingVolume ===：", $0.element ?? 0)
            let volumeValue: Int = Int($0.element ?? 0)
//            self.sliderVolume.setValue(volumeValue, animated: true)
            self.sliderView.selectedSection = volumeValue
//            self.lbVolume.set_text       = Int($0.element ?? 0).toString
            self.currentVolume = $0.element ?? 0
            }.disposed(by: rx_disposeBag)
    }
    
    func sectionChanged(slider: SectionedSlider, selected: Int) {
        print(selected)
        self.currentVolume = selected
    }
    @IBAction func sliderVolumeValueChanged(_ sender: Any) {
//        lbVolume.set_text       = Int(sliderVolume.value * 100).toString
//        self.currentVolume = Int(sliderVolume.value)
        
    }
    @IBAction func clickSureAction(_ sender: Any) {
        scoketModel.setVolumeValue(value: currentVolume)
    }
    
    @IBAction func clickCutAction(_ sender: Any) {
        if self.currentVolume <= 0 {
            return
        }
        self.currentVolume = self.currentVolume - 1
//        sliderVolume.setValue(Float(self.currentVolume), animated: true)
    }
    
    @IBAction func clickAddAction(_ sender: Any) {
        if self.currentVolume >= 100 {
            return
        }
        self.currentVolume = self.currentVolume + 1
//        sliderVolume.setValue(Float(self.currentVolume), animated: true)
    }
    
    
    
}
