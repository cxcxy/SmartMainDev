//
//  ContentHeaderCell.swift
//  SmartMain
//
//  Created by mac on 2018/9/4.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class ContentHeaderCell: BaseTableViewCell {
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.itemSize = CGSize.init(width: MGScreenWidth - 60, height: 160)
            self.pagerView.interitemSpacing = 8.0
            self.pagerView.isInfinite = true
            self.pagerView.transformer = FSPagerViewTransformer(type: FSPagerViewTransformerType.linear)
        }
    }
    
    var sourceArr: [String] = ["WechatIMG1275","WechatIMG1276","WechatIMG1277"]
    
    let itemWidth:CGFloat = ( MGScreenWidth - 20 - 30 ) / 4 // item 宽度
    @IBOutlet weak var collectionView: UICollectionView!
    var dataArr: [EquipmentModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configCollectionView()
    }
    func configCollectionView()  {
        collectionView.cellId_register("ContentTitleCVCell")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension ContentHeaderCell: FSPagerViewDataSource,FSPagerViewDelegate {
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return sourceArr.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
//        cell.imageView?.image = UIImage(named: self.imageNames[index])
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        cell.imageView?.backgroundColor = UIColor.orange
        cell.imageView?.setCornerRadius(radius: 5)
        cell.imageView?.set_img = sourceArr[index]
        return cell
    }
    
    // MARK:- FSPagerView Delegate
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {

    }
}
extension ContentHeaderCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentTitleCVCell", for: indexPath)as! ContentTitleCVCell
//        cell.imgIcon.set_Img_Url(contentArr[indexPath.row].imgSmall)
        cell.lbTitle.set_text = dataArr[indexPath.row].name
        return cell
    }
    //最小item间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    //item 的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:itemWidth,height:40)
    }
    //item 对应的点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        VCRouter.toEquipmentSubListVC(trackListId: dataArr[indexPath.row].id ?? 0,navTitle: dataArr[indexPath.row].name)
    }
}
