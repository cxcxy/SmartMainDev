////
////  BSUploadManager.swift
////  BSMaster
////
////  Created by 陈旭 on 2017/10/25.
////  Copyright © 2017年 陈旭. All rights reserved.
////


import Foundation
typealias HeadImgURL               = (_ url:String?) -> ()

struct BSUploadManager {
    static let share = BSUploadManager()
    static let url  = ConfigManager.getServiceUrl() + "/familymember/avatar/upload.do?openId=15981870363"
    
    
    // 针对时间戳
    static func onlyStr() -> String  {
        //          拼接唯一字符串
        let onlyStr         =  String.init(format: "%.0f",(Date().timeIntervalSince1970 * 1000))
        
        return onlyStr
    }
    
    //上传图片到服务器
    func uploadImage(image : UIImage,imageName:String,successClosure:@escaping HeadImgURL,failClosure:@escaping FailClosure){
        
        guard let jpegData = UIImageJPEGRepresentation(image.fixOrientation(), 0.5) else {
            return
        }
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                //采用post表单上传
                // 参数解释：
                //withName:和后台服务器的name要一致 fileName:自己随便写，但是图片格式要写对 mimeType：规定的，要上传其他格式可以自行百度查一下
                multipartFormData.append(jpegData, withName: "img", fileName: imageName, mimeType: "image/jpeg")
                //如果需要上传多个文件,就多添加几个
                //multipartFormData.append(imageData, withName: "file", fileName: "123456.jpg", mimeType: "image/jpeg")
                //......
                
        },to: BSUploadManager.url,encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                //连接服务器成功后，对json的处理
                upload.responseJSON { response in
                    //解包
                    guard let result = response.result.value else { return }
                    print("\(result)")
                    //须导入 swiftyJSON 第三方框架，否则报错
                    let success = JSON(result)["code"].int ?? -1
                    
                    if success == 200 {
                        print(JSON(result)["file"])
                        if let str = JSON(result)["file"].array![0].string {
                            successClosure(str)
                        }
                        
                    }else{
                        failClosure("上传失败")
                    }
                }
            case .failure(let encodingError):
                //打印连接失败原因
                print("上传失败")
                print(encodingError)
                failClosure("上传失败")
                //
            }
        })
    }
}
