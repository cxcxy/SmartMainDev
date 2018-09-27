//
//  EquipmentListViewController.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/27.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class EquipmentListViewController: XBBaseViewController {
    let itemSpacing:CGFloat = 20 // item 间隔
    let itemWidth:CGFloat = ( MGScreenWidth - 20 - 20 ) / 2 // item 宽度
    @IBOutlet weak var collectionView: UICollectionView!
    var dataArr : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setUI() {
        super.setUI()
        title = "选择设备"
        request()
    }
    override func request() {
        super.request()
        Net.requestWithTarget(.getDeviceIds(userName: XBUserManager.userName), successClosure: { (result, code, message) in
//            if let str = result as? String {
//                if str == "ok" {
//                    print("修改成功")
//                    XBHud.showMsg("修改成功")
//                }else {
//                    XBHud.showMsg("修改失败")
//                }
//            }
            print(result)
        })
    }
    func configCollectionView()  {
        
        collectionView.delegate     = self
        collectionView.dataSource   = self
        collectionView.cellId_register("ContentShowCVCell")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension EquipmentListViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentShowCVCell", for: indexPath)as! ContentShowCVCell
//        cell.imgIcon.set_Img_Url(contentArr[indexPath.row].imgSmall)
//        cell.lbTitle.set_text = contentArr[indexPath.row].name
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
  
    }
}
