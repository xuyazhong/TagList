//
//  TagHeaderView.swift
//  TagList
//
//  Created by xuyazhong on 2020/7/15.
//  Copyright © 2020 xyz. All rights reserved.
//

import UIKit

class TagHeaderView: UIView {

    lazy var iconV: UIImageView = {
        var iconV: UIImageView = UIImageView()
        iconV.image = UIImage(named: "tag")
        return iconV
    }()
    lazy var titleLbl: UILabel = {
        var titleLbl: UILabel = UILabel()
        titleLbl.font = UIFont.boldSystemFont(ofSize: 18)
        titleLbl.text = "我的标签"
        return titleLbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(iconV)
        addSubview(titleLbl)
        
        iconV.frame = CGRect(x: 15, y: 13, width: 24, height: 24)
        titleLbl.frame = CGRect(x: 44, y: 10, width: frame.width-40-24, height: 30)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
