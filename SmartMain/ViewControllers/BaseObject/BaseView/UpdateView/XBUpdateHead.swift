//
//  XBUpdateHead.swift
//  XBShinkansen
//
//  Created by mike.sun on 2017/12/22.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit

class XBUpdateHead: BaseTableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLab: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setContent(model: XBUpdateVersionModel) {
        self.titleLabel.text = "版本更新至" + model.version!
        self.contentLab.text = "版本：" + model.version!
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
