//
//  SearchViewController.swift
//  SmartMain
//
//  Created by mac on 2018/9/4.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
import VTMagic
class SearchSectionModel: NSObject {
    var sectionType: String = ""
    var sectionModel: ConetentSingModel?
    var sectionArr: [ConetentSingModel] = []
}
extension NSLayoutConstraint {
    func adapterTop_X()  { // 顶部适配X
        let constant_x = self.constant + 20
        self.constant = UIDevice.isX() ? constant_x : self.constant
    }
}
class SearchViewController: XBBaseViewController {

    @IBOutlet weak var bottomView: UIView!
    var controllerArray     : [UIViewController] = []  // 存放controller 的array
    var search_songs = SearchSongsViewController()
    var search_album = SearchAlbumViewController()
    var v                   : VCVTMagic!  // 统一的左滑 右滑 控制View
    
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var viewSearchTop: UIView!
    @IBOutlet weak var heightTopView: NSLayoutConstraint!
    
    
    var trackList: [EquipmentModel] = [] // 预制列表 数组
    
    @IBOutlet weak var lbSearch: UILabel!
    @IBOutlet weak var btnClear: UIButton!
    
    var headerSongInfo:ConetentSingAlbumModel?
    var headerAlbumInfo:ConetentSingAlbumModel?
    

    let disposeBag = DisposeBag()
    var resourceArr:[ConetentSingModel]      = []
    var resourceAlbum: [ConetentSingModel]   = []

    var sectionArr: [SearchSectionModel] = []
    
    var sectionNumber: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heightTopView.adapterTop_X()
    }
    @IBAction func clickClearAction(_ sender: Any) {
        self.textField.text = ""
    }
    override func setUI() {
        super.setUI()
        self.view.backgroundColor = UIColor.white
        
        self.currentNavigationHidden        = true
        viewSearchTop.setCornerRadius(radius: 15)
        textField.becomeFirstResponder()

        let input = textField.rx.text.orEmpty.asDriver()
        
        input.map{ $0.count == 0 }
            .drive(btnClear.rx.isHidden)
            .disposed(by: disposeBag)
        
        input.map{ $0.count != 0 }
            .drive(lbSearch.rx.isHidden)
            .disposed(by: disposeBag)

        
        self.textField.delegate = self
        self.configMagicView()
        requestTrackList()
    }


    /// 搜索资源
    override func request()  {
        super.request()
        self.sectionArr.remove_All()
        var params_task = [String: Any]()
        params_task["clientId"] = XBUserManager.device_Id
        params_task["keywords"] = [self.textField.text]
        params_task["page"]     = 1
        params_task["ranges"] = ["resource"]
        Net.requestWithTarget(.getSearchResource(req: params_task), successClosure: { (result, code, message) in
            self.endRefresh()
            if let arr = Mapper<ConetentSingModel>().mapArray(JSONObject:JSON(result)["resources"].arrayObject) {
                
                self.resourceArr = self.flatMapLikeList(arr: arr)
                self.search_songs.dataArrFromSearch = arr
                self.search_songs.trackList = self.trackList
                self.search_songs.searchKey = self.textField.text!
                self.search_songs.pageIndex = 1
                self.requestResourceAlbum()
                

            }
            if let topModel = Mapper<ConetentSingAlbumModel>().map(JSONObject:JSON(result)["resourcesPager"].object) {
                self.headerSongInfo = topModel
                self.search_songs.headerInfo = self.headerSongInfo
            }
        })
    }
    /// 搜索专辑
    func requestResourceAlbum()  {
        var params_album = [String: Any]()
        params_album["clientId"] = XBUserManager.device_Id
        params_album["keywords"] = [self.textField.text]
        params_album["page"]     = 1
        params_album["ranges"] = ["album"]
        Net.requestWithTarget(.getSearchResource(req: params_album), successClosure: { (result, code, message) in
            if let arr = Mapper<ConetentSingModel>().mapArray(JSONObject:JSON(result)["albums"].arrayObject) {
                self.resourceAlbum = arr
                let sectionItem = SearchSectionModel()
                sectionItem.sectionType = "album"
                sectionItem.sectionArr =  self.resourceAlbum
                self.sectionNumber += 1
                self.sectionArr.append(sectionItem)
            }
            if let topModel = Mapper<ConetentSingAlbumModel>().map(JSONObject:JSON(result)["albumsPager"].object) {
                self.headerAlbumInfo = topModel
            }
            self.search_album.dataTopArr = self.resourceAlbum
            self.search_album.searchKey = self.textField.text!
            self.search_album.headerAlbumInfo = self.headerAlbumInfo
            self.search_album.pageIndex = 1
            if self.resourceArr.count > 0 || self.resourceAlbum.count > 0 {
                self.bottomView.isHidden = false
            } else {
                self.bottomView.isHidden = true
            }

        })
    }
    func flatMapLikeList(arr: [ConetentSingModel]) -> [ConetentSingModel] {
        for item in arr {
            for likeitem in userLikeList {
                if likeitem.trackId == item.trackId {
                    item.isLike = true
                    continue
                }
            }
        }
        return arr
    }
    @IBAction func clickCancelAction(_ sender: Any) {
        self.popVC()
    }
    func requestTrackList() {
        guard XBUserManager.device_Id != "" else {
            endRefresh()
            return
        }
        Net.requestWithTarget(.getTrackList(deviceId: XBUserManager.device_Id), successClosure: { (result, code, message) in
            print(result)
            if let arr = Mapper<EquipmentModel>().mapArray(JSONString: result as! String) {
                self.endRefresh()
                self.trackList = arr

            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.textField {
            self.request()
        }
        return true
    }
    
}
//MARK:VTMagicViewDataSource
extension SearchViewController: VTMagicViewDataSource{
    //MARK:配置所对应的左右滑动ViewControler
    func configMagicView()  {
        v                                       = VCVTMagic()
        v.magicView.dataSource                  = self
        v.magicView.delegate                    = self
//        v.magicView.needPreloading              = false
        v.magicView.layoutStyle = .center
        v.magicView.itemSpacing = 60
        v.magicView.sliderWidth = 30
        v.magicView.sliderHeight = 3
        v.magicView.sliderColor = UIColor.white
        //        let vc = ContentVC.init(style: .grouped)
//        let vc1 = SearchChildViewController()
   
        controllerArray = [search_songs,search_album]
        
        self.addChildViewController(v)
        self.bottomView.addSubview(v.magicView)
        v.magicView.snp.makeConstraints {[weak self] (make) -> Void in
            if let strongSelf = self {
                make.size.equalTo(strongSelf.bottomView)
                
            }
        }
        v.magicView.reloadData()
        self.bottomView.isHidden = true
    }
    
    
    var identifier_magic_view_bar_item : String {
        get {
            return "identifier_magic_view_bar_item"
        }
    }
    var identifier_magic_view_page : String {
        get {
            return "identifier_magic_view_page"
        }
    }
    func menuTitles(for magicView: VTMagicView) -> [String] {
        
        return ["专辑","歌曲"]
        
    }
    func magicView(_ magicView: VTMagicView, menuItemAt itemIndex: UInt) -> UIButton{
        let button = magicView .dequeueReusableItem(withIdentifier: self.identifier_magic_view_bar_item)
        
        if ( button == nil) {
//            let width           = self.view.frame.width / 3
            let b               = UIButton(type: .custom)
//            b.frame             = CGRect(x: 0, y: 0, width: width, height: 50)
            b.titleLabel!.font  =  UIFont.systemFont(ofSize: 14)
            b.setTitleColor(MGRgb(0, g: 0, b: 0, alpha: 0.3), for: UIControlState())
            b.setTitleColor(UIColor.white, for: .selected)
            b.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            
            return b
        }
        
        return button!
    }
    @objc func buttonAction(){
        //        DLog("button")
    }
    func magicView(_ magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController{
        return controllerArray[Int(pageIndex)]
    }
}
//MARK:VTMagicViewDelegate
extension SearchViewController :VTMagicViewDelegate{
    func magicView(_ magicView: VTMagicView, viewDidAppear viewController: UIViewController, atPage pageIndex: UInt){
        
    }
    
    func magicView(_ magicView: VTMagicView, didSelectItemAt itemIndex: UInt){
        
    }
    
}
