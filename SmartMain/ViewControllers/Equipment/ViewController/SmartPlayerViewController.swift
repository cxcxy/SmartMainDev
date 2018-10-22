//
//  SmartPlayerViewController.swift
//  SmartMain
//
//  Created by mac on 2018/9/12.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
//class Block {
//    let f : T
//    init(_ f: T) { self.f = f }
//}
//extension Timer {
//    class func app_scheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Swift.Void) -> Timer {
//        if #available(iOS 10.0, *) {
//            return Timer.scheduledTimer(withTimeInterval: interval, repeats: repeats, block: block)
//        }
//        return Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(app_timerAction), userInfo: Block(block), repeats: repeats)
//    }
//
//    @objc class func app_timerAction(_ sender: Timer) {
//        if let block = sender.userInfo as? Block {
//            block.f(sender)
//        }
//    }
//}

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
    
    @IBOutlet weak var viewVolume: UIView!
    
    @IBOutlet weak var viewProgress: UIView!
    @IBOutlet weak var sliderProgress: UISlider!
    @IBOutlet weak var sliderVolume: UISlider!
    
    fileprivate var timer: Timer? // 歌曲进度条
    
    var isFirst: Bool = false
    
    var currentSongProgress  = 0 { // 歌曲的当前时间
        didSet {
            lbCurrentSongProgress.text = XBUtil.getDetailTimeWithTimestamp(timeStamp: Int(currentSongProgress),formatTypeText: false)
            self.sliderProgress.value = Float(currentSongProgress)
//            rightSliderLayout.constant = CGFloat(self.sliderProgress.value / self.sliderProgress.maximumValue) * self.viewProgress.w
        }
    }
    
    @IBOutlet weak var rightSliderLayout: NSLayoutConstraint!
    var allTimer:Float    = 0 // 歌曲的全部时间
    
    var currentVolume: Int = 0
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
    let viewModel = ContentViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "歌曲名"
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.resetTimer()
    }
    func setSiderThumeImage()  {
        sliderProgress.setThumbImage(UIImage.init(named: "icon_play_slider"), for: .normal)
        sliderProgress.setThumbImage(UIImage.init(named: "icon_play_slider"), for: .highlighted)
        sliderVolume.setThumbImage(UIImage.init(named: "icon_play_slider"), for: .normal)
        sliderVolume.setThumbImage(UIImage.init(named: "icon_play_slider"), for: .highlighted)
//        viewVolume.setCornerRadius(radius: 5)
        viewVolume.layer.cornerRadius = 5
        viewProgress.layer.cornerRadius = 5
//        viewProgress.setCornerRadius(radius: 5)
    }
    override func setUI() {
        super.setUI()
        request()
        
        setSiderThumeImage()
        scoketModel.sendGetTrack()
        scoketModel.sendGetMode()
        
        scoketModel.sendGetVolume()
        
        scoketModel.getPalyingSingsId.asObservable().subscribe { [weak self] in
            guard let `self` = self else { return }
            print("getPalyingSingsId ===：", $0.element ?? 0)
            self.requestSingsDetail(trackId: $0.element ?? 0)
        }.disposed(by: rx_disposeBag)
       
        scoketModel.getPlayVolume.asObservable().subscribe { [weak self] in
            guard let `self` = self else { return }
            print("getPalyingVolume ===：", $0.element ?? 0)
            let volumeValue: Float = Float($0.element ?? 0)
            self.sliderVolume.setValue(volumeValue, animated: true)
            //            self.lbVolume.set_text       = Int($0.element ?? 0).toString
            self.currentVolume = $0.element ?? 0
        }.disposed(by: rx_disposeBag)
        
        scoketModel.getPlayProgress.asObservable().subscribe { [weak self] in
            guard let `self` = self else { return }
            print("getPlayProgress ===：", $0.element ?? 0)
//            let progressValue: Float = Float($0.element ?? 0) / 100
            // 设置 播放进度条
//            self.sliderProgress.setValue(Float($0.element ?? 0), animated: true)
            self.currentSongProgress = $0.element ?? 0
        }.disposed(by: rx_disposeBag)
        scoketModel.playStatus.asObserver().subscribe { [weak self](status) in
            guard let `self` = self else { return }
            if let status = status.element {
                
                if status { // 正在播放
                    self.btnPlay.isSelected = true
                    self.resetTimer()
                    self.configTimer(songDuration: self.allTimer, isPlay: true)
                    self.scoketModel.sendGetPlayProgress()
                }else { // 暂停了
                    self.btnPlay.isSelected = false
                    self.resetTimer()
                }
            }
        }.disposed(by: rx_disposeBag)
//        scoketModel.playStatus.asObserver().bind(to: btnPlay.rx.isSelected).disposed(by: rx_disposeBag)
        scoketModel.repeatStatus.asObserver().bind(to: btnRepeat.rx.isSelected).disposed(by: rx_disposeBag)
        
        //MARK: 测试用
//        self.configTimer(songDuration: allTimer)
        
        
    }
    func configTimer(songDuration: Float, isPlay: Bool = false)  {
//        guard let `self` = self else { return }
        
        self.allTimer = songDuration
        if self.isFirst == false || isPlay{ // 当是第一次进去的时候 或者从暂停，到播放
//            self.scoketModel.sendGetPlayProgress()
            self.isFirst = true
        }else {
            self.currentSongProgress = 0 // 当发现切换歌曲的时候， 播放 从 0 开始
        }

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
//    deinit {
//        resetTimer()
//    }
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
//        print(currentSongProgress)
        
        currentSongProgress      = currentSongProgress + 1
        if currentSongProgress >= Int(allTimer) { // 当前歌曲播放完毕
            resetTimer()
            self.currentSongProgress = 0
        }
    }
    @IBAction func sliderProgressVauleChanged(_ sender: Any) {
        let value:Float = sliderProgress.value
        print("歌曲时间",Int(sliderProgress.value))
        currentSongProgress = Int(sliderProgress.value)
        scoketModel.setPlayProgressValue(value: Int(value))
    }
    
    @IBAction func sliderVolumeValueChanged(_ sender: Any) {
        print(Int(sliderVolume.value))
        scoketModel.setVolumeValue(value: Int(sliderVolume.value))
        self.currentVolume = Int(sliderVolume.value)
    }
    
    @IBAction func clickCutAction(_ sender: Any) {
        if self.currentVolume <= 0 {
            return
        }
        self.currentVolume = self.currentVolume - 1
        scoketModel.setVolumeValue(value: currentVolume)
        sliderVolume.setValue(Float(self.currentVolume), animated: true)
    }
    
    @IBAction func clickAddAction(_ sender: Any) {
        if self.currentVolume >= 100 {
            return
        }
        self.currentVolume = self.currentVolume + 1
        scoketModel.setVolumeValue(value: currentVolume)
        sliderVolume.setValue(Float(self.currentVolume), animated: true)
    }
    override func request() {
        super.request()
        viewModel.requestLikeListSong { [weak self](arr) in
            guard let `self` = self else { return }
            self.dataLikeArr = arr
        }
    }
    //MARK: 获取歌曲详情
    func requestSingsDetail(trackId: Int)  {
        Net.requestWithTarget(.getSingDetail(trackId: trackId), successClosure: { [weak self] (result, code, message) in
            guard let `self` = self else { return }
            guard let result = result as? String else {
                return
            }
            
            self.currentSongModel = Mapper<SingDetailModel>().map(JSONString: result)
            self.allTimer = Float(self.currentSongModel?.duration ?? 0)
            self.resetTimer()
            // 获取播放状态
            self.scoketModel.sendPlayStatus()
        })
    }
    func configUI(singsDetail: SingDetailModel) {
        imgSings.set_Img_Url(singsDetail.coverSmallUrl)
        lbSingsTitle.set_text = singsDetail.title
        lbSongProgress.set_text = XBUtil.getDetailTimeWithTimestamp(timeStamp: singsDetail.duration)
        self.resetTimer()
        
        // 计时器开始工作
//        self.configTimer(songDuration: Float(singsDetail.duration ?? 0))
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
        
        viewModel.requestLikeSing(songId: currentSongModel?.id ?? 0, duration: currentSongModel?.duration ?? 0, title: currentSongModel?.title ?? "") {
            let likeModel = ConetentLikeModel()
            likeModel.trackId = self.currentSongModel?.id
            self.dataLikeArr.append(likeModel)
            self.btnLike.isSelected = true
        }
    }
    func requestCancleLikeSing()  {
        
        viewModel.requestCancleLikeSing(trackId: currentSongModel?.id ?? 0) {
            self.dataLikeArr =  self.dataLikeArr.filter({ (item) -> Bool in
                return item.trackId != self.currentSongModel?.id
            })
            self.btnLike.isSelected = false
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
