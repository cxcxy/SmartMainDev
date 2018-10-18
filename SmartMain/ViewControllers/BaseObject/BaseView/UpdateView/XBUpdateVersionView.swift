//
//  XBUpdateVersionView.swift
//  XBShinkansen
//
//  Created by mac on 2017/12/21.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit

class XBUpdateVersionView: ETPopupView,UITableViewDelegate,UITableViewDataSource {
    //var updateContent:[String] = ["1.需要更新","2.需要更新","3.需要更新"]
    var clickActionTouchBlock: ((_ type: String) -> Void)? = nil

    var updateContent:[String] = []
    var versionType: XBUpdateVersionType?
    var versionModel: XBUpdateVersionModel?
    //@IBOutlet weak var bottomView1: UIStackView!
    //@IBOutlet weak var bottomView2: UIButton!
    
    @IBOutlet weak var bottomCancel: UIButton!
    @IBOutlet weak var bottomSure: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightAllLayout: NSLayoutConstraint!
    override func awakeFromNib() {
        animationDuration = 0.3
        type = .custom
        self.snp.makeConstraints { (make) in
            make.width.equalTo(MGScreenWidth - 33*2)
        }

        self.tableView.cellId_register("XBUpdateHead")
        self.tableView.cellId_register("XBUpdateCell")

        self.tableView.rowHeight          = UITableViewAutomaticDimension
        self.tableView.delegate           = self
        self.tableView.dataSource         = self
        self.tableView.estimatedRowHeight = 50
        self.layoutIfNeeded()
    }
    func initOrigin() {
        updateContent = versionModel?.remark ?? []
        if versionModel?.isupdate != 1 {
            //非强制
            bottomCancel.isHidden = false
            bottomSure.isHidden = false
        }else {
            //强制
            bottomCancel.isHidden = true
            bottomSure.isHidden = false
        }
        self.tableView .reloadData()
    }
    override func layoutSubviews() {
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
        if self.tableView.contentSize.height < MGScreenHeight-51-48-44 {
            heightAllLayout.constant = self.tableView.contentSize.height
            self.tableView.bounces = false
        }else {
            heightAllLayout.constant = MGScreenHeight-51-48-44
            self.tableView.bounces = true
        }
        heightAllLayout.constant = (self.tableView.contentSize.height < MGScreenHeight-51-48-44) ? self.tableView.contentSize.height:MGScreenHeight-51-48-44
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "XBUpdateHead", for: indexPath) as! XBUpdateHead
            if versionModel != nil {
                cell.setContent(model: versionModel!)
            }

            tableView.separatorStyle       = .none
            cell.selectionStyle             = .none
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "XBUpdateCell", for: indexPath) as! XBUpdateCell
        cell.setContent(content: XBUtil.jointImgStr(imgArray: updateContent, spaceStr: "\n"))

        tableView.separatorStyle       = .none
        cell.selectionStyle             = .none
        
        return cell
    }
    
    @IBAction func clickCancelAction(_ sender: Any) {
        self.hide()
    }
    
    @IBAction func clickContinueAction(_ sender: Any) {
        if versionModel?.isupdate != 1 {
            self.hide()
        }
        if (clickActionTouchBlock != nil) {
            clickActionTouchBlock!("update")
        }
    }
}
