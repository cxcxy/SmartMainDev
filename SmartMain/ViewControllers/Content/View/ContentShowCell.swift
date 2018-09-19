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
    let itemWidth:CGFloat = ( MGScreenWidth - 20 - 20 ) / 2 // item 宽度
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
            let heightLine:CGFloat  = contentArr.count > 2 ? 20 : 0
            self.heightCollectionViewLayout.constant      = CGFloat((contentArr.count > 2 ? 2 : 1) * itemWidth) + heightLine
        }
    }

    func configCollectionView()  {
        
        collectionView.delegate     = self
        collectionView.dataSource   = self
        collectionView.cellId_register("ContentShowCVCell")
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
