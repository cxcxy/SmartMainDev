//
//  ContentScrollCell.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/10/16.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class ContentScrollCell: BaseTableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let itemSpacing:CGFloat = 20 // item 间隔
    static let itemWidth:CGFloat = ( MGScreenWidth - 80 - 30) / 3 // item 宽度
    static let cell_img_H:CGFloat   =  ( MGScreenWidth - 80 - 30 ) / 3 // item里面img 高度
    static let cell_title_H:CGFloat = 35
    static let itemHight:CGFloat = ContentScrollCell.itemWidth * 110 / 80
    
    @IBOutlet weak var btnOn: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    
    @IBOutlet weak var heightCollectionViewLayout: NSLayoutConstraint!
    
    var dataModel: ModulesResModel? {
        didSet {
            guard let m = dataModel else {
                return
            }
            if let arr = m.contents {
                self.contentArr = arr
            }
            self.lbTitle.set_text = m.name
        }
    }
    var contentArr: [ModulesConetentModel] = [] {
        didSet {
            collectionView.reloadData()
            self.heightCollectionViewLayout.constant      = CGFloat(ContentScrollCell.itemHight)
        }
    }
    
    var resourceArr: [ResourceAllModel] = [] {
        didSet {
            collectionView.reloadData()
            self.heightCollectionViewLayout.constant      = CGFloat(ContentShowCell.itemHight)
        }
    }
    var resourceModel: ResourceAllModel? { // 图灵资源
        didSet {
            guard let m = resourceModel else {
                return
            }
            if let arr = m.categories {
                self.resourceArr = arr
            }
            self.lbTitle.set_text = m.name
        }
    }
    @IBOutlet weak var lbTitle: UILabel!
    var currentIndex: Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configCollectionView()
    }
    func configCollectionView()  {
        
        collectionView.delegate     = self
        collectionView.dataSource   = self
        collectionView.cellId_register("ContentScrollItem")
    }
    
    @IBAction func clickOnAction(_ sender: Any) {
        if currentIndex == 0 {
//            XBHud.showMsg("当前是第一步哦～")
            return
        }
        currentIndex = currentIndex - 1
        let index = IndexPath.init(row: currentIndex, section: 0)
        collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
//        print(self.configNetInfo.name,self.configNetInfo.password)
        
    }
    @IBAction func clickNextAction(_ sender: Any) {
        if currentIndex >= contentArr.count - 1 {
//            self.requestVoice()
            return
        }
        currentIndex = currentIndex + 1
        let index = IndexPath.init(row: currentIndex, section: 0)
        collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
//        print(self.configNetInfo.name,self.configNetInfo.password)
//        collectionView.setc
        print(collectionView.contentOffset)
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension ContentScrollCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentScrollItem", for: indexPath)as! ContentScrollItem
        cell.imgIcon.set_Img_Url(contentArr[indexPath.row].imgLarge)
        cell.lbTitle.set_text = contentArr[indexPath.row].name
//        cell.aspectConstraint.constant = 2/1
        let totalStr = contentArr[indexPath.row].total?.toString ?? ""
        cell.lbTotal.set_text = "共" + totalStr + "首"
        return cell
    }
    //最小item间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    //item 的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:ContentScrollCell.itemWidth,height:ContentScrollCell.itemWidth * 110 / 80)
    }
    //item 对应的点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = contentArr[indexPath.row]
        if model.albumType == 2 {
            VCRouter.toContentSubVC(clientId: XBUserManager.device_Id, albumId: model.id ?? "", navTitle: model.name)
        }else {
            VCRouter.toContentSingsVC(clientId: XBUserManager.device_Id, albumId: model.id ?? "")
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) { // 滑动结束，通过偏移量，获取当前item的位置，
        if scrollView == collectionView {
            // 获取当前偏移量
            let index = Int( scrollView.contentOffset.x / (ContentScrollCell.itemWidth + 15) ) // 每个item的 间距 = item 的宽 + item之间的间距
            print(index)

        }
    }
}
