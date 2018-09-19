//
//  ContentShowThreeCell.swift
//  SmartMain
//
//  Created by mac on 2018/9/4.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class ContentShowThreeCell: BaseTableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        configCollectionView()
    }
    let itemSpacing:CGFloat = 20 // item 间隔
    let itemWidth:CGFloat = CGFloat( Int( MGScreenWidth - 20 - 20 ) / 3 )// item 宽度
    @IBOutlet weak var heightCollectionViewLayout: NSLayoutConstraint!
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
            itemCount = contentArr.count > 9 ? 9 : contentArr.count
            lineNumber = itemCount / 3
            let heightLine:CGFloat  = CGFloat((lineNumber - 1) * 20)
            self.heightCollectionViewLayout.constant      = CGFloat(lineNumber * Int(itemWidth)) + heightLine
        }
    }
    var itemCount: Int = 0
    var lineNumber: Int = 0

    @IBAction func clickMoreAction(_ sender: Any) {
                VCRouter.toContentSubVC(clientId: XBUserManager.device_Id, modouleId: dataModel?.id, navTitle: dataModel?.name)
    }
    func configCollectionView()  {
        
        collectionView.delegate     = self
        collectionView.dataSource   = self
        collectionView.cellId_register("ContentShowCVCell")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
extension ContentShowThreeCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentArr.count > (lineNumber * 3) ? lineNumber * 3 : contentArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentShowCVCell", for: indexPath)as! ContentShowCVCell
        cell.imgIcon.set_Img_Url(contentArr[indexPath.row].imgSmall)
        cell.lbTitle.set_text = contentArr[indexPath.row].name
        return cell
    }
    //最小item间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    //item 的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:itemWidth,height:itemWidth)
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
