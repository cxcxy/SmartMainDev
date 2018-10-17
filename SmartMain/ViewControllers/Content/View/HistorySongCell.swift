//
//  HistorySongCell.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/9/25.
//  Copyright © 2018年 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
enum SongsIconType {
    case songList_play
    case songList_pause
    case likeList
}
class HistorySongCell: BaseTableViewCell {
//    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var btnExtension: UIButton!
    var iconType: SongsIconType = .likeList {
        didSet {
            switch iconType {
            case .songList_play:
                imgIcon.set_img = "icon_list_play"
                break
            case .songList_pause:
                imgIcon.set_img = "icon_list_pause"
                break
            case .likeList:
                imgIcon.set_img = "icon_play_song"
                break
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
