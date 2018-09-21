//
//  CollapsibleTableViewHeader.swift
//  ios-swift-collapsible-table-section
//
//  Created by Yong Su on 5/30/16.
//  Copyright © 2016 Yong Su. All rights reserved.
//

import UIKit

protocol SMAllClassViewHeaderDelegate: class {
    func toggleSection(_ header: SMAllClassViewHeader, section: Int)
}

class SMAllClassViewHeader: UITableViewHeaderFooterView {
    
    weak var delegate: SMAllClassViewHeaderDelegate?
    var section: Int = 0
    
    
    let titleLabel = UILabel()
    let arrowLabel = UILabel()
    let imgBanner  = UIImageView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = MGRgb(227, g: 244, b: 218)
        contentView.addSubview(titleLabel)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SMAllClassViewHeader.tapHeader(_:))))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.snp.makeConstraints { [weak self](make) in
            if let strongSelf = self {
                make.height.equalTo(30)
                make.top.equalTo(strongSelf)
                make.left.equalTo(15)
                make.right.equalTo(-15)
            }
        }

    }

    @objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? SMAllClassViewHeader else {
            return
        }
        
        delegate?.toggleSection(self, section: cell.section)
    }
    
      
}
