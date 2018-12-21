//
//  DrawFromCell.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/20.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
protocol DrawFromCellDelegate: class {
    func switchValueChangeAction(modelData: XBStyleCellModel,isSwitch: Bool)
}
class DrawFromCell: BaseTableViewCell {
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lbDes: UILabel!
    weak var delegate: DrawFromCellDelegate?
    @IBOutlet weak var isSwitch: UISwitch!
    @IBOutlet weak var lbContent: UILabel!
    let scoketModel = ScoketMQTTManager.share
    var deviceOnline:Bool = false
    var modelData: XBStyleCellModel!  {
        didSet {
            self.lbDes.set_text = modelData.title
            self.imgIcon.set_img = modelData.imgIcon
            if let isSwitchOpen = modelData.isSwitchOpen {
                self.isSwitch.isHidden = false
                self.isSwitch.isOn = isSwitchOpen
            }else {
                self.isSwitch.isHidden = true
            }
            if modelData.content == "" {
                self.lbContent.isHidden = true
            }else {
                self.lbContent.isHidden = false
                self.lbContent.set_text = modelData.content
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func switchValueChange(_ sender: UISwitch) {
        if let del = self.delegate {
            print(sender.isOn)
            del.switchValueChangeAction(modelData: modelData, isSwitch: sender.isOn)
        }
    }
    func updateLockAction(isLock: Bool) {
        guard self.deviceOnline else {
            XBHud.showMsg("当前设备不在线")
            return
        }
        
        if isLock { // 打开
            scoketModel.sendCortolLock(0)
//            self.imgLock.set_img =  "icon_groupLaght"
//            self.lbLock.set_text = "打开童锁"
        }else { // 关闭
            scoketModel.sendCortolLock(1)
//            self.imgLock.set_img =  "icon_groupLaght_on"
//            self.lbLock.set_text = "关闭童锁"
        }
//        btnLock.isSelected = !btnLock.isSelected
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
