////
////  UIViewControllerRouter.swift
////  BSMaster
////
////  Created by 陈旭 on 2017/10/9.
////  Copyright © 2017年 陈旭. All rights reserved.
////
//
//typealias XBClickSureAction         = () -> ()
////MARK:  统一路由页面的管理
class VCRouter {
    /**
     *  获取栈顶部 导航条
     */
    class var topNaVC : UINavigationController? {
        
        get {
            let topViewController = XBUtil.currentTopViewController()
            let navigation = topViewController.navigationController
            return navigation
        }
    }
    /**
     *  获取栈顶部 导航条控制器
     */
     class var topVC : UIViewController? {

        get {
            let topViewController = XBUtil.currentTopViewController()
            return topViewController
        }
    }
    class func toPlayVC()  {
//        DeviceManager.isOnline { (isOnline, _)  in
//            if isOnline {
                let vc = SmartPlayerViewController()
                topVC?.pushVC(vc)
//            } else {
//    
//                XBHud.showMsg("当前设备不在线")
//            }
//        }

    }
    // MARK: - 跳转设备设置
    class func toEquipmentSettingVC() {
        
        let vc = EquipmentSettingVC()
        topVC?.pushVC(vc)
        
    }
    // MARK: - 跳转设备信息
    class func toEquipmentInfoVC(equimentModel: EquipmentInfoModel!) {
        
        let vc = EquimentInfoVC()
        vc.equimentModel = equimentModel
        topVC?.pushVC(vc)
        
    }
    // MARK: - 跳转第二级页面
    class func toContentSubVC(clientId: String!, albumId:String? = nil,modouleId:String? = nil, navTitle: String?, listType: ContentSubType = .none) {
        
//        let vc = ContentSubVC()
        let vc = ContentSubNewController()
        vc.clientId = clientId
        vc.albumId = albumId
        vc.modouleId = modouleId
        vc.title = navTitle
        topVC?.pushVC(vc)
        
    }
//    // MARK: - 跳转第二级页面 新
//    class func toContentNewSubVC(clientId: String!, albumId:String? = nil,modouleId:String? = nil, navTitle: String?, listType: ContentSubType = .none) {
//
//        let vc = ContentSubVC()
//        vc.clientId = clientId
//        vc.albumId = albumId
//        vc.modouleId = modouleId
//        vc.title = navTitle
//        topVC?.pushVC(vc)
//
//    }
    class func toContentSubVCFromSearch(searchKey: String!, listType: ContentSubType = .search) {
        
        let vc = ContentSubVC()
        vc.listType = listType
        vc.searchKey = searchKey
        vc.title = "更多专辑"
        topVC?.pushVC(vc)
        
    }
    // MARK: - 跳转第三级歌单页面
    class func toContentSingsVC(clientId: String!, albumId:String!) {
        
        let vc = ContentSingsVC()
        vc.clientId = clientId
        vc.albumId = albumId
        topVC?.pushVC(vc)
        
    }
    
    // MARK: - 跳转图灵 专辑列表 相当于第二级歌单页面,从全部资源点击进去
    class func toAlbumListVC(albumId:Int!,albumName: String) {
        
        let vc = ResourceAlbumVC()
        vc.albumId = albumId
        vc.albumName = albumName
        vc.resouceType = .resource
        topVC?.pushVC(vc)
        
    }
    // MARK: - 跳转图灵 专辑列表 相当于第二级歌单页面,从最新最热更多点击进去
    class func toTopAlbumListVC(resourceType:String!,albumName: String) {
        
        let vc = ResourceAlbumVC()
        vc.topType = resourceType
        vc.resouceType = .topmore
        vc.albumName = albumName
        topVC?.pushVC(vc)
        
    }
    // MARK: - 跳转图灵 音频列表 相当于第三级歌单页面
    class func toAudioListVC(albumId:String!,topDes: String?, topTotal: String?, topImg:String?) {
        let vc = ResourceAudioListVC()
        vc.albumId = albumId
        vc.topDes = topDes
        vc.topTotal = topTotal
        vc.topImg = topImg
        topVC?.pushVC(vc)
        
    }

    // MARK: - 跳转预制歌单列表界面
    class func toEquipmentSubListVC(trackListId: Int!, navTitle: String?, trackList: [EquipmentModel]) {
        
        let vc = EquipmentSubListVC()
        vc.trackListId = trackListId
        vc.trackList = trackList
        vc.title = navTitle
        topVC?.pushVC(vc)
        
    }
    
    //
    // MARK: - 弹出选择器视图
    class func prentShareView(imgCode: UIImage,shareUrl: String) {



    }
    // MARK: - 跳转WebView
    class func toWebView(webUrl: String) {
        
        let vc = XBWebViewController()
        vc.url = webUrl
        topVC?.pushVC(vc)
        
    }
    class func prentAlertAction(message: String,closure: @escaping () -> ())  {
        
        let alertController = UIAlertController(title: "温馨提示",
                                                message: message, preferredStyle: .alert)
 
        let alertSure = UIAlertAction(title: "确定", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            closure()
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(alertSure)
        topVC?.present(alertController, animated: true, completion: nil)
    }
    class func prentSheetAction(dataArr: [String],closure: @escaping (Int) -> ())  {
    
        let alertController = UIAlertController(title: nil,
                                            message: nil, preferredStyle: .actionSheet)
    
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        for item in dataArr.enumerated() {
            let itemAction = UIAlertAction(title: item.element, style: .default, handler: {
                action in
                closure(item.offset)
            })
            alertController.addAction(itemAction)
        }
        topVC?.present(alertController, animated: true, completion: nil)
    }

//
}
import AVFoundation
extension VCRouter {
    

    class func qrCodeScanVC(entarnceType: XBScanEntrance = .main) {
        
        let scanVC = XBScanViewController()
        scanVC.entarnceType = entarnceType
        let device = AVCaptureDevice.default(for: .video)
        if device != nil {
            let status: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
            switch status {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video, completionHandler: {(_ granted: Bool) -> Void in
                    if granted {
                        DispatchQueue.main.sync(execute: {() -> Void in
                            topVC?.pushVC(scanVC)
                        })
                        print("用户第一次同意了访问相机权限 - - \(Thread.current)")
                    } else {
                        print("用户第一次拒绝了访问相机权限 - - \(Thread.current)")
                    }
                })
            case .authorized:
                    topVC?.pushVC(scanVC)
            case .denied:
                
                let alertC = UIAlertController(title: "温馨提示", message: "请去-> [设置 - 隐私 - 相机] 打开访问开关", preferredStyle: .alert)
                let alertA = UIAlertAction(title: "确定", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                })
                alertC.addAction(alertA)
                topVC?.presentVC(alertC)
                
            case .restricted:
                print("因为系统原因, 无法访问相册")

            }
            return
        }
        let alertC = UIAlertController(title: "温馨提示", message: "未检测到您的摄像头", preferredStyle: .alert)
        let alertA = UIAlertAction(title: "确定", style: .default, handler: {(_ action: UIAlertAction) -> Void in
        })
        alertC.addAction(alertA)
        topVC?.presentVC(alertC)
    }
}
extension UINavigationController {
    /**
     *   push --- 淡入淡出动画
     */
    func pushFadeAnimation(viewController: UIViewController) {
        let transition = CATransition.init()
        transition.type = kCATransitionFade
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        view.layer.add(transition, forKey: nil)
        pushViewController(viewController, animated: false)
    }
    
    func popFadeAnimation() {
        let transition = CATransition.init()
        transition.type = kCATransitionFade
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        view.layer.add(transition, forKey: nil)
        popViewController(animated: false)
    }
}
