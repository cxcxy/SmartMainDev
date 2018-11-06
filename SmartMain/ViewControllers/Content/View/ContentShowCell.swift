//
//  ContentShowCell.swift
//  SmartMain
//
//  Created by mac on 2018/9/4.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
enum ResourceType {
    case zhiban
    case tuling
}
class ContentShowCell: BaseTableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var resourctType : ResourceType = .zhiban {
        didSet {
            switch resourctType {
            case .zhiban:
                btnMore.isHidden = false
                lbMore.isHidden = false
            case .tuling:
                lbMore.isHidden = true
                btnMore.isHidden = true
                break
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configCollectionView()

    }
    let itemSpacing:CGFloat = 20 // item 间隔
    static let itemWidth:CGFloat = ( MGScreenWidth - 20 * 5 ) / 4 // item 宽度
    static let cell_img_H:CGFloat   =  ( MGScreenWidth - 20 * 5 ) / 4 // item里面img 高度
    static let cell_title_H:CGFloat = 35
    static let itemHight:CGFloat = (ContentShowCell.cell_img_H + ContentShowCell.cell_title_H)

    @IBOutlet weak var heightCollectionViewLayout: NSLayoutConstraint!
    var modouleId : String?
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbMore: UILabel!
     @IBOutlet weak var btnMore: UIButton!
    var dataModel: ModulesResModel? { // 智伴资源
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
            self.heightCollectionViewLayout.constant      = CGFloat(ContentShowCell.itemHight)
        }
    }

    var resourceArr: [ResourceAllModel] = [] {
        didSet {
            collectionView.reloadData()
               self.heightCollectionViewLayout.constant      = CGFloat(ContentShowCell.itemHight * 2 + 20)
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
    
    
    func configCollectionView()  {
        self.contentView.layoutIfNeeded()
        collectionView.delegate     = self
        collectionView.dataSource   = self
        collectionView.cellId_register("TwoItemCVCell")
        collectionView.reloadData()
    }
    
    @IBAction func clickAllAction(_ sender: Any) {
        switch resourctType {
        case .zhiban:
            VCRouter.toContentSubVC(clientId: XBUserManager.device_Id, modouleId: dataModel?.id, navTitle: dataModel?.name)
        case .tuling:
            break
        }

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension ContentShowCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch resourctType {
        case .zhiban:
            return contentArr.count > 4 ? 4 : contentArr.count
        case .tuling:
            return resourceArr.count > 8 ? 8: resourceArr.count
        }

    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TwoItemCVCell", for: indexPath)as! TwoItemCVCell
        
        switch resourctType {
        case .zhiban:
            cell.imgIcon.set_Img_Url(contentArr[indexPath.row].imgLarge)
            cell.imgIcon.setCornerRadius(radius: ContentShowCell.itemWidth / 2)
            cell.lbTitle.set_text = contentArr[indexPath.row].name
            break
        case .tuling:
            cell.imgIcon.set_Img_Url(resourceArr[indexPath.row].imgLarge)
            cell.lbTitle.set_text = resourceArr[indexPath.row].name
            break
        }

        cell.aspectConstraint.constant = 2/1
        return cell
    }
    //最小item间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    //item 的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:ContentShowCell.itemWidth,height:ContentShowCell.itemHight)
    }
    //item 对应的点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        switch resourctType {
        case .zhiban:
            let model = contentArr[indexPath.row]
            if model.albumType == 2 {
                VCRouter.toContentSubVC(clientId: XBUserManager.device_Id, albumId: model.id ?? "", navTitle: model.name)
            }else {
                VCRouter.toContentSingsVC(clientId: XBUserManager.device_Id, albumId: model.id ?? "")
            }
            break
        case .tuling:
            let model = resourceArr[indexPath.row]
            if let albumId = model.id {
                VCRouter.toAlbumListVC(albumId: albumId,albumName: model.name ?? "")
            }
            
            break
        }
    }
}
