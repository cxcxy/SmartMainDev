//
//  ScoketMQTTManager.swift
//  SmartMain
//
//  Created by mac on 2018/9/12.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
let socket_host             = "zb.mqtt.athenamuses.cn" // 线下地址
let socket_port: UInt16     = 1893
//let socket_host             = "zhiban.mqtt.athenamuses.cn" // 线上地址
//let socket_port: UInt16     = 8094

//let socket_clientID         = "3010290000045007_1275"
//let socket_clientID         = "3010290000047373_50056"
class ScoketMQTTManager: NSObject, MQTTSessionDelegate {
    var mqttSession: MQTTSession!
    /**
     *   播放状态
     */
    let playStatus = PublishSubject<Bool>()
    /**
     *   true全部循环，false单曲循环 
     */
    let repeatStatus = PublishSubject<Bool>()
    /**
     *   监听 当前正在播放的歌曲Id 变化
     */
    let getPalyingSingsId = PublishSubject<Int>()
    
    var playingSongId: Int?
    /**
     *   回复默认预制列表 数据
     */
    let getSetDefaultMessage = PublishSubject<String>()
    
    /**
     *   获取音量大小 数据
     */
    let getPlayVolume = PublishSubject<Int>()
    /**
     *   获取当前播放进度
     */
    let getPlayProgress = PublishSubject<Int>()
    /**
     *   获取设备版本号
     */
    let getDeviceVersion = PublishSubject<String>()
    /**
     *   1 开 0 为 关
     */
    let getLock = PublishSubject<Int>()
    
    /**
     *   1 开 0 为 关
     */
    let getLight = PublishSubject<Int>()
    
    /**
     *   获取休眠时间
     */
    let getPoweroff = PublishSubject<Int>()
    
    var current_socket_clientID         = ""
    
    static let share = ScoketMQTTManager()
    override init() {
        super.init()
        let now = Date()
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval).toString
        mqttSession = MQTTSession(host: socket_host,
                                  port: socket_port,
                                  clientID: timeStamp,
                                  cleanSession: true,
                                  keepAlive: 15,
                                  useSSL: false)
        mqttSession.delegate = self
        mqttSession.connect { (error) in
            if  error == .none {
                print("Connected.")
                self.current_socket_clientID = XBUserManager.device_Id
                self.subscribeToChannel(socket_clientId: XBUserManager.device_Id)
            } else {
                print("Connected error.")
            }
        }
    }
    /**
     *   订阅机器信息
     */
    func subscribeToChannel(socket_clientId: String) {
        if socket_clientId == "" && self.current_socket_clientID != ""{ // 当为空时，取消订阅之前的
            self.unSubscribeToChannel(socket_clientId: self.current_socket_clientID)
            return
        }
        if self.current_socket_clientID != socket_clientId { // 当发现订阅的 clientID与新的clientID不同时，则取消订阅之前的，重新订阅最新的
            self.unSubscribeToChannel(socket_clientId: self.current_socket_clientID)
            self.current_socket_clientID = socket_clientId // 重新赋值 给当前的 currentId
        }
        let channel = "storybox/\(socket_clientId)/client"
        self.mqttSession.subscribe(to: channel, delivering: .atLeastOnce) { (error) in
            if error == .none {
                print("订阅机器信息成功 ，Subscribed to \(channel)")
            } else {
                    
            }
        }

    }
    /**
     *   取消订阅机器信息
     */
    func unSubscribeToChannel(socket_clientId: String) {
        if socket_clientId == "" {
            return
        }

        let channel = "storybox/\(socket_clientId)/client"
        self.mqttSession.unSubscribe(from: channel) { (error) in
            if error == .none {
                    print("取消订阅机器信息 ，Subscribed to \(channel)")
            } else {
                    
            }
        }
        
    }
    /**
     *   向机器发出订阅信息
     */
    func sendPressed(socketModel: XBSocketModel)  {
        let channel = "storybox/\(XBUserManager.device_Id)/server/page"
        
        guard let message = socketModel.toJSONString() else {
            return
        }
        guard  let data = message.data(using: .utf8) else {
            return
        }
        mqttSession.publish(data, in: channel, delivering: .atMostOnce, retain: false) { (error) in
            if error == .none {
                print("向订阅机器发送 Published \(message) on channel \(channel)")
            }
        }
    }
    /**
     *   向机器发出订阅信息New
     */
    func sendNewPressed(socketModel: XBSocketValueModel)  {
        let channel = "storybox/\(XBUserManager.device_Id)/server/page"
        
        guard let message = socketModel.toJSONString() else {
            return
        }
        guard  let data = message.data(using: .utf8) else {
            return
        }
        mqttSession.publish(data, in: channel, delivering: .atMostOnce, retain: false) { (error) in
            if error == .none {
                print("Published \(message) on channel \(channel)")
            }
        }
    }
    func mapChnnelInfo(message: String)  {
        let json_str = message.json_Str()
        let cmd_str = json_str["cmd"].stringValue
        
        if let _ = json_str["trackListId"].int, // 拿到歌曲信息
           let trackId = json_str["trackId"].int,
           let _ = json_str["type"].int{
            self.playingSongId = trackId
            getPalyingSingsId.onNext(trackId)
        }
        
        if let volume = json_str["volume"].int{ // 拿到歌曲信息
            getPlayVolume.onNext(volume)
        }
        if json_str["playStatus"].stringValue == "playing" {
            self.playStatus.onNext(true)
        }
        if json_str["playStatus"].stringValue == "pause" {
            self.playStatus.onNext(false)
        }
        if json_str["mode"].stringValue == "repeat all" {
            self.repeatStatus.onNext(true)
        }
        if json_str["mode"].stringValue == "repeat one" {
            self.repeatStatus.onNext(false)
        }
        if cmd_str == "initialTrackList" {
            self.getSetDefaultMessage.onNext(message)
        }
        if cmd_str == "customer" {
            let key_str = json_str["key"].stringValue
            let value_str = json_str["value"].intValue
            if key_str == "childlock" {
                self.getLock.onNext(value_str)
            }
            if key_str == "light" {
                self.getLight.onNext(value_str)
            }
            if key_str == "poweroff" {
                self.getPoweroff.onNext(value_str)
            }
            if key_str == "playProgress" {
                self.getPlayProgress.onNext(value_str)
            }
            self.getSetDefaultMessage.onNext(message)
        }
        if let firmwareVersion = json_str["boxInfo"]["firmwareVersion"].string {
         
            self.getDeviceVersion.onNext(firmwareVersion)
        }
    }
    /**
     *   询问机器此时播放的是哪个列表的那首歌曲
     */
    func sendGetTrack() {
        let socket = XBSocketModel()
        socket.cmd = "getTrack"
        self.sendPressed(socketModel: socket)
    }
    /**
     *   询问机器的循环状态，是单曲循环还是全部循环
     */
    func sendGetMode() {
        let socket = XBSocketModel()
        socket.cmd = "getMode"
        self.sendPressed(socketModel: socket)
    }
    /**
     *  询问机器此时的播放状态
     */
    func sendPlayStatus() {
        let socket = XBSocketModel()
        socket.cmd = "getPlayStatus"
        self.sendPressed(socketModel: socket)
    }
    /**
     *  询问机器此时的播放音量大小
     */
    func sendGetVolume() {
        let socket = XBSocketModel()
        socket.cmd = "getVolume"
        self.sendPressed(socketModel: socket)
    }
    /**
     *  获取设备童锁开关状态
     */
    func sendGetLock() {
        let socket = XBSocketModel()
        socket.cmd = "customer"
        socket.key = "getChildlock"
        self.sendPressed(socketModel: socket)
    }
    /**
     *  获取设备此时的呼吸灯开关状态
     */
    func sendLight() {
        let socket = XBSocketModel()
        socket.cmd = "customer"
        socket.key = "getLight"
        self.sendPressed(socketModel: socket)
    }
    /**
     *  询问机器此时的播放音量大小
     */
    func sendGetPowerOff() {
        let socket = XBSocketModel()
        socket.cmd = "customer"
        socket.key = "getPoweroff"
        self.sendPressed(socketModel: socket)
    }
    /**
     *  询问机器此时的设备版本号
     */
    func sendGetDeviceVersion() {
        let socket = XBSocketModel()
        socket.cmd = "getBoxInfo"
        self.sendPressed(socketModel: socket)
    }
    /**
     *  设置机器此时的播放音量大小
     */
    func setVolumeValue(value: Int) {
        let socket = XBSocketValueModel()
        socket.cmd = "setVolume"
        socket.value = value
        self.sendNewPressed(socketModel: socket)

    }
    /**
     *   移动端点击恢复默认列表
     */
    func sendSetDefault(trackListId: Int) {
        let socket = XBSocketModel()
        socket.cmd          = "getInitialTrackList"
        socket.trackListId  = trackListId
        self.sendPressed(socketModel: socket)
    }
    /**
     *   移动端点击 预制列表下的播放
     */
    func sendTrackListPlay(trackListId:Int, singModel: SingDetailModel) {
        let socket = XBSocketModel()
        socket.cmd          = "playTrack"
        socket.trackListId  = trackListId
        socket.trackId  = singModel.id
        socket.url  = singModel.url
        socket.downloadUrl  = singModel.downloadUrl
        self.sendPressed(socketModel: socket)
    }
    /**
     *   移动端点击 暂停播放
     */
    func sendPausePlay() {
        let socket = XBSocketModel()
        socket.cmd          = "pause"
        self.sendPressed(socketModel: socket)
    }
    /**
     *   移动端点击 恢复播放
     */
    func sendResumePlay() {
        let socket = XBSocketModel()
        socket.cmd          = "resume"
        self.sendPressed(socketModel: socket)
    }
    /**
     *   移动端获取播放进度
     */
    func sendGetPlayProgress() {
        let socket = XBSocketModel()
        socket.cmd          = "customer"
        socket.key          = "getPlayProgress"
        self.sendPressed(socketModel: socket)
    }
    /**
     *  设置机器此时的播放进度
     */
    func setPlayProgressValue(value: Int) {
        let socket = XBSocketValueModel()
        socket.cmd          = "customer"
        socket.key          = "seek"
        socket.value        = value
        self.sendNewPressed(socketModel: socket)
        
    }
    /**
     *  设置机器 定时关机  value == 0 为取消定时关机 ，value == -1 为立即关机
     */
    func setPowerOff(value: Int) {
        let socket = XBSocketValueModel()
        socket.cmd          = "customer"
        socket.key          = "setPoweroff"
        socket.value        = value
        self.sendNewPressed(socketModel: socket)
        
    }
    /**
     *  设置立即关机
     */
//    func setPlayProgressValue(value: Int) {
//        let socket = XBSocketValueModel()
//        socket.cmd          = "customer"
//        socket.key          = "seek"
//        socket.value        = value
//        self.sendNewPressed(socketModel: socket)
//
//    }
    /**
     *   移动端点击 上一首
     */
    func sendSongOn() {
        let socket = XBSocketModel()
        socket.cmd          = "backward"
        self.sendPressed(socketModel: socket)
    }
    /**
     *   移动端点击 下一首
     */
    func sendSongDown() {
        let socket = XBSocketModel()
        socket.cmd          = "forward"
        self.sendPressed(socketModel: socket)
    }
    /**
     *   移动端设置 全部循环
     */
    func sendRepeatAll() {
        let socket = XBSocketModel()
        socket.cmd          = "setMode"
        socket.value        = "repeat all"
        self.sendPressed(socketModel: socket)
    }
    /**
     *   移动端设置 单曲播放
     */
    func sendRepeatOne() {
        let socket = XBSocketModel()
        socket.cmd          = "setMode"
        socket.value        = "repeat one"
        self.sendPressed(socketModel: socket)
    }
    /**
     *   移动端点击 关闭呼吸灯 0/ 关闭 1/ 开去
     */
    func sendClooseLight(_ value: Int) {
        let socket = XBSocketValueModel()
        socket.cmd          = "customer"
        socket.key          = "setLight"
        socket.value        = value
        self.sendNewPressed(socketModel: socket)
    }
    /**
     *   移动端点击 关闭儿童锁 0/ 关闭 1/ 开去
     */
    func sendCortolLock(_ value: Int) {
        
        let socket = XBSocketValueModel()
        socket.cmd          = "customer"
        socket.key          = "setChildlock"
        socket.value        = value
        
        self.sendNewPressed(socketModel: socket)
    }
    /**
     *   移动端点击 控制设备升级
     */
    func sendUpdateDevice(_ versionName: String,url: String) {
        
        let socket = XBSocketModel()
        socket.cmd          = "upgrade"
        socket.versionName  = versionName
        socket.firmwareUrl  = url
        
        self.sendPressed(socketModel: socket)
    }
    
    func mqttDidReceive(message: MQTTMessage, from session: MQTTSession) {
        print("接收到 topic message:\n \(message.stringRepresentation ?? "<>")")
        if let message = message.stringRepresentation {
            self.mapChnnelInfo(message: message)
        }
       
    }
    
    func mqttDidAcknowledgePing(from session: MQTTSession) {
        print("Keep-alive ping 链接.")
    }
    
    func mqttDidDisconnect(session: MQTTSession, error: MQTTSessionError) {
        print("Keep-alive ping 断开.")
//        session.connect(completion: nil)
        mqttSession.connect { (error) in
            if  error == .none {
                print("Connected.")
                self.current_socket_clientID = XBUserManager.device_Id
                self.subscribeToChannel(socket_clientId: XBUserManager.device_Id)
            } else {
                print("Connected error.")
            }
        }
    }
    
}
