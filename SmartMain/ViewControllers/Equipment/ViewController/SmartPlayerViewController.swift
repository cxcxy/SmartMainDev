//
//  SmartPlayerViewController.swift
//  SmartMain
//
//  Created by mac on 2018/9/12.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class SmartPlayerViewController: XBBaseViewController {
    
    
    @IBOutlet weak var lbVolume: UILabel!
    
    var dataLikeArr: [ConetentLikeModel] = []
    @IBOutlet weak var imgSings: UIImageView!
    @IBOutlet weak var lbSingsTitle: UILabel!
    
    @IBOutlet weak var btnRepeat: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    
    @IBOutlet weak var btnOn: UIButton!
    @IBOutlet weak var lbCurrentSongProgress: UILabel!
    @IBOutlet weak var lbSongProgress: UILabel!
    @IBOutlet weak var sliderProgress: UISlider!
    @IBOutlet weak var sliderVolume: UISlider!
    
    fileprivate var timer: Timer? // 歌曲进度条
    
    var currentSongProgress  = 0 { // 歌曲的当前时间
        didSet {
            lbCurrentSongProgress.text = XBUtil.getDetailTimeWithTimestamp(timeStamp: Int(currentSongProgress),formatTypeText: false)
            self.sliderProgress.value = Float(currentSongProgress)
        }
    }
    
    var allTimer:Float    = 100 // 歌曲的全部时间
    
    
    @IBOutlet weak var btnDown: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    var currentSongModel:SingDetailModel? {
        didSet {
            guard let m = currentSongModel else {
                return
            }
           let isLike = self.dataLikeArr.filter { (item) -> Bool in
                return item.trackId == m.id
            }
            self.btnLike.isSelected = isLike.count == 0 ? false : true
            sliderProgress.maximumValue = Float(m.duration ?? 0)
            self.configUI(singsDetail: m)
        }
    }
    let scoketModel = ScoketMQTTManager.share
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "歌曲名"
    }
    override func setUI() {
        super.setUI()
        request()
        scoketModel.sendGetTrack()
        scoketModel.sendGetMode()
        scoketModel.sendPlayStatus()
        scoketModel.sendGetVolume()
        scoketModel.sendGetPlayProgress()
        scoketModel.getPalyingSingsId.asObservable().subscribe { [weak self] in
            guard let `self` = self else { return }
            print("getPalyingSingsId ===：", $0.element ?? 0)
            self.requestSingsDetail(trackId: $0.element ?? 0)
        }.disposed(by: rx_disposeBag)
       
        scoketModel.getPlayVolume.asObservable().subscribe { [weak self] in
            guard let `self` = self else { return }
            print("getPalyingVolume ===：", $0.element ?? 0)
            let volumeValue: Float = Float($0.element ?? 0) / 100
            self.sliderVolume.setValue(volumeValue, animated: true)
        }.disposed(by: rx_disposeBag)
        
        scoketModel.getPlayProgress.asObservable().subscribe { [weak self] in
            guard let `self` = self else { return }
            print("getPlayProgress ===：", $0.element ?? 0)
//            let progressValue: Float = Float($0.element ?? 0) / 100
            // 设置 播放进度条
//            self.sliderProgress.setValue(Float($0.element ?? 0), animated: true)
            self.currentSongProgress = $0.element ?? 0
        }.disposed(by: rx_disposeBag)
        
        scoketModel.playStatus.asObserver().bind(to: btnPlay.rx.isSelected).disposed(by: rx_disposeBag)
        scoketModel.repeatStatus.asObserver().bind(to: btnRepeat.rx.isSelected).disposed(by: rx_disposeBag)
        
        //MARK: 测试用
        self.configTimer(songDuration: allTimer)
        
        
    }
    func configTimer(songDuration: Float)  {
//        guard let `self` = self else { return }
         timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tickDown), userInfo: nil, repeats: true)
//        if #available(iOS 10.0, *) {
//            timer = Timer.init(timeInterval: 1, repeats: true, block: { [weak self] (timer) in
//                guard let `self` = self else { return }
//                self.tickDown()
//
//            })
//        } else {
//
//        }
        
         RunLoop.main.add(timer!, forMode: .commonModes)
        // 设置 时间
        sliderProgress.maximumValue = songDuration
        lbSongProgress.set_text = XBUtil.getDetailTimeWithTimestamp(timeStamp: Int(songDuration),formatTypeText: false)
        
    }
    deinit {
        resetTimer()
    }
    //MARK: 重置计时器
    func resetTimer()  {
        timer?.invalidate()
        timer = nil
    }
    /**
     *计时器每秒触发事件
     **/
    @objc func tickDown()
    {
        print(currentSongProgress)
        
        currentSongProgress      = currentSongProgress + 1
        if currentSongProgress >= Int(allTimer) { // 当前歌曲播放完毕
            resetTimer()
            self.currentSongProgress = 0
            self.configTimer(songDuration: 150)
        }

    }
    @IBAction func sliderProgressVauleChanged(_ sender: Any) {
        let value:Float = sliderProgress.value
        print("歌曲时间",Int(sliderProgress.value))
        currentSongProgress = Int(sliderProgress.value)
//        let duration:Float = Float(currentSongModel?.duration ?? 0)
        scoketModel.setPlayProgressValue(value: Int(value))
    }
    
    @IBAction func sliderVolumeValueChanged(_ sender: Any) {
        print(Int(sliderVolume.value))
        scoketModel.setVolumeValue(value: Int(sliderVolume.value * 100))
    }
    
    override func request() {
        super.request()
        guard let phone = user_defaults.get(for: .userName) else {
            XBHud.showMsg("请登录")
            return
        }
        Net.requestWithTarget(.getLikeList(openId: phone), successClosure: {[weak self] (result, code, message) in
            guard let `self` = self else { return }
            if let arr = Mapper<ConetentLikeModel>().mapArray(JSONString: result as! String) {
                self.dataLikeArr = arr
            }
        })
    }
    func requestSingsDetail(trackId: Int)  {
        Net.requestWithTarget(.getSingDetail(trackId: trackId), successClosure: { [weak self] (result, code, message) in
            guard let `self` = self else { return }
            guard let result = result as? String else {
                return
            }
            self.currentSongModel = Mapper<SingDetailModel>().map(JSONString: result)
        })
    }
    func configUI(singsDetail: SingDetailModel) {
        imgSings.set_Img_Url(singsDetail.coverSmallUrl)
        lbSingsTitle.set_text = singsDetail.title
        lbSongProgress.set_text = XBUtil.getDetailTimeWithTimestamp(timeStamp: singsDetail.duration)
        self.resetTimer()
        // 计时器开始工作
        self.configTimer(songDuration: Float(singsDetail.duration ?? 0))
    }

    @IBAction func clickRepeatAction(_ sender: Any) {
        self.btnRepeat.isSelected ? scoketModel.sendRepeatOne() : scoketModel.sendRepeatAll()
    }
    @IBAction func clickOnAction(_ sender: Any) {
        scoketModel.sendSongOn()
    }
    
    @IBAction func clickPlayAction(_ sender: Any) {
        self.btnPlay.isSelected ?  scoketModel.sendPausePlay() : scoketModel.sendResumePlay()
    }
    
    @IBAction func clickDownAction(_ sender: Any) {
        scoketModel.sendSongDown()
    }
    @IBAction func clickLikeAction(_ sender: Any) {
        self.btnLike.isSelected ? requestCancleLikeSing() : requestLikeSing()
    }
    func requestLikeSing()  {
        
        var params_task = [String: Any]()
        params_task["openId"] = XBUserManager.userName
        params_task["trackId"]  = currentSongModel?.id
        params_task["duration"] = currentSongModel?.duration
        params_task["title"]    = currentSongModel?.title
        Net.requestWithTarget(.saveLikeSing(req: params_task), successClosure: { [weak self](result, code, message) in
            guard let `self` = self else { return }
            if let str = result as? String {
                if str == "ok" {
                    XBHud.showMsg("收藏成功")
                    let likeModel = ConetentLikeModel()
                    likeModel.trackId = self.currentSongModel?.id
                    self.dataLikeArr.append(likeModel)
                    self.btnLike.isSelected = true
                }else {
                    XBHud.showMsg("收藏失败")
                }
            }
        })
        
    }
    func requestCancleLikeSing()  {
        
        var params_task = [String: Any]()
        params_task["openId"] = XBUserManager.userName
        params_task["trackId"]  = currentSongModel?.id
        Net.requestWithTarget(.deleteLikeSing(req: params_task), successClosure: { [weak self](result, code, message) in
            guard let `self` = self else { return }
            if let str = result as? String {
                if str == "ok" {
                    XBHud.showMsg("取消收藏成功")
                   self.dataLikeArr =  self.dataLikeArr.filter({ (item) -> Bool in
                    return item.trackId != self.currentSongModel?.id
                    })
                    self.btnLike.isSelected = false
                }else {
                    XBHud.showMsg("取消收藏失败")
                }
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
