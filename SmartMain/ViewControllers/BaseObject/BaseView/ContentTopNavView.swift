//
//  ContentTopNavView.swift
//  SmartMain
//
//  Created by 陈旭 on 2018/11/20.
//  Copyright © 2018 上海际浩智能科技有限公司（InfiniSmart）. All rights reserved.
//

import UIKit
class ContentTopNavItem: UIView {
    var lbName: UILabel!
    //code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    //xib
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    func setupSubviews()  {
        lbName = UILabel.init()
        lbName.frame = self.bounds
        lbName.font = UIFont.systemFont(ofSize: 14)
        lbName.textColor = UIColor.white
        lbName.textAlignment = .center
        self.addSubview(lbName)
    }
    @IBInspectable open var title: String = "" {
        didSet {
            self.lbName.set_text = title
        }
    }
    var isSelect: Bool = false {
        didSet {
            self.stateChange(isSelect: isSelect)
        }
    }
    func stateChange(isSelect: Bool)  {
        if isSelect {
            UIView.animate(withDuration: 0.3) {
                self.lbName.transform = CGAffineTransform.identity
                    .scaledBy(x: 1.3, y: 1.3)
            }
        }else {
            UIView.animate(withDuration: 0.3) {
                self.lbName.transform = CGAffineTransform.identity
            }
        }

    }
}

class ContentTopNavView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = XBNavColor
    }
}
