//
//  TagListView.swift
//  TagList
//
//  Created by xuyazhong on 2020/7/10.
//  Copyright © 2020 xyz. All rights reserved.
//

import UIKit

protocol TagListDelegate: NSObjectProtocol {
    
    func addTag(_ model: TagData)
    
    func delTag(_ model: TagData)
    
    func didScroll()
    
}

class TagListView: UITableView {
    let cellId = "TagCellId"
    var dataArray: [TagData] = [] {
        didSet {
            reloadData()
        }
    }
    var tagDelegate: TagListDelegate?

    lazy var headerV: TagHeaderView = TagHeaderView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 50))
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        showsVerticalScrollIndicator = false
        separatorStyle = UITableViewCell.SeparatorStyle.none
        estimatedRowHeight = 0
        estimatedSectionFooterHeight = 0
        estimatedSectionHeaderHeight = 0
        register(TagCell.self, forCellReuseIdentifier: cellId)
        tableHeaderView = headerV
        delegate = self
        dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TagListView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TagCell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TagCell
        let model = dataArray[indexPath.row]
        cell.refresh(model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = dataArray[indexPath.row]
        model.isSelected = !model.isSelected
        if model.isSelected {
            tagDelegate?.addTag(model)
        } else {
            tagDelegate?.delTag(model)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}

extension TagListView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tagDelegate?.didScroll()
    }
}
