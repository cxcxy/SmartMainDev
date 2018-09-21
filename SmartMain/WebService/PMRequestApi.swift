//
//  PMRequestApi.swift
//  XBPMDev
//
//  Created by mac on 2018/3/28.
//  Copyright © 2018年 mac-cx. All rights reserved.
//
import UIKit
import Moya
/**
 *   定义一个接口的 Api 格式
 */
enum RequestApi{

    case contentModules(req: [String: Any])
    case contentsub(req: [String: Any])
    case getLikeList(openId: String)
    case getHistoryList(openId: String)
    case getTrackList(deviceId: String)
    case getSingleTrack(id: Int)
    case getTrackSubList(req: [String: Any])
    case setTrackListDefult(trackListId: Int,deviceId: String,trackIds: [Int])
    case contentsings(req: [String: Any])
    case login(mobile: String, code: String)
    case loginWithPass(mobile: String, password: String)
    case register(req: [String: Any])
    case getAuthCode(mobile: String)
    case resetPassword(authCode: String,req: [String: Any])
    case getBabyInfo(deviceId: String)
    case updateBabyInfo(req: [String: Any])
    case familyRegister(req: [String: Any])
    case changePassword(req: [String: Any])
    case getEquimentInfo(deviceId: String)
    case modifyDeviceName(req: [String: Any])
    case modifyDeviceVolume(req: [String: Any])
    case joinEquiment(req: [String: Any])
    case joinEquimentGroup(req: [String: Any])
    case quitEquiment(openId:String,isAdmin: Bool)
    case getFamilyMemberList(deviceId: String)
    case onlineSing(openId:String, trackId: String)
    case deleteDemand(req: [String: Any])
    case saveLikeSing(req: [String: Any])
    case getSingDetail(trackId: Int)
    case addSingsToTrack(req: [String: Any])
    case copyToNewTrackList(req: [String: Any])
    case moveToNewTrackList(req: [String: Any])
    case removeSingsList(deviceId: String, listId:Int, trackIds:[String])
    case addSongToList(deviceId: String, listId:Int, listName: String, trackIds:[AddSongTrackReqModel])
    case addTrackList(req: [String: Any])
    case deleteTrackList(req: [String: Any])
    case deleteLikeSing(req: [String: Any])
    case sendVoiceDevice(req: [String: Any])
    case uploadAvatar(openId: String, body: String)
    case resetAvatar(req: [String: Any])
    case modifyNickname(req: [String: Any])
}
extension RequestApi {
    /**
     *   格式化 请求服务器的 json model 格式
     */
    fileprivate func format(m: XBDataModel? = nil) -> [String: Any]{
        let baseReq         = XBBaseReqModel.init()
        baseReq.reqdata     = m
        return baseReq.toJSON()
    }
    /**
     *   格式化 请求服务器的 json dic 字典格式
     */
    fileprivate func formatDic(dic: [String: Any]? = nil) -> [String: Any]{
        var params_task         = [String: Any]()
        params_task             = XBBaseReqModel.init().toJSON()
        params_task["reqdata"]  = dic
        return params_task
    }
    /**
     *   格式化 请求服务器的 json 字典格式
     */
    fileprivate func formatArr(dic: [Any]? = nil) -> [String: Any]{
        var params_task         = [String: Any]()
        params_task             = XBBaseReqModel.init().toJSON()
        params_task["reqdata"]  = dic
        return params_task
    }
}
extension RequestApi:TargetType{

    
    // 服务器地址
    public var baseURL:URL{
        
        return URL(string: ConfigManager.getServiceUrl())!

    }
    
    //请求任务事件（这里附带上参数）
    public var task: Task {
        var params_task = [String: Any]()
        switch self {
        case .contentModules(let req),
             .register(let req),
             .changePassword(let req),
             .familyRegister(let req),
             .joinEquiment(let req),
             .joinEquimentGroup(let req),
             .sendVoiceDevice(let req),
             .resetAvatar(let req),
             .modifyDeviceName(let req),
             .modifyDeviceVolume(let req),
             .deleteDemand(let req),
             .saveLikeSing(let req),
             .deleteLikeSing(let req),
             .addSingsToTrack(let req),
             .copyToNewTrackList(let req),
             .moveToNewTrackList(let req),
             .addTrackList(let req),
             .deleteTrackList(let req),
             .updateBabyInfo(let req):
            params_task = req
            break
        case .resetPassword(_, let req):
            params_task = req
            break
        case .getSingleTrack(let id):
            params_task["id"] = id
            return .requestParameters(parameters: params_task,
                                      encoding: URLEncoding.default)
        case .getSingDetail(let trackId):
            params_task["trackId"] = trackId
            return .requestParameters(parameters: params_task,
                                      encoding: URLEncoding.default)
        case .removeSingsList(_,_,let trackIds):
            return .requestData(trackIds.toData())
        case .addSongToList(_,_,_,let trackIds):
            let str = trackIds.toJSON()
            let str_data = try! JSONSerialization.data(withJSONObject: str, options: JSONSerialization.WritingOptions(rawValue: 0))
            return .requestData(str_data)
        case .getAuthCode,.login:
            break
        case .onlineSing(let openId,let trackId):
            params_task["openId"] = openId
            params_task["trackId"] = trackId
            break
        case .setTrackListDefult(_, _, let trackIds):
            return .requestData(trackIds.toData())
        case .quitEquiment(let openId, _):
            params_task["openId"] = openId
            break
        case .contentsub(let req):
            params_task = req
            break
        case .getLikeList(let openId):
            params_task["openId"] = openId
            return .requestParameters(parameters: params_task,
                                      encoding: URLEncoding.default)
        case .getTrackSubList(let req):
            params_task = req
            return .requestParameters(parameters: params_task,
                                      encoding: URLEncoding.default)
        case .getHistoryList(let openId):
            params_task["openId"] = openId
            return .requestParameters(parameters: params_task,
                                      encoding: URLEncoding.default)
        case .getBabyInfo(let deviceId):
            return .requestParameters(parameters: params_task,
                                      encoding: URLEncoding.default)
        case .getEquimentInfo(let deviceId),
             .getFamilyMemberList(let deviceId),
             .getTrackList(let deviceId):
            params_task["deviceId"] = deviceId
            return .requestParameters(parameters: params_task,
                                      encoding: URLEncoding.default)

        case .contentsings(let req):
            params_task = req
            break
        case .uploadAvatar( _ ,let fileURL):
             let formData = MultipartFormData(provider: .file(URL(fileURLWithPath: fileURL)),
                                              name: "file",
                                              fileName: "jihao.png",
                                              mimeType: "image/png")
             let multipartData = [formData]
             return .uploadMultipart(multipartData)
        default:
            return .requestPlain
        }
        
        return .requestParameters(parameters: params_task,
                                  encoding: JSONEncoding.default)
    }

    // 请求头信息
    public var headers: [String : String]? {
        switch self {
        case .uploadAvatar:
            return ["Content-Type": "multipart/form-data"]
        default:
            return ["Content-Type": "application/json"]
        }
    }
    // 接口请求类型
    public var method:Moya.Method{
        switch self {
        case .getLikeList,.getHistoryList,.getTrackList,.getTrackSubList,
             .getEquimentInfo,.getFamilyMemberList,.getSingleTrack,.getSingDetail,.getBabyInfo:
            return .get
        default:
            return .post
        }
    }

    //  单元测试用
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
}
extension Array {
    func toData() -> Data {
        return try! JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions(rawValue: 0))
    }
}
