//
//  MemberManagerVC.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/4.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit

class MemberManagerVC: XBBaseViewController {
    var dataArr: [FamilyMemberModel] = []
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func setUI() {
        super.setUI()
        configCollectionView()
        request()
    }
    override func request() {
        super.request()
        Net.requestWithTarget(.getFamilyMemberList(deviceId: testDeviceId), successClosure: { (result, code, msg) in
            print(result)
                        if let arr = Mapper<FamilyMemberModel>().mapArray(JSONObject: JSON.init(parseJSON: result as! String).arrayObject) {
                            self.dataArr = arr
                            self.refreshStatus(status: arr.checkRefreshStatus(self.pageIndex))
                            self.collectionView.reloadData()
                        }
        })
    }
    

    func configCollectionView()  {
        collectionView.cellId_register("ContentShowCVCell")
        collectionView.dataSource = self
        collectionView.delegate = self
   
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
extension MemberManagerVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentShowCVCell", for: indexPath)as! ContentShowCVCell
                cell.imgIcon.set_Img_Url(dataArr[indexPath.row].headImgUrl)
                cell.lbTitle.set_text = dataArr[indexPath.row].nickname
        return cell
    }
    //最小item间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    //item 的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:150 ,height:150)
    }
    //item 对应的点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let model = contentArr[indexPath.row]
        //        if model.albumType == 2 {
        //            VCRouter.toContentSubVC(clientId: "3020040000000028", albumId: model.id ?? "", navTitle: model.name)
        //        }else {
        //            VCRouter.toContentSingsVC(clientId: "3020040000000028", albumId: model.id ?? "")
        //        }
    }
}
