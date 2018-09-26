//
//  GroupItemCell.swift
//  SmartMain
//
//  Created by mac on 2018/9/26.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class GroupItemCell: BaseTableViewCell {
    var contentArr: [String] = [] {
        didSet {
            
            let heightLine:CGFloat  = contentArr.count > 2 ? 10 : 0
            self.heightCollectionViewLayout.constant      = CGFloat((contentArr.count > 5 ? 2 : 1) * itemWidth) + heightLine
            collectionView.reloadData()
        }
    }
    
    @IBOutlet weak var lbDes: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    
    let itemSpacing:CGFloat = 20 // item 间隔
    let itemWidth:CGFloat = ( MGScreenWidth - 35 - 35 - (20 * 4) ) / 5 // item 宽度
    @IBOutlet weak var heightCollectionViewLayout: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configCollectionView()
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
extension GroupItemCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentShowCVCell", for: indexPath)as! ContentShowCVCell
        cell.imgIcon.set_img = "icon_photo"
        cell.lbTitle.font = UIFont.systemFont(ofSize: 12)
        cell.lbTitle.set_text = contentArr[indexPath.row]
        return cell
        
    }
    //最小item间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    //item 的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:itemWidth,height:itemWidth)
    }
    //item 对应的点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = contentArr[indexPath.row]
    }
}
