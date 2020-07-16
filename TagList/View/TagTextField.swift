//
//  TagTextField.swift
//  TagList
//
//  Created by xuyazhong on 2020/7/10.
//  Copyright © 2020 xyz. All rights reserved.
//

import UIKit

protocol TagTextFieldDelegate : NSObjectProtocol {
    
    func tagTextFieldDeleteCharacter(tagTextField: TagTextField)
    
}

class TagTextField: UITextField {

    var tagDelegate: TagTextFieldDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        font = .mainFont()
        backgroundColor = .white
        autocorrectionType = .no
        returnKeyType = .done
        textColor = .mainColor()
        setPlaceholder(text: "输入标签", color: .black)
        borderStyle = .none
        contentVerticalAlignment = .center
        clearButtonMode = .never
        sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func deleteBackward() {
        
        tagDelegate?.tagTextFieldDeleteCharacter(tagTextField: self)
        
        super.deleteBackward()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = bounds
        newBounds.origin.x += kRadius*2
        newBounds.size.width -= kRadius*2
        return newBounds
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = bounds
        newBounds.origin.x += kRadius*2
        newBounds.size.width -= kRadius*2
        return newBounds
    }
    
}
