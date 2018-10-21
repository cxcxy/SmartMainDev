//
//  PMApiPath.swift
//  XBPMDev
//
//  Created by mac on 2018/3/28.
//  Copyright © 2018年 mac-cx. All rights reserved.
//
import Foundation
/****************************API_URL接口**********************************/
extension RequestApi {
    // api 地址
    public var path:String{
        switch self {
        // 内容主页面接口
        case .contentModules:           return "/resource/appInterface.do?inter=/cms/modules"
            // 第二级
        case .contentsub:               return "/resource/appInterface.do?inter=/cms/categories"
            // 第三级
        case .contentsings:             return "/resource/appInterface.do?inter=/resources/list"
        // 根据用户ID获取收藏列表
        case .getLikeList:              return "/favorite/getlist.do"
        case .getHistoryList:           return "/suportAPP/demand/getlist.do"
           //获取预制列表信息
        case .getTrackList:             return "/tracklist/getlistview.do"
        //获取预制列表信息
        case .getTrackSubList:          return "/track/getpage.do"
        case .setTrackListDefult(let trackListId, let deviceId, _): return "/tracklist/inital.do?trackListId=\(trackListId)&deviceId=\(deviceId)"
        case .getSearchResource:   return "/resource/appInterface.do?inter=/search"
        //获取指定预制列表信息
        case .getSingleTrack:          return "/track/get.do"
            // 登录接口
        case .login(let mobile,let code):                    return "/suportAPP/loginWithAuthCode.do?username=\(mobile)&authCode=\(code)"
        case .getDeviceIds: return "/suportAPP/getDeviceIds.do"
        case .loginWithPass(let mobile,let password):                    return "/suportAPP/loginWithPassword.do?username=\(mobile)&password=\(password)"
        case .register:                 return "/suportAPP/registUser.do"
        case .getAuthCode(let mobile):  return "/suportAPP/getAuthCode.do?mobile=" + mobile
        case .resetPassword(let authCode,_): return "/suportAPP/resetPassword.do?authCode=\(authCode)"
        // 获取用户信息
        case .getUserInfo:           return "/suportAPP/getUserInfo.do"
        // 修改用户信息
        case .updateUserInfo:           return "/suportAPP/familymember/avatar/reset.do"
            // 获取设备信息
        case .getBabyInfo(let deviceId):           return "/suportAPP/getBabyInfo.do?deviceid=\(deviceId)"
        case .updateBabyInfo:           return "/suportAPP/updateBabyInfo.do"
        case .familyRegister:           return "/familymember/register.do"
        // 获取设备信息
        case .getEquimentInfo:          return "/boxinfo/get.do"
        // 获取设备改名
        case .modifyDeviceName:          return "/boxinfo/rename.do"
        // 修改音量
        case .modifyDeviceVolume:          return "/boxinfo/setvolume.do"
            // 加入设备第一步
        case .joinEquiment:             return "/familymember/join.do"
            // 加入设备第二步
        case .joinEquimentGroup:        return "/suportAPP/joinEaseGroup.do"
            // 接触设备绑定onlineSing
        case .quitEquiment(_ , let isAdmin):        return "/familymember/quit.do?byAdmin=\(isAdmin)"
            
        //根据设备号获取群组成员列表
        case .getFamilyMemberList:      return "/suportAPP/familymember/getlist.do"
        //在线点播
        case .onlineSing:               return "/suportAPP/demand/online/save.do"
        // 删除点播
        case .deleteDemand:          return "/demand/delete.do"
        // 保存收藏
        case .saveLikeSing:          return "/favorite/save.do"
        // 删除收藏
        case .deleteLikeSing:          return "/favorite/delete.do"
        // 获取歌曲详情
        case .getSingDetail:          return "/track/getid.do"
        // 添加多首歌曲到预制列表
        case .addSingsToTrack:          return "/resource/tracklist/addTrackBatch.do"
        // 把歌曲从旧列表拷贝到新列表
        case .copyToNewTrackList:          return "/track/copy.do"
        // 把歌曲从旧列表移动到新列表
        case .moveToNewTrackList:          return "/track/move.do"
        // 把歌曲从列表中删除
        case .removeSingsList(let deviceId, let listId, _):          return "/track/remove.do?deviceId=\(deviceId)&id=\(listId)"
        // 新增一首歌曲到指定的预制列表
        case .addSongToList(let deviceId,let listId,let listName, _):          return "/track/download.do?deviceId=\(deviceId)&id=\(listId)&name=\(listName.urlEncoded())"
        // 新增一个列表
        case .addTrackList:          return "/tracklist/add.do"
        // 删除一个列表
        case .deleteTrackList:          return "/tracklist/remove.do"
        // app向设备发送文字接口(post)
        case .sendTextDevice:               return "/suportAPP/appSendTextToDevice.do"
        // app向设备发送语音接口
        case .sendVoiceDevice:               return "/suportAPP/appSendVoiceToDevice.do"
        // 上传头像文件到服务器
        case .uploadAvatar(let openId, _):               return "/familymember/avatar/upload.do?openId=" + openId
        // 设置或重设用户账号头像
        case .resetAvatar:               return "/familymember/avatar/reset.do"
        // 修改账号昵称
        case .modifyNickname:               return "/familymember/modifynickname.do"
        // 获取声波配网 语音
        case .getNetVoice:                  return "/sinvoice/set.do"
        // 群组成员操作
        case .quitGroup(let byAdmin, _):                  return "/suportAPP/familymember/quit.do?byAdmin=\(byAdmin)"
            // 获取app 最新信息
        case .getAppVersion: return "/suportAPP/getNewVersion.do"
// 获取资源全部分类
        case .getResourceAll: return "/turingGetResource.do?inter=open/category/list"
            // 获取专辑排行列表
        case .getResourceListTop: return "/turingPostResource.do?inter=open/album/top"
        // 获取专辑列表
        case .getResourceAlbumList: return "/turingPostResource.do?inter=open/album/list"
        // 获取音频列表
        case .getAudioListTop: return "/turingPostResource.do?inter=open/audio/list"
            // 获取首页顶部banner
        case .getResourceBanner: return "/suportAPP/getBanner.do"
        // 搜索资源歌曲
        case .searchResource: return "/turingPostResource.do?inter=open/audio/list"
            // 搜索资源专辑
        case .searchResourceAlbum: return "/turingPostResource.do?inter=open/album/list"
        default:
            return ""
        }
    }
}

private let arrayParametersKey = "arrayParametersKey"

/// Extenstion that allows an array be sent as a request parameters
extension Array {
    /// Convert the receiver array to a `Parameters` object.
    func asParameters() -> Parameters {
        return [arrayParametersKey: self]
    }
}


/// Convert the parameters into a json array, and it is added as the request body.
/// The array must be sent as parameters using its `asParameters` method.
public struct ArrayEncoding: ParameterEncoding {
    
    /// The options for writing the parameters as JSON data.
    public let options: JSONSerialization.WritingOptions
    
    
    /// Creates a new instance of the encoding using the given options
    ///
    /// - parameter options: The options used to encode the json. Default is `[]`
    ///
    /// - returns: The new instance
    public init(options: JSONSerialization.WritingOptions = []) {
        self.options = options
    }
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        
        guard let parameters = parameters,
            let array = parameters[arrayParametersKey] else {
                return urlRequest
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: array, options: options)
            
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
//                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            urlRequest.httpBody = data
            
        } catch {
            throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }
        
        return urlRequest
    }
}
