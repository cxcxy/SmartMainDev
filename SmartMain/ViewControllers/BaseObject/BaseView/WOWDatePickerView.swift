//
//  WOWPickerView.swift
//  wowapp
//
//  Created by 小黑 on 16/6/1.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
import SnapKit

// 返回所选中行的str 以及下标
typealias SelectRowBlock =  (_ str:String, _ index: Int) -> ()

class WOWDatePickerView: ETPopupView {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var pickerView: UIDatePicker!
    @IBOutlet weak var sureButton: UIButton!
    var selectBlock :SelectRowBlock?


    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        type = .sheet
        ETPopupWindow.sharedWindow().touchWildToHide = true
        animationDuration = 0.2
        self.snp.makeConstraints { (make) in
            make.width.equalTo(MGScreenWidth)
            make.height.equalTo(250)
        }
        pickerView.maximumDate = Date.init()
    }
    

    
    func showPickerView(dateStr: String?) {
        if let str = dateStr {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let date: Date = (formatter.date(from: str)) ?? Date.init()
            pickerView.date = date
        }
        show()
    }
    @IBAction func sureAction (_ sender: UIButton) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let str = formatter.string(from: pickerView.date)
        if let block = selectBlock {
            
            block(str,0)
            
        }
        hide()
    }
    
    @IBAction func cancelAction (_ sender: UIButton) {
        hide()
    }
    
}
