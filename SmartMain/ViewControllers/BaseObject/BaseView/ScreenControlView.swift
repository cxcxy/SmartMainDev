//
//  ScreenControlView.swift
//  SmartMain
//
//  Created by mac on 2018/9/25.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
class SleepModel: NSObject {
    var title:String    = ""
    var value:Int       = 0

    init(title:String,
         value:Int) {
        self.title = title
        self.value = value
       
    }
}
class ScreenControlView: ETPopupView, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var heightLayout: NSLayoutConstraint!
    @IBOutlet weak var widthLayout: NSLayoutConstraint!
    @IBOutlet weak var lbSelector: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var btnSure: UIButton!
    var dataArr: [SleepModel] = []
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
        viewContainer.setCornerRadius(radius: 8)
        btnSure.radius_ll()
        if UIDevice.deviceType == .dt_iPhone5 {
            widthLayout.constant = 180
            heightLayout.constant = 289
        }
//        let toolbar = UIToolbar.init(frame: self.frame)
//        toolbar.barStyle = UIBarStyle.blackTranslucent
//        toolbar.alpha = 0.8
//        self.addSubview(toolbar)
        configPickerView()
    }
    func configPickerView()  {
        let model1 = SleepModel.init(title: "取消定时", value: 0)
        let model2 = SleepModel.init(title: "立刻关机", value: -1)
        let model3 = SleepModel.init(title: "10分钟", value: 10)
        let model4 = SleepModel.init(title: "20分钟", value: 20)
        let model5 = SleepModel.init(title: "30分钟", value: 30)
        let model6 = SleepModel.init(title: "40分钟", value: 40)
        dataArr = [model1,model2,model3,model4,model5,model6]
        //将dataSource设置成自己
        pickerView.dataSource = self
        //将delegate设置成自己
        pickerView.delegate = self
        //设置选择框的默认值
        let defaultIndex = 1
        pickerView.selectRow(defaultIndex,inComponent:0,animated:true)
        lbSelector.set_text = dataArr[defaultIndex].title
    
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //设置选择框的行数为9行，继承于UIPickerViewDataSource协议
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return dataArr.count
    }
    //设置选择框各选项的内容，继承于UIPickerViewDelegate协议
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return dataArr[row].title
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(dataArr[row])
        lbSelector.set_text = dataArr[row].title
    }
//    setPowerOff
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
    @IBAction func clickSureAction(_ sender: Any) {
        let selectRow = pickerView.selectedRow(inComponent: 0)
        let model = dataArr[selectRow].value
        scoketModel.setPowerOff(value: model)
    }
    
}
