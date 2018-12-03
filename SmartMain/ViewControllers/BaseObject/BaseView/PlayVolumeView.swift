//
//  PlayVolumeView.swift
//  SmartMain
//
//  Created by mac on 2018/11/22.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
protocol PlayVolumeChangeDelegate: class {
    func getVolumeValue(volumeValue: Int)
}
class PlayVolumeView: ETPopupView{
    var currentVolume: Int = 0 {
        didSet {
            self.volumeChangeAction()
        }
    }
    weak var delegate: PlayVolumeChangeDelegate?
    @IBOutlet weak var viewVolume: UIView!
    @IBOutlet weak var progressVolume: UIProgressView!
    @IBOutlet weak var lbVolumeRight: NSLayoutConstraint!
    @IBOutlet weak var lbVolume: UILabel!
    @IBOutlet weak var sliderVolume: UISlider!
    let scoketModel = ScoketMQTTManager.share
    override func awakeFromNib() {
        super.awakeFromNib()
        animationDuration = 0.3
        type = .top
        
        self.snp.makeConstraints { (make) in
            make.width.equalTo(MGScreenWidth)
        }
        viewVolume.setCornerRadius(radius: 5)
        ETPopupWindow.sharedWindow().touchWildToHide = true
        UIApplication.shared.keyWindow?.endEditing(true)
        self.layoutIfNeeded()
        sliderVolume.maximumValue = 40
        self.configScoketModel()
        
    }
    func volumeChangeAction()  {
        if let del = delegate {
            del.getVolumeValue(volumeValue: currentVolume)
        }
    }
    func configScoketModel() {
        scoketModel.getPlayVolume.asObservable().subscribe { [weak self] in
            guard let `self` = self else { return }
            print("getPalyingVolume ===：", $0.element ?? 0)
            let volumeValue: Float = Float($0.element ?? 0)
            self.updateLbVolumeFrame(value: volumeValue)
        }.disposed(by: rx_disposeBag)
    }
    func updateLbVolumeFrame(value: Float)  {
        self.sliderVolume.setValue(value, animated: true)
        let maximumValue = sliderVolume.maximumValue
        self.currentVolume = Int(value)
        progressVolume.progress = maximumValue == 0 ? 0 : ( value / maximumValue )
        let v = Float(viewVolume.w) / maximumValue
        lbVolumeRight.constant = CGFloat(value * v) - 10
        lbVolume.set_text = String(Int(value))
    }
    @IBAction func sliderVolumeValueChange(_ sender: Any) {
        
        let value = sliderVolume.value
        scoketModel.setVolumeValue(value: Int(value))
        self.updateLbVolumeFrame(value: value)
    }
    @IBAction func clickCutAction(_ sender: Any) {
        if self.currentVolume <= 0 {
            return
        }
        self.currentVolume = self.currentVolume - 1
        scoketModel.setVolumeValue(value: currentVolume)
        self.updateLbVolumeFrame(value: Float(self.currentVolume))
    }
    
    @IBAction func clickAddAction(_ sender: Any) {
        if self.currentVolume >= 100 {
            return
        }
        self.currentVolume = self.currentVolume + 1
        scoketModel.setVolumeValue(value: currentVolume)
        self.updateLbVolumeFrame(value: Float(self.currentVolume))
    }
}
