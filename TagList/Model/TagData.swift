//
//  TagData.swift
//  TagList
//
//  Created by xuyazhong on 2020/7/15.
//  Copyright © 2020 xyz. All rights reserved.
//

import UIKit

class TagData {
    
    var title: String
    var uuid: String
    var isSelected: Bool
    
    init(title: String, uuid: String, isSelected: Bool = false) {
        self.title = title
        self.uuid = uuid
        self.isSelected = isSelected
    }
    
}
