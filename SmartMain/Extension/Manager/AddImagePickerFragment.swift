////
////  AddImagePickerFragment.swift
////  XBShinkansen
////
////  Created by mac on 2017/11/6.
////  Copyright © 2017年 mac. All rights reserved.
////
//
//import UIKit
//protocol XBImagePickerToolDelegate:class {
//    func getImagePicker(image:UIImage)
//}
//
//class XBAddImagePickerFragment: NSObject,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
//    weak var delegate :XBImagePickerToolDelegate?
//    open weak var current_vc:UIViewController!
//    
//    class func getPicker(maxImagesCount:Int = 5) -> TZImagePickerController {
//        
//        let imagePickerVc = TZImagePickerController.init(maxImagesCount: maxImagesCount,
//                                                         columnNumber: 4,
//                                                         delegate: self as? TZImagePickerControllerDelegate,
//                                                         pushPhotoPickerVc: true)
//        
//        imagePickerVc?.isSelectOriginalPhoto            = false
//        imagePickerVc?.barItemTextColor                 = UIColor.black
//        imagePickerVc?.naviTitleColor                   = UIColor.black
//        imagePickerVc?.navigationBar.barTintColor       = UIColor.white
//        imagePickerVc?.navigationBar.tintColor          = UIColor.black
//        imagePickerVc?.navigationController?.navigationBar.isTranslucent = false
//        
//        //        imagePickerVc?.automaticallyAdjustsScrollViewInsets = true
//        
//        imagePickerVc?.allowTakePicture                     = true  // 拍照按钮将隐藏,用户将不能在选择器中拍照 ！！！
//        imagePickerVc?.allowPickingVideo                    = false // 用户将不能选择发送视频
//        imagePickerVc?.allowPickingImage                    = true  // 用户可以选择发送图片  ！！！
//        imagePickerVc?.allowPickingOriginalPhoto            = false // 用户是否选择发送原图
//        imagePickerVc?.sortAscendingByModificationDate      = false // 是否按照时间排序
//        imagePickerVc?.autoDismiss                          = true  // 不自动dismiss
//        imagePickerVc?.allowPreview                         = true  // 不预览图片 ！！！！
////        imagePickerVc?.showSelectBtn                        = true  // 展示完成按钮
//        
//        return imagePickerVc!
//    }
//    
//    //MARK:Lazy
//    lazy var imagePicker:UIImagePickerController = {
//        let v = UIImagePickerController()
//        v.delegate = self
//
//        v.allowsEditing     = true
//        return v
//    }()
//    var chooseImgtype:XBGetUploadTokenType = .userPhoto {
//        didSet {
//            self.imagePicker.allowsEditing = (chooseImgtype == .userPhoto ? true:false)
//        }
//    }
//    func show(_ vc:UIViewController)  {
//        self.current_vc = vc
//        let alertController = UIAlertController(title: nil,
//                                                message: nil, preferredStyle: .actionSheet)
//
//        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
//        let cameraAction = UIAlertAction(title: "相机拍照", style: .default, handler: {
//            action in
//            self.choosePhtot(.camera)
//        })
//        let photoAction = UIAlertAction(title: "相册选取", style: .default, handler: {
//            action in
//            self.choosePhtot(.photoLibrary)
//        })
//        alertController.addAction(cancelAction)
//        alertController.addAction(cameraAction)
//        alertController.addAction(photoAction)
//        self.current_vc.present(alertController, animated: true, completion: nil)
//        
//    }
//    /**
//     *   相机选取
//     */
//    func showCamera(_ vc:UIViewController)  {
//        self.current_vc = vc
//        self.choosePhtot(.camera)
//        
//    }
//    /**
//     *   相册选取
//     */
//    func showPhotoLibrary(_ vc:UIViewController)  {
//        self.current_vc = vc
//        self.choosePhtot(.photoLibrary)
//        
//    }
//    func choosePhtot(_ type:UIImagePickerControllerSourceType){
//        if UIImagePickerController.isSourceTypeAvailable(type){
//            //指定图片控制器类型
//            imagePicker.sourceType = type
//            //弹出控制器，显示界面
//            self.current_vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//            self.current_vc.present(imagePicker, animated: true, completion:nil)
//        }else{
//            
//        }
//    }
////    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
////
////
////
////    }
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        let choseImage = info[imagePicker.allowsEditing ?UIImagePickerControllerEditedImage:UIImagePickerControllerOriginalImage] as! UIImage
//
//        if let del = delegate {
//            del.getImagePicker(image: choseImage)
//        }
//        picker.dismiss(animated: true, completion: nil)
//    }
////    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
////
////    }
////    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
////
////    }
//}
