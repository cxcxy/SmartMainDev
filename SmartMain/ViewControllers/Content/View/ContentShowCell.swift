//
//  ContentShowCell.swift
//  SmartMain
//
//  Created by mac on 2018/9/4.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class ContentShowCell: BaseTableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        configCollectionView()
    }
    let itemSpacing:CGFloat = 20 // item 间隔
    static let itemWidth:CGFloat = ( MGScreenWidth - 20 - 20 ) / 2 // item 宽度
    static let cell_img_H:CGFloat   =  ( MGScreenWidth - 20 - 20 ) / 4 // item里面img 高度
    static let cell_title_H:CGFloat = 35
    static let itemHight:CGFloat = ContentShowCell.cell_img_H + ContentShowCell.cell_title_H

    @IBOutlet weak var heightCollectionViewLayout: NSLayoutConstraint!
    var modouleId : String?
    @IBOutlet weak var lbTitle: UILabel!
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
//            let heightLine:CGFloat  = contentArr.count > 2 ? 20 : 0
            self.heightCollectionViewLayout.constant      = CGFloat((contentArr.count > 2 ? 2 : 1) * ContentShowCell.itemHight)
        }
    }

    func configCollectionView()  {
        
        collectionView.delegate     = self
        collectionView.dataSource   = self
        collectionView.cellId_register("TwoItemCVCell")
    }
    
    @IBAction func clickAllAction(_ sender: Any) {
        VCRouter.toContentSubVC(clientId: XBUserManager.device_Id, modouleId: dataModel?.id, navTitle: dataModel?.name)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension ContentShowCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentArr.count > 4 ? 4 : contentArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TwoItemCVCell", for: indexPath)as! TwoItemCVCell
        cell.imgIcon.set_Img_Url(contentArr[indexPath.row].imgLarge)
        cell.lbTitle.set_text = contentArr[indexPath.row].name
        cell.aspectConstraint.constant = 2/1
        return cell
    }
    //最小item间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return XBMin
    }
    //item 的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:ContentShowCell.itemWidth,height:ContentShowCell.itemHight)
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
