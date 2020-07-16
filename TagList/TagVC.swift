//
//  TagVC.swift
//  TagList
//
//  Created by xuyazhong on 2020/7/10.
//  Copyright © 2020 xyz. All rights reserved.
//

import UIKit

class TagVC: UIViewController {

    lazy var tagInputV: TagInputView = {
        var tagInputV: TagInputView = TagInputView()
        tagInputV.backgroundColor = .colorFromHex(0xf5f6fa)
        tagInputV.round(radius: 4)
        tagInputV.tagDelegate = self
        return tagInputV
    }()
    
    lazy var tagListView: TagListView = {
        var tagListView: TagListView = TagListView()
        tagListView.tagDelegate = self
        return tagListView
    }()
    var tag_list: [String] = []
    var title_list: [String] = []
    
    var dataArray: [TagData] = [
        TagData(title: "Java", uuid: "001", isSelected: true),
        TagData(title: "PHP", uuid: "002", isSelected: false),
        TagData(title: "Ruby", uuid: "003", isSelected: false),
        TagData(title: "Go", uuid: "004", isSelected: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tagInputV)
        view.addSubview(tagListView)
        
        tagInputV.frame = CGRect(x: 15, y: kNavigationBarHeight, width: ScreenWidth-30, height: 50)
        tagListView.frame = CGRect(x: 15, y: tagInputV.frame.maxY, width: ScreenWidth-30, height: ScreenHeight-kNavigationBarHeight-tagInputV.frame.height)
        tagListView.dataArray = dataArray
        for item in dataArray {
            if item.isSelected {
                tagInputV.addTag(item.title, hasDelegate: false)
            }
        }
    }

}

extension TagVC {
    
    func removeForInput(_ text: String) {
        for item in dataArray {
            if (item.title == text) {
                removeForUUID(item.uuid)
                break
            }
        }
        removeForTitle(text)
    }
    
    func removeForUUID(_ uuid: String) {
        for index in 0..<tag_list.count {
            let item = tag_list[index]
            if (item == uuid) {
                tag_list.remove(at: index)
                break
            }
        }
    }
    
    func removeForTitle(_ text: String) {
        for index in 0..<title_list.count {
            let item = title_list[index]
            if (item == text) {
                title_list.remove(at: index)
                break
            }
        }
    }
    
}

/// 输入delegate
extension TagVC: InputTagDelegate {
    func updateFrame() {
        tagListView.frame = CGRect(x: 15, y: tagInputV.frame.maxY, width: ScreenWidth-30, height: ScreenHeight-kNavigationBarHeight-tagInputV.frame.height)
    }
    
    func inputAddTag(_ text: String) {
        print("添加 \(text)")
        let tempArr = tagListView.dataArray
        var tag_uuid: String?
        for item in tempArr {
            if item.title == text {
                item.isSelected = true
                tag_uuid = item.uuid
                break
            }
        }

        if let uid = tag_uuid {
            tagListView.dataArray = tempArr
            tag_list.append(uid)
        } else {
            title_list.append(text)
        }
    }
    
    func inputDelTag(_ text: String) {
        print("删除 \(text)")
        removeForInput(text)
        
        for item in dataArray {
            if item.title == text {
                item.isSelected = false
                break
            }
        }
        tagListView.dataArray = dataArray
    }

}

/// 选择列表delegate
extension TagVC: TagListDelegate {
    func addTag(_ model: TagData) {
        tagInputV.addTag(model.title, hasDelegate: false)
        
    }
    
    func delTag(_ model: TagData) {
        tagInputV.removeTag(model.title, hasDelegate: false)
        
        removeForUUID(model.uuid)
        
        for item in dataArray {
            if item.uuid == model.uuid {
                item.isSelected = false
                break
            }
        }
        tagListView.dataArray = dataArray
    }
    
    func didScroll() {
        view.endEditing(true)
    }
    
    
}
