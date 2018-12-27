//
//  SmartPlayerViewController.swift
//  SmartMain
//
//  Created by mac on 2018/9/12.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

extension CALayer {
    ///暂停动画
    func pauseAnimation() {
        //取出当前时间,转成动画暂停的时间
        let pausedTime = self.convertTime(CACurrentMediaTime(), from: nil)
        //设置动画运行速度为0
        self.speed = 0.0;
        //设置动画的时间偏移量，指定时间偏移量的目的是让动画定格在该时间点的位置
        self.timeOffset = pausedTime
    }
    ///恢复动画
    func resumeAnimation() {
        //获取暂停的时间差
        let pausedTime = self.timeOffset
        self.speed = 1.0
        self.timeOffset = 0.0
        self.beginTime = 0.0
        //用现在的时间减去时间差,就是之前暂停的时间,从之前暂停的时间开始动画
        let timeSincePause = self.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        self.beginTime = timeSincePause
    }
}

class SmartPlayerViewController: XBBaseViewController {
    
    

    
    var dataLikeArr: [ConetentLikeModel] = []
    @IBOutlet weak var imgSings: UIImageView!
    @IBOutlet weak var lbSingsTitle: UILabel!
    
    @IBOutlet weak var btnRepeat: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    
    @IBOutlet weak var lbAlbumName: UILabel!
    @IBOutlet weak var btnOn: UIButton!
    @IBOutlet weak var lbCurrentSongProgress: UILabel!
    @IBOutlet weak var lbSongProgress: UILabel!
    @IBOutlet weak var btnAudion: UIButton!
    @IBOutlet weak var viewProgress: UIView!
    @IBOutlet weak var sliderProgress: UISlider!
    
    @IBOutlet weak var sliderProgressView: UIProgressView!
    
    let playerLayer:AVPlayerLayer = AVPlayerLayer.init()
    var player:AVPlayer = AVPlayer.init()
    
    @IBOutlet weak var viewPhoto: UIView!
 
    var trackList: [EquipmentModel] = []

    
    @IBOutlet weak var stackMnueView: UIStackView!
    fileprivate var timer: Timer? // 歌曲进度条
    
    var isFirst: Bool = false
    
    var currentSongProgress  = 0 { // 歌曲的当前时间
        didSet {
            lbCurrentSongProgress.text = XBUtil.getDetailTimeWithTimestamp(timeStamp: Int(currentSongProgress),formatTypeText: false)

            self.configProgressSlider(value: Float(currentSongProgress))

        }
    }
    
    @IBOutlet weak var rightSliderLayout: NSLayoutConstraint!
    
    
    @IBOutlet weak var photoWidthLayout: NSLayoutConstraint!
    
    @IBOutlet weak var imgBackGround: UIImageView!
    var allTimer:Float    = 0 // 歌曲的全部时间
    
    var currentVolume: Int = 0
    @IBOutlet weak var btnDown: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    var currentSongModel:ResourceDetailModel? {
        didSet {
            guard let m = currentSongModel else {
                return
            }
           let isLike = self.dataLikeArr.filter { (item) -> Bool in
                return item.trackId == m.trackId
            }
            self.btnLike.isSelected = isLike.count == 0 ? false : true
            sliderProgress.maximumValue = Float(m.length ?? 0)
            self.allTimer = Float(self.currentSongModel?.length ?? 0)
            self.resetTimer()
            
            // 获取播放状态
            self.scoketModel.sendPlayStatus()
        }
    }
    let scoketModel = ScoketMQTTManager.share
    let viewModel = ContentViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "歌曲名"
        self.currentNavigationHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.resetTimer()
    }
    func setSiderThumeImage()  {

        viewProgress.setCornerRadius(radius: 5)
        
    }
    //MARK: 绑定 音乐进度条
    func configProgressSlider(value: Float)  {

        self.sliderProgress.value = value
        sliderProgressView.progress = sliderProgress.maximumValue == 0 ? 0 : ( value / sliderProgress.maximumValue )
        
//        let input =  sliderProgress.rx.value.asDriver()
//        input.map { print("qqq",$0) }
//            .drive(sliderProgressView.rx.progress)
//            .disposed(by: rx_disposeBag)
        
        
    }
    func adapterUI()  {
        if UIDevice.deviceType == .dt_iPhone5 {
            let w = MGScreenWidth - 90
            self.photoWidthLayout.constant = w
            self.viewPhoto.setCornerRadius(radius: w / 2)
            self.imgSings.setCornerRadius(radius: (w - 8) / 2 )
        }else {
            viewPhoto.roundView()
            imgSings.roundView()
        }
        let itemLine = (MGScreenWidth - (15 * 2) - 40 - 40 - 50 - 50 - 60) / 4
        stackMnueView.spacing = itemLine
        
    }
    func progressAction() {
        print("滑动结束")
//        currentSongProgress =
        scoketModel.setPlayProgressValue(value: Int(sliderProgress.value))
    }
    override func setUI() {
        super.setUI()
        
        adapterUI()
        configPlay()
        request()
//        configPhoto()
        setSiderThumeImage()
        
        if let currentSongModel = currentDeviceSongModel {
            self.currentSongModel = currentSongModel
            self.configUI(singsDetail: currentSongModel)
        }
        
//        scoketModel.sendGetTrack()
        scoketModel.sendGetMode()
        scoketModel.sendGetVolume()
        
//         [self.progressSlider addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];
        self.sliderProgress.addTarget(self, action: #selector(progressAction), for: .touchUpInside)
        
        configProgressSlider(value: 0.0)
        
        scoketModel.getPalyingSingsModel.asObservable().subscribe { [weak self] in
            guard let `self` = self else { return }
            guard let model = $0.element else { return }
            self.configUI(singsDetail: model)
        }.disposed(by: rx_disposeBag)
       
        scoketModel.getPlayVolume.asObservable().subscribe { [weak self] in
            guard let `self` = self else { return }
            print("getPalyingVolume ===：", $0.element ?? 0)
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
                    print("正在播放")
                    self.btnPlay.isSelected = true
                    self.resetTimer()
                    self.configTimer(songDuration: self.allTimer, isPlay: true)
                    self.scoketModel.sendGetPlayProgress()
                    self.resumeRotate()
                }else { // 暂停了
                    print("暂停了")
                    self.btnPlay.isSelected = false
                    self.resetTimer()
                    self.pauseRotate()
                }
            }
        }.disposed(by: rx_disposeBag)
//        scoketModel.playStatus.asObserver().bind(to: btnPlay.rx.isSelected).disposed(by: rx_disposeBag)
        scoketModel.repeatStatus.asObserver().bind(to: btnRepeat.rx.isSelected).disposed(by: rx_disposeBag)
        addRotationAnim()
        //MARK: 测试用
//        self.configTimer(songDuration: allTimer)
        
        
    }
    
    func addRotationAnim() {
        if let ani = self.imgSings.layer.animation(forKey: "rotationAnimation") {
            print("已经添加过")
        }else {
            // 1.创建动画
            let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
            // 2.设置动画的属性
            rotationAnim.fromValue = 0
            rotationAnim.toValue = Double.pi * 2
            rotationAnim.repeatCount = MAXFLOAT
            rotationAnim.duration = 40
            // 这个属性很重要 如果不设置当页面运行到后台再次进入该页面的时候 动画会停止
            rotationAnim.isRemovedOnCompletion = false
            
            // 3.将动画添加到layer中
            imgSings.layer.add(rotationAnim, forKey: "rotationAnimation")
            self.pauseRotate()
        }

    }
 // 暂停播放旋转动画
    func pauseRotate() {
        DispatchQueue.main.async {
            self.addRotationAnim()
            self.imgSings.layer.pauseAnimation()
        }

    }
    // 恢复播放旋转动画
    func resumeRotate() {
        DispatchQueue.main.async {
            
            self.addRotationAnim()
            self.imgSings.layer.resumeAnimation()
        }
        
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
//        self.configProgressSlider()
        lbSongProgress.set_text = XBUtil.getDetailTimeWithTimestamp(timeStamp: Int(songDuration),formatTypeText: false)
        
    }
//    deinit {
//        resetTimer()
//    }
    //MARK: 重置计时器
    func    resetTimer()  {
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
//        scoketModel.setPlayProgressValue(value: Int(value))
    }
    
    
    
    @IBAction func sliderVolumeValueChanged(_ sender: Any) {
//        scoketModel.setVolumeValue(value: Int(sliderVolume.value))
//        self.currentVolume = Int(sliderVolume.value)
//        self.updateLbVolumeFrame()
    }
    
    @IBAction func clickCutAction(_ sender: Any) {
//        if self.currentVolume <= 0 {
//            return
//        }
//        self.currentVolume = self.currentVolume - 1
//        scoketModel.setVolumeValue(value: currentVolume)
//        sliderVolume.setValue(Float(self.currentVolume), animated: true)
//        self.updateLbVolumeFrame()
    }
    
    @IBAction func clickAddAction(_ sender: Any) {
//        if self.currentVolume >= 100 {
//            return
//        }
//        self.currentVolume = self.currentVolume + 1
//        scoketModel.setVolumeValue(value: currentVolume)
//        sliderVolume.setValue(Float(self.currentVolume), animated: true)
//        self.updateLbVolumeFrame()
    }
    override func request() {
        super.request()
        viewModel.requestLikeListSong { [weak self](arr) in
            guard let `self` = self else { return }
            self.dataLikeArr = arr
        }
        requestTrackList()
    }
    func requestTrackList()  {
        guard XBUserManager.device_Id != "" else {
            self.loading = true
            endRefresh()
            return
        }
        
        Net.requestWithTarget(.getTrackList(deviceId: XBUserManager.device_Id), successClosure: { (result, code, message) in
            if let arr = Mapper<EquipmentModel>().mapArray(JSONString: result as! String) {
                self.loading = true
                self.endRefresh()
                self.trackList = arr
                //                self.showTrackListView(trackList: arr)
            }
        }) { (errorMsg) in
            
            self.endRefresh()
        }
    }
    //MARK: 获取歌曲详情
    func requestSingsDetail(trackId: Int)  {
        Net.requestWithTarget(.getSingDetail(trackId: trackId), successClosure: { [weak self] (result, code, message) in
            guard let `self` = self else { return }
            guard let result = result as? String else {
                return
            }
            
//            self.currentSongModel = Mapper<SingDetailModel>().map(JSONString: result)
//            self.allTimer = Float(self.currentSongModel?.duration ?? 0)
//            self.resetTimer()
//
//            // 获取播放状态
//            self.scoketModel.sendPlayStatus()
        })
    }
    func requestResourcesDetail(trackId: Int)  {
        var params_task = [String: Any]()
        params_task["clientId"] = XBUserManager.device_Id
        params_task["resId"] = "aires:" + trackId.toString
        Net.requestWithTarget(.getResourceDetail(req: params_task),isShowLoding: false, successClosure: { [weak self] (result, code, message) in
            guard let `self` = self else { return }
            print(result)
            
            if let model = Mapper<ResourceDetailModel>().map(JSONObject: result) {
                self.configUI(singsDetail: model)
            }
            
//            self.currentSongModel = Mapper<SingDetailModel>().map(JSONString: result)
//            self.allTimer = Float(self.currentSongModel?.duration ?? 0)
//            self.resetTimer()
//            // 获取播放状态
//            self.scoketModel.sendPlayStatus()
        })
    }
    func configUI(singsDetail: ResourceDetailModel) {
        self.currentSongModel = singsDetail
        imgBackGround.set_Img_Url(singsDetail.album?.imgSmall)
        imgSings.set_Img_Url(singsDetail.album?.imgSmall)
        lbSingsTitle.set_text = singsDetail.name
        if  (singsDetail.album?.name ?? "") != "" {
            lbAlbumName.isHidden = false
            lbAlbumName.set_text =  "来自:" + (singsDetail.album?.name ?? "")
        }else {
            lbAlbumName.isHidden = true
            
        }
        
        lbSongProgress.set_text = XBUtil.getDetailTimeWithTimestamp(timeStamp: singsDetail.length)
        self.resetTimer()
        
        // 计时器开始工作
//        self.configTimer(songDuration: Float(singsDetail.duration ?? 0))
    }
    func showSwitchPlayView()  {
        let v = SwitchPlayView.loadFromNib()
        v.imgAll.isHidden = !self.btnRepeat.isSelected
        v.imgSing.isHidden = self.btnRepeat.isSelected
        v.viewThree.isHidden = true
        v.viewAll.addAction { [weak self] in
            guard let `self` = self else { return }
            v.hide()
            if !self.btnRepeat.isSelected { // 顺序播放
                self.scoketModel.sendRepeatAll()
            }
            
        }
        v.viewSing.addAction { [weak self] in
             guard let `self` = self else { return }
            v.hide()
            if self.btnRepeat.isSelected { // 顺序播放
                self.scoketModel.sendRepeatOne()
            }
            
        }
        v.show()
    }
    @IBAction func clickRepeatAction(_ sender: Any) {
//        self.btnRepeat.isSelected ? scoketModel.sendRepeatOne() : scoketModel.sendRepeatAll()
        showSwitchPlayView()
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
    
    @IBAction func clickShowTrackListAction(_ sender: Any) {
        let v = TrackListScrollView.loadFromNib()
        v.trackList = self.trackList
        v.show()
    }
    /// 点击试听
    @IBAction func clickAudition(_ sender: Any) {
        guard let urlTask =  URL.init(string: self.currentSongModel?.content ?? "") else {
            XBLog("歌曲地址有误")
            return
        }
        let isAudition = currentSongModel?.isAudition ?? false
        if isAudition {
            player.pause()
            
        }else {
            let playerItem:AVPlayerItem = AVPlayerItem.init(url: urlTask)
            self.player = AVPlayer(playerItem: playerItem)
            playerLayer.player = player
            
            // 开始播放
            player.play()
        }
        currentSongModel?.isAudition = !isAudition
        btnAudion.isSelected = !isAudition
    }
    func configPlay()  {
        
        playerLayer.frame = CGRect.init(x: 10, y: 30, w: self.view.bounds.size.width - 20, h: 200)
        // 设置画面缩放模式
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        // 在视图上添加播放器
        self.view.layer.addSublayer(playerLayer)
        
    }
    /// 点击添加预制列表
    @IBAction func clickAddTrackAction(_ sender: Any) {
//        let v = NewTrackListView.loadFromNib()
//        v.trackList = self.trackList
//        v.songModel = self.currentSongModel
//        v.show()
        
        let v = PlaySongListView.loadFromNib()
        v.lbTitleDes.set_text = "添加至"
        v.listViewType = .trackList_song

        v.getTrackListIdBlock = {[weak self] (trackId, trackName) in
            guard let `self` = self else { return }
            v.hide()
            self.requestAddSingWithList(trackId: trackId, trackName: trackName)

            
        }
        v.show()
    }
    /**
     *   增加歌曲到预制列表中 添加单个歌曲
     */
    func requestAddSingWithList(trackId: Int? ,trackName: String?)  {
        guard let m = self.currentSongModel else {
            XBHud.showMsg("所需歌曲信息不全")
            return
        }
        guard let trackId = trackId else {
            XBHud.showMsg("无歌单ID")
            return
        }
        guard let trackName = trackName else {
            XBHud.showMsg("无歌单名称")
            return
        }
        let req_model = AddSongTrackReqModel()
        req_model.id = m.trackId
        req_model.title = m.name
        req_model.coverSmallUrl = m.album?.imgSmall
        req_model.duration = m.length
        req_model.url = m.content
        req_model.downloadSize = m.playUrls?.normal?.size
        req_model.downloadUrl = m.playUrls?.normal?.url
        
        Net.requestWithTarget(.addSongToList(deviceId: XBUserManager.device_Id, trackId: trackId, trackName: trackName, trackIds: [req_model]), successClosure: { (result, code, message) in
            print(result)
            if let str = result as? String {
                if str == "ok" {
                    XBHud.showMsg("加入成功")
                }else if str == "duplicate" {
                    XBHud.showMsg("歌单已经存在")
                }
            }
        })
    }
    /// 点击返回
    @IBAction func clickBackAction(_ sender: Any) {
        self.popVC()
    }
    /// 点击更多
    @IBAction func clickMoreAction(_ sender: Any) {
        print("点击更多")
        let v = PlayVolumeView.loadFromNib()
//        v.currentVolume = self.currentVolume
        v.updateLbVolumeFrame(value: Float(self.currentVolume))
        v.delegate = self
        v.show()
    }
    func requestLikeSing()  {
        
        viewModel.requestLikeSing(songId: currentSongModel?.trackId ?? 0, duration: currentSongModel?.length ?? 0, title: currentSongModel?.name ?? "") {
            let likeModel = ConetentLikeModel()
            likeModel.trackId = self.currentSongModel?.trackId
            self.dataLikeArr.append(likeModel)
            self.btnLike.isSelected = true
        }
    }
    func requestCancleLikeSing()  {
        
        viewModel.requestCancleLikeSing(trackId: currentSongModel?.trackId ?? 0) {
            self.dataLikeArr =  self.dataLikeArr.filter({ (item) -> Bool in
                return item.trackId != self.currentSongModel?.trackId
            })
            self.btnLike.isSelected = false
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension SmartPlayerViewController: PlayVolumeChangeDelegate {
    func getVolumeValue(volumeValue: Int) {
        self.currentVolume = volumeValue
    }
}
