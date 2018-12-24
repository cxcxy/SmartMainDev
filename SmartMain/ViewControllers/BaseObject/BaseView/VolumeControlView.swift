//
//  VolumeControlView.swift
//  SmartMain
//
//  Created by mac on 2018/9/28.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
protocol VolumeControlDelegate: class {
    func getVolumeNumber(volume: Int)
}
class VolumeControlView: ETPopupView,UIGestureRecognizerDelegate {
//    @IBOutlet weak var sliderVolume: UISlider!
    @IBOutlet weak var lbVolume: UILabel!
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var btnSure: UIButton!
    
    @IBOutlet weak var widthLayout: NSLayoutConstraint!
    @IBOutlet weak var heightLayout: NSLayoutConstraint!
//    @IBOutlet weak var sliderView: SectionedSlider!
    
//    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewSlider: UIView!
    @IBOutlet weak var sliderHeightLayout: NSLayoutConstraint!
    
    
    var currentVolume: Int = 0
    weak var delegate: VolumeControlDelegate?
    let scoketModel = ScoketMQTTManager.share
    override func awakeFromNib() {
        super.awakeFromNib()
        animationDuration = 0.3
        type = .alert
        self.snp.makeConstraints { (make) in
            make.width.equalTo(MGScreenWidth)
            make.height.equalTo(MGScreenHeight)
        }
//        ETPopupWindow.sharedWindow().touchWildToHide = true
        self.layoutIfNeeded()
//        self.addTapGesture { (sender) in
//            self.hide()
//        }
        let tapSingle                       = UITapGestureRecognizer(target:self,action:#selector(tapSingleDid))
        tapSingle.numberOfTapsRequired      = 1
        tapSingle.numberOfTouchesRequired   = 1
        tapSingle.delegate = self
        self.addGestureRecognizer(tapSingle)
        btnSure.radius_ll()
        
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(VolumeControlView.dragged(gesture:)))
        self.viewContainer.addGestureRecognizer(gesture)
        viewContainer.layer.cornerRadius = 35
        viewContainer.layer.masksToBounds = true
        
        if UIDevice.deviceType == .dt_iPhone5 {
            widthLayout.constant = 100
            heightLayout.constant = 255
        }
        
       
    }
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        guard
            let touch = touches.first
            else { return }
        
        var x = self.viewSlider.frame.height - touch.location(in: self.viewSlider).y
        x = x < 0 ? -1 : (x > self.viewSlider.frame.height ? self.viewSlider.frame.height : x)
        
        let  factor = x / self.viewSlider.frame.height
        print("touchesBegan",factor)
        
    }
    
    @objc private func dragged(gesture: UIPanGestureRecognizer) {
        
        let point = gesture.location(in: self.viewContainer)
        var x = self.viewContainer.frame.height - point.y
        x = x < 0 ? -1 : (x > self.viewContainer.frame.height ? self.viewContainer.frame.height : x)
        let f = x / self.viewContainer.frame.height // 所占比例  0.0 - 1.0
        let factor = f <= 0 ? 0 : f
        
        self.updateViewSliderFrame(factor: factor)
        if gesture.state == .ended {
            print("滑动结束",factor)
            self.updateCurrentVolume(factor: factor)
        }
        
    }
    func updateViewSliderFrame(factor: CGFloat)  {
//        print("dragged",factor)
        let height = self.viewContainer.frame.height
//        print("height",height)
        sliderHeightLayout.constant = factor * height
    
    }
    func updateCurrentVolume(factor: CGFloat) {
        self.currentVolume = Int(factor * 40)
        scoketModel.setVolumeValue(value: Int(factor * 40))
        if let del = delegate {
            del.getVolumeNumber(volume: self.currentVolume)
        }
    }
    @objc func tapSingleDid(){
        self.hide()
    }
    // 解决collectionView 点击事件被手势覆盖，无法响应问题
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: viewContainer) ?? false {
            return false
        }
        
        return true
    }
    func configVolume()  {
        scoketModel.sendGetVolume()
        scoketModel.getPlayVolume.asObservable().subscribe { [weak self] in
            guard let `self` = self else { return }
            print("getPalyingVolume ===：", $0.element ?? 0)
    
            let volumeValue: Int = Int($0.element ?? 0)
            let factor = CGFloat( Float(volumeValue) / 40)
            self.updateViewSliderFrame(factor: factor)

            self.currentVolume = $0.element ?? 0
            }.disposed(by: rx_disposeBag)
    }
    

    @IBAction func sliderVolumeValueChanged(_ sender: Any) {
//        lbVolume.set_text       = Int(sliderVolume.value * 100).toString
//        self.currentVolume = Int(sliderVolume.value)
        
    }
    @IBAction func clickSureAction(_ sender: Any) {
        scoketModel.setVolumeValue(value: currentVolume)
//        XBHud.showWarnMsg("修改成功")
        if let del = delegate {
            del.getVolumeNumber(volume: self.currentVolume)
        }
    }
    
    @IBAction func clickCutAction(_ sender: Any) {
        if self.currentVolume <= 0 {
            return
        }
        self.currentVolume = self.currentVolume - 1
//        sliderVolume.setValue(Float(self.currentVolume), animated: true)
    }
    
    @IBAction func clickAddAction(_ sender: Any) {
        if self.currentVolume >= 40 {
            return
        }
        self.currentVolume = self.currentVolume + 1
//        sliderVolume.setValue(Float(self.currentVolume), animated: true)
    }
    
    
    
}
