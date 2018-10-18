//
//  XBUpdateCell.swift
//  XBShinkansen
//
//  Created by mike.sun on 2017/12/22.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit

class XBUpdateCell: BaseTableViewCell {
    @IBOutlet weak var contentLab: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setContent(content: String) {
        self.contentLab.text = content ?? ""
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
