//
//  ScreenControlView.swift
//  SmartMain
//
//  Created by mac on 2018/9/25.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class ScreenControlView: ETPopupView, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    var dataArr: [String] = ["取消定时","立刻关机","10分钟","20分钟","30分钟","40分钟"]
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
        configPickerView()
    }
    func configPickerView()  {
        //将dataSource设置成自己
        pickerView.dataSource = self
        //将delegate设置成自己
        pickerView.delegate = self
        //设置选择框的默认值
        pickerView.selectRow(1,inComponent:0,animated:true)
    
    }
//    //设置选择框的列数为3列,继承于UIPickerViewDataSource协议
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //设置选择框的行数为9行，继承于UIPickerViewDataSource协议
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return dataArr.count
    }
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int,
//                    forComponent component: Int, reusing view: UIView?) -> UIView {
//        var pickerLabel = view as? UILabel
//        if pickerLabel == nil {
//            pickerLabel = UILabel()
//            pickerLabel?.font = UIFont.systemFont(ofSize: 13)
//            pickerLabel?.textAlignment = .center
//        }
//        pickerLabel?.text = String(row)+"-"+String(component)
//        pickerLabel?.textColor = UIColor.blue
//        return pickerLabel!
//    }
    //设置选择框各选项的内容，继承于UIPickerViewDelegate协议
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return dataArr[row]
    }
    
    //触摸按钮时，获得被选中的索引
    @objc func getPickerViewValue(){
//        let message = String(pickerView.selectedRow(inComponent: 0)) + "-"
//            + String(pickerView!.selectedRow(inComponent: 1)) + "-"
//            + String(pickerView.selectedRow(inComponent: 2))
//        let alertController = UIAlertController(title: "被选中的索引为",
//                                                message: message, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//        alertController.addAction(okAction)
//        self.present(alertController, animated: true, completion: nil)
    }
}
