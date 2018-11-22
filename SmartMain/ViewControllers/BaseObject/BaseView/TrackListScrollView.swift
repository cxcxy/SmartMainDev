//
//  TrackListScrollView.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/11/20.
//  Copyright © 2018 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
import VTMagic
class TrackListScrollView: ETPopupView {
    var v                   : VCVTMagic!  // 统一的左滑 右滑 控制View
    var controllerArray     : [UIViewController] = []  // 存放controller 的array
    var trackList: [EquipmentModel] = [] {
        didSet {
            controllerArray.remove_All()
            for item in trackList {
                let vc = EquipmentSubListVC()
                vc.trackListId = item.id
                vc.trackList = trackList
                vc.listType = .trackScollList
                controllerArray.append(vc)
            }
            pageControl.numberOfPages = trackList.count
            v.magicView.reloadData()
        }
    } // 预制列表数据model
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var lbTrackName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        animationDuration = 0.3
        type = .sheet
        
        self.snp.makeConstraints { (make) in
            make.width.equalTo(MGScreenWidth)
        }
        ETPopupWindow.sharedWindow().touchWildToHide = true
        UIApplication.shared.keyWindow?.endEditing(true)
//        self.setCornerRadius(radius: 5.0)
        self.layoutIfNeeded()
        self.configMagicView()
    }
    //MARK:配置所对应的左右滑动ViewControler
    func configMagicView()  {
        v                                       = VCVTMagic()
        v.magicView.dataSource                  = self
        v.magicView.delegate                    = self
        v.magicView.needPreloading      = false
        v.magicView.navigationView.isHidden = true
        v.magicView.navigationHeight = 0
        self.layoutIfNeeded()
        self.viewContainer.layoutIfNeeded()
        v.magicView.frame = CGRect.init(x: 0, y: 0, w: MGScreenWidth, h: viewContainer.height)
        self.viewContainer.addSubview(v.magicView)

        v.magicView.reloadData()
    }
}
//MARK:VTMagicViewDataSource
extension TrackListScrollView: VTMagicViewDataSource{
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
        
       let arr = trackList.map { (item) -> String in
            return item.name ?? ""
        }
        return arr

    }
    func magicView(_ magicView: VTMagicView, menuItemAt itemIndex: UInt) -> UIButton{
        let button = magicView .dequeueReusableItem(withIdentifier: self.identifier_magic_view_bar_item)
        
        if ( button == nil) {
//            let width           = self.view.frame.width / 3
            let b               = UIButton(type: .custom)
            b.frame             = CGRect(x: 0, y: 0, width: 0, height: 50)
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
extension TrackListScrollView: VTMagicViewDelegate{
    
    func magicView(_ magicView: VTMagicView, viewDidAppear viewController: UIViewController, atPage pageIndex: UInt){
        print("pageIndex",pageIndex)
        let index = Int(pageIndex)
        pageControl.currentPage = index
        self.lbTrackName.set_text = "播单-" + (trackList[index].name ?? "")
    }
    
    func magicView(_ magicView: VTMagicView, didSelectItemAt itemIndex: UInt){
        print("itemIndex",itemIndex)
    }
    
}
