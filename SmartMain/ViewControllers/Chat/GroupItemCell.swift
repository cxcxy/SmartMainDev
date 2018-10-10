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
            self.heightCollectionViewLayout.constant      = CGFloat((contentArr.count > 5 ? 2 : 1) * 92) + heightLine
            collectionView.reloadData()
        }
    }
    
    var groupId: String!
    var groupOwner: Bool  = false
    var ownerPhone : String = ""
    @IBOutlet weak var lbDes: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    
//    let itemSpacing:CGFloat = 20 // item 间隔
    let itemSpacing:CGFloat = ( MGScreenWidth - 35 - 35 - (56 * 5) ) / 4 // item 宽度
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
        collectionView.cellId_register("XBAddContactCell")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func requestDelMember()  {
        var params_task = [String: Any]()
        params_task["username"]     = XBUserManager.userName
        params_task["deviceid"]     = XBUserManager.device_Id
        params_task["easeadmin"]    = groupOwner
        params_task["groupid"]      = groupId
        Net.requestWithTarget(.quitGroup(byAdmin: false, req: params_task), successClosure: { (result, code, message) in
            if let str = result as? String {
                print(str)
//                XBHud.showMsg("退出成功")
            }
        })
    }
}
extension GroupItemCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "XBAddContactCell", for: indexPath)as! XBAddContactCell
        cell.imgView.set_img = "icon_photo"
        cell.titleLab.font = UIFont.systemFont(ofSize: 8)
        
        let name = contentArr[indexPath.row]
        cell.titleLab.set_text = name
//        if 
//        cell.titleLab.set_text = contentArr[indexPath.row]
        if self.groupOwner { // 当前为该群组管理员
            if name == ownerPhone { // 当前显示的是自己
                cell.imgDelete.isHidden = true
            }else {
                cell.imgDelete.isHidden = false
            }
        }else {
             cell.imgDelete.isHidden = true
        }

        cell.imgDelete.addTapGesture {[weak self] (sender) in
            guard let `self` = self else { return }
            self.requestDelMember()
        }
        return cell
        
    }
    //最小item间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    //item 的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:60,height:92)
    }
    //item 对应的点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = contentArr[indexPath.row]
    }
}
