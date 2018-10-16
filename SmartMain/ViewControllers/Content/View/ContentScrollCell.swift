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
    @IBOutlet weak var lbTitle: UILabel!
    var contentArr: [ModulesConetentModel] = [] {
        didSet {
            collectionView.reloadData()
            self.heightCollectionViewLayout.constant      = CGFloat(ContentScrollCell.itemHight)
        }
    }
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
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension ContentScrollCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentArr.count > 4 ? 4 : contentArr.count
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
}
