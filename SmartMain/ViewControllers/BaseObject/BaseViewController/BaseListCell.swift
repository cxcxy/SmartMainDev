//
//  BaseListCell.swift
//  SmartMain
//
//  Created by mac on 2018/11/27.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
protocol BaseListCellDelegate: class {
    func clickItemMoreAction(trackId: Int,duration: Int?, title: String?,indexPathRow: Int)
}
class BaseListCell: BaseTableViewCell {
    var indexPathRow: Int!
    
    @IBOutlet weak var btnSelect: UIButton!
    
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbLineNumber: UILabel!
    @IBOutlet weak var iconPlaying: UIImageView!
    @IBOutlet weak var btnMore: UIButton!
    weak var delegate: BaseListCellDelegate?
    var modelData: BaseListItem? {
        didSet {
            guard let model = modelData else {
                return
            }
            lbTitle.set_text = model.title
            lbTime.set_text =  XBUtil.getDetailTimeWithTimestamp(timeStamp: model.time)
            iconPlaying.isHidden = !model.isPlay
//             btnSelect.isSelect = item.
            if isEdit {
                btnSelect.isSelected = model.isSelect
            }
            
        }
    }
    var isEdit: Bool = false {
        didSet {
//            self.tableView.reloadData()
            lbLineNumber.isHidden = isEdit
            btnSelect.isHidden = !isEdit
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnMore.isHidden = true
        btnSelect.isHidden = true
    }
    @IBAction func clickMoreAction(_ sender: Any) {
        if let del = self.delegate, let trackId =  modelData?.trackId{
            del.clickItemMoreAction(trackId: trackId, duration: modelData?.time, title: modelData?.title,indexPathRow: self.indexPathRow)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
