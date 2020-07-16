//
//  TagCell.swift
//  TagList
//
//  Created by xuyazhong on 2020/7/15.
//  Copyright © 2020 xyz. All rights reserved.
//

import UIKit

class TagCell: UITableViewCell {
    
    lazy var titleLbl: UILabel = {
        var titleLbl: UILabel = UILabel()
        titleLbl.font = .mainFont()
        return titleLbl
    }()
    lazy var iconV: UIImageView = {
        var iconV: UIImageView = UIImageView()
        iconV.image = UIImage(named: "right")
        return iconV
    }()
    
    func refresh(_ model: TagData) {
        iconV.isHidden = !model.isSelected
        titleLbl.textColor = model.isSelected ? .mainColor() : .colorFromHex(0x000E33, alpha: 0.8)
        titleLbl.text = model.title
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.white
        selectionStyle = .none
        
        contentView.addSubview(titleLbl)
        contentView.addSubview(iconV)
        
        titleLbl.frame = CGRect(x: 45, y: 10, width: ScreenWidth-100, height: 30)
        
        iconV.frame = CGRect(x: ScreenWidth - 30 - 45, y: 13, width: 25, height: 25)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
