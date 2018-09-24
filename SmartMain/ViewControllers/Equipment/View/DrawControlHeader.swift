//
//  DrawControlHeader.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/20.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class DrawControlHeader: UIView {

    @IBOutlet weak var btnLook: UIButton!
    
    @IBOutlet weak var btnLight: UIButton!
    
    @IBOutlet weak var btnVolume: UIButton!
    
    @IBOutlet weak var btnSleep: UIButton!
    
    let scoketModel = ScoketMQTTManager.share
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        scoketModel.getLight
        scoketModel.getLight.asObservable().subscribe { [weak self] in
            guard let `self` = self else { return }
            print("getLight ===：", $0.element ?? 0)
            //            self.requestSingsDetail(trackId: $0.element ?? 0)
            self.btnLight.isSelected = ($0.element ?? 0) == 1 ? true : false
        }.disposed(by: rx_disposeBag)
    }
    
    @IBAction func clickLockAction(_ sender: Any) {

        
        
    }
    
    @IBAction func btnLightAction(_ sender: Any) {
        if btnLight.isSelected {
            
            scoketModel.sendClooseLight(0)
        }else {
            scoketModel.sendClooseLight(1)
        }
        btnLight.isSelected = !btnLight.isSelected
    }
    
    @IBAction func clickVolumeAction(_ sender: Any) {
    }
    
    @IBAction func clickSleepAction(_ sender: Any) {
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
