//
//  ScoketMQTTManager.swift
//  SmartMain
//
//  Created by mac on 2018/9/12.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
let socket_host             = "zb.mqtt.athenamuses.cn"
let socket_port: UInt16     = 1893
let socket_clientID         = XBUserManager.device_Id


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
     *   获取当前正在播放的歌曲Id
     */
    let getPalyingSingsId = PublishSubject<Int>()
    /**
     *   回复默认预制列表 数据
     */
    let getSetDefaultMessage = PublishSubject<String>()
    
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
                self.subscribeToChannel()
            } else {
                print("Connected error.")
            }
        }
    }
    /**
     *   订阅机器信息
     */
    func subscribeToChannel() {
        let channel = "storybox/\(XBUserManager.device_Id)/client"
        mqttSession.subscribe(to: channel, delivering: .atLeastOnce) { (error) in
            if error == .none {
                print("Subscribed to \(channel)")
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
            getPalyingSingsId.onNext(trackId)
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
    }
    
}
