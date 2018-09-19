//
//  SmartPlayerViewController.swift
//  SmartMain
//
//  Created by mac on 2018/9/12.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class SmartPlayerViewController: XBBaseViewController {
    var dataLikeArr: [ConetentLikeModel] = []
    @IBOutlet weak var imgSings: UIImageView!
    @IBOutlet weak var lbSingsTitle: UILabel!
    
    @IBOutlet weak var btnRepeat: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    
    @IBOutlet weak var btnOn: UIButton!
    
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
            self.configUI(singsDetail: m)
        }
    }
    let scoketModel = ScoketMQTTManager.share
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setUI() {
        super.setUI()
        request()
        scoketModel.sendGetTrack()
        scoketModel.sendGetMode()
        scoketModel.sendPlayStatus()
        scoketModel.getPalyingSingsId.asObservable().subscribe { [weak self] in
            guard let `self` = self else { return }
            print("getPalyingSingsId ===：", $0.element ?? 0)
            self.requestSingsDetail(trackId: $0.element ?? 0)
        }.disposed(by: rx_disposeBag)
        
        scoketModel.playStatus.asObserver().bind(to: btnPlay.rx.isSelected).disposed(by: rx_disposeBag)
        scoketModel.repeatStatus.asObserver().bind(to: btnRepeat.rx.isSelected).disposed(by: rx_disposeBag)
        
    }
    override func request() {
        super.request()
        guard let phone = user_defaults.get(for: .userName) else {
            XBHud.showMsg("请登录")
            return
        }
        Net.requestWithTarget(.getLikeList(openId: phone), successClosure: { (result, code, message) in
            if let arr = Mapper<ConetentLikeModel>().mapArray(JSONString: result as! String) {
                self.dataLikeArr = arr
            }
        })
    }
    func requestSingsDetail(trackId: Int)  {
        Net.requestWithTarget(.getSingDetail(trackId: trackId), successClosure: { (result, code, message) in
            
            guard let result = result as? String else {
                return
            }
            self.currentSongModel = Mapper<SingDetailModel>().map(JSONString: result)
        })
    }
    func configUI(singsDetail: SingDetailModel) {
        imgSings.set_Img_Url(singsDetail.coverSmallUrl)
        lbSingsTitle.set_text = singsDetail.title
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
        Net.requestWithTarget(.saveLikeSing(req: params_task), successClosure: { (result, code, message) in
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
        Net.requestWithTarget(.deleteLikeSing(req: params_task), successClosure: { (result, code, message) in
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
