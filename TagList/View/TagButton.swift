//
//  TagButton.swift
//  TagList
//
//  Created by xuyazhong on 2020/7/15.
//  Copyright © 2020 xyz. All rights reserved.
//

import UIKit

class TagButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel?.font = .mainFont()
        setTitleColor(.mainColor(), for: .normal)
        setTitleColor(.white, for: .selected)
        round(radius: kRadius, bgColor: .mainColor())
        backgroundColor = .colorFromHex(0x003DDD, alpha: 0.1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? UIColor.mainColor() : .colorFromHex(0x003DDD, alpha: 0.1)
        }
    }

}
