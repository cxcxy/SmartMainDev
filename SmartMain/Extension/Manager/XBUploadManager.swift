////
////  BSUploadManager.swift
////  BSMaster
////
////  Created by 陈旭 on 2017/10/25.
////  Copyright © 2017年 陈旭. All rights reserved.
////
//
//import Foundation
//import FCUUID
//import ObjectMapper
//
//class imageInfo: NSObject {
//    var image       : UIImage! // image对象
//    var imageName   : String! // image名称，保证路径唯一
//}
//
//class FileInfo: NSObject,Mappable {
//    var fk                              : String?
//    var fn                              : String?
//    var fs                              : String?
//    var ft                              : String?
//    var url                             : String?
//    var downurl                         : String?
//    var filePath                        : String?
//    var sourceData                      : Data?
//    override init() {
//        super.init()
//    }
//    required init?(map: Map) {
//    }
//    
//    func mapping(map: Map) {
//        fk                          <- map["fk"]
//        fn                          <- map["fn"]
//        fs                          <- map["fs"]
//        ft                          <- map["ft"]
//        url                         <- map["url"]
//        downurl                     <- map["downurl"]
//        filePath                    <- map["filePath"]
//    }
//}
//
//typealias UploadFileInfo                    = (_ url:FileInfo?) -> ()
//typealias UploadFileInfoError               = (_ error:String?) -> ()
//typealias PushImgURLs              = (_ result:[FileInfo]) ->()
//class XBUploadModel:XBBaseModel {
//    var type  : String?   //   1 获取附件token， 2 获取用户头像token
//    var image : UIImage?
//    var audio_url : String?
//}
//
//enum XBGetUploadTokenType:String {
//    case userPhoto  = "2"   // 获取用户头像Token
//    case attachment = "1"   // 获取附件Token
//}
//enum XBUploadFileType:String {
//    case fileImage  = ".jpg"   //
//    case fileAudio  = ".wav"   //
//}
//struct XBUploadManager {
//    static let globalQueue  = DispatchQueue.global()
//    static let group        = DispatchGroup()
//    static let share = XBUploadManager()
//
//    // 获取时间戳
//    static func getTimeSince() -> String  {
//
//        let timeStr         = Date.init().toString(format: "yyyyMMddHHmmss")
//        
//        return timeStr
//        
//    }
//    // 获取唯一标示
//    static func getOnlyStr() -> String  {
//        
//        let onlyStr         = FCUUID.uuidForDevice()  + getTimeSince()
//        return onlyStr
//        
//    }
//    /**
//     *   上传图片方法，默认为上传头像
//     */
//   static func uploadPhotoImage(image : UIImage,
//                           tokenType:XBGetUploadTokenType = .userPhoto,
//                           successClosure:@escaping UploadFileInfo) {
//    
//    
//        pushImage(image: image,
//                  imageName: "",
//                  fileType: tokenType,
//                  successClosure: successClosure)
//
//    }
//    /// 多张图片上传，使用GCD 分组 操作控制异步上传
//    static func uploadImages(images: [imageInfo],
//                             tokenType:XBGetUploadTokenType = .attachment,
//                             successClosure:@escaping PushImgURLs){
//        var urlArray = [FileInfo]()
//        XBHud.showLoading()
//        for image in images.enumerated(){
//            group.enter()// 标记
//            
//            DispatchQueue.global().async(group: group) {
//
//                pushImage(image: image.element.image,
//                          imageName: image.element.imageName,
//                          fileType: tokenType,
//                          successClosure: { (info) in
//                    urlArray.append(info!)
//                    group.leave()// 完成
//                })
//            }
//        }
//        // 统一回调通知完成
//        group.notify(queue: globalQueue) {
//            XBHud.dismiss()
//            successClosure(urlArray)
//        }
//    }
//    
//    /**
//     *   上传文件，上传七牛唯一Key 使用uuid + filetype + imageName
//     */
//    static func pushImage(image : UIImage,
//                          imageName:String!,
//                          fileType:XBGetUploadTokenType = .userPhoto,
//                          successClosure:@escaping UploadFileInfo) {
//        
//        
//        let image = image.fixOrientation()
//        guard let fileData = UIImageJPEGRepresentation(image, 0.2) else {
//            return
//        }
////        先从服务器拿到 上传七牛 的 Token
//        XBNetManager.shared.requestWithTarget(.api_getuploadtoken(req: ["type": fileType.rawValue]),isShowLoding: false,isDissmissLoding: false,
//                                              successClosure: { (result, code, message) in
//        
//            if let dic = result as? Dictionary<String, String>{
//                let uploadOption            = QNUploadOption.init(
//                    mime: nil,
//                    progressHandler: { ( key, percent_f) in
//                        
//                },
//                    params: nil  ,
//                    checkCrc: false,
//                    cancellationSignal: nil
//                )
//                
//                let upToken     = dic["uptoken"]
//                let length      = fileData.count/1000
//                let upInfo      = FileInfo.init()
//                upInfo.fn       = getTimeSince() + fileType.rawValue
//                upInfo.ft           = "Image"
//                upInfo.fs           = length.toString
//        
//                let only_key        = getOnlyStr() + fileType.rawValue + imageName
//                if let qm          = QNUploadManager(){
//                    qm.put(fileData, key: only_key, token: upToken, complete: { (info, key, resp) in
//                        if (info?.isOK ?? false),  let resp = resp{
//                            if let key = resp["key"] as? String {
//                                upInfo.fk = key
//                                successClosure(upInfo)
//                            }
//                        }else{
//                            XBHud.showWarnMsg("上传失败")
//                        }
//                    }, option: uploadOption)
//                }else {
//                    XBHud.showWarnMsg("上传失败")
//                }
//            }
//        
//        })
//    }
//}
