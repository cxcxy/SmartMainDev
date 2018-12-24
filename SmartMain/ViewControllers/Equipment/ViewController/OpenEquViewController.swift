//
//  OpenEquViewController.swift
//  SmartMain
//
//  Created by mac on 2018/9/25.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class OpenEquViewController: XBBaseViewController {

    @IBOutlet weak var btnScan: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setUI() {
        super.setUI()
        title = "开启设备"
        btnScan.radius_ll()
    }
    @IBAction func clickScanAction(_ sender: Any) {
            let scanVC = XBScanViewController()
            let device = AVCaptureDevice.default(for: .video)
            if device != nil {
                let status: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
                switch status {
                case .notDetermined:
                    AVCaptureDevice.requestAccess(for: .video, completionHandler: {(_ granted: Bool) -> Void in
                        if granted {
                            DispatchQueue.main.sync(execute: {() -> Void in
                                //                            topVC?.pushVC(scanVC)
                                self.pushVC(scanVC)
                            })
                            print("用户第一次同意了访问相机权限 - - \(Thread.current)")
                        } else {
                            print("用户第一次拒绝了访问相机权限 - - \(Thread.current)")
                        }
                    })
                case .authorized:
                    self.pushVC(scanVC)
                case .denied:
                    let alertC = UIAlertController(title: "温馨提示", message: "请去-> [设置 - 隐私 - 相机] 打开访问开关", preferredStyle: .alert)
                    let alertA = UIAlertAction(title: "确定", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                    })
                    alertC.addAction(alertA)
                    self.presentVC(alertC)
                case .restricted:
                    print("因为系统原因, 无法访问相册")
                    
                }
                return
            }
            let alertC = UIAlertController(title: "温馨提示", message: "未检测到您的摄像头", preferredStyle: .alert)
            let alertA = UIAlertAction(title: "确定", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            })
            alertC.addAction(alertA)
            self.presentVC(alertC)
//        }
    }
 
}
