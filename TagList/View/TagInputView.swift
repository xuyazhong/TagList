//
//  TagInputView.swift
//  TagList
//
//  Created by xuyazhong on 2020/7/10.
//  Copyright © 2020 xyz. All rights reserved.
//

import UIKit

let kCLDashesBorderWidth: CGFloat = 0.8
let kRadius: CGFloat = 4
let lineLength: CGFloat = 4
let lineSpacing: CGFloat = 2

protocol InputTagDelegate: NSObjectProtocol {
    
    func inputAddTag(_ text: String)
    
    func inputDelTag(_ text: String)
    
    func updateFrame()
    
}

class TagInputView: UIScrollView {

    let maxLength = 10
    var tagWidth: CGFloat = 80
    var tagHeight: CGFloat = 30
    var marginLeft: CGFloat = 15
    var marginTop: CGFloat = 10
    var _rowsOfTags = 1

    var __border: CAShapeLayer?
    var __textFieldIsDeleting = false
    var tagDelegate: InputTagDelegate?
    
    lazy var inputField: TagTextField = {
        var inputField: TagTextField = TagTextField()
        inputField.round(radius: kRadius)
        inputField.delegate = self
        inputField.tagDelegate = self
        return inputField
    }()
    
    var tagCache: Dictionary<String, UIButton> = [:]
    var tagArray: [UIButton] = []
    var lastObj: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(inputField)
        inputField.frame = CGRect(x: marginLeft, y: marginTop, width: tagWidth, height: tagHeight)
        NotificationCenter.default.addObserver(self, selector: #selector(actionTextFieldEditChanged(_:)), name: NSNotification.Name(rawValue: UITextField.textDidChangeNotification.rawValue), object: inputField)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputField.becomeFirstResponder()
    }
    
}

extension TagInputView : TagTextFieldDelegate {
    
    func tagTextFieldDeleteCharacter(tagTextField: TagTextField) {
        __textFieldIsDeleting = true
        if (inputField.getValue().count == 0 && tagArray.count > 0) {
            guard let last = tagArray.last else {
                return
            }
            if last.isSelected {
                last.isSelected = false
                removeTag(last.titleLabel?.text ?? "")
            } else {
                last.isSelected = true
            }
        }
        
    }
    
}

extension TagInputView {

    /// notification
    @objc func actionTextFieldEditChanged(_ noti: NSNotification) {
        guard let textField = noti.object as? UITextField else {
            print("没有textField")
            return
        }
    
        if let _: UITextRange = textField.markedTextRange {
            /// 拼写过程中不处理
        } else {
            if textField.getValue().count > maxLength {
                print("$$$ 超了 截段 => \(textField.getValue())")
                textField.text = textField.getValue().substring(toIndex: maxLength)
            }
        }
        if (__textFieldIsDeleting) {
            __textFieldIsDeleting = false
            
            if let last = tagArray.last {
                last.isSelected = false
            }
        }
        
        /// TODO 拼音输入有问题
        
        reloadTextField(textField, allStr: textField.getValue())
        
        textFieldDashesWithTextField(textField)
        
    }

    /// 更新textField的frame
    func reloadTextField(_ textField: UITextField, allStr: String) {
        let width = allStr.width(withConstrainedHeight: 30) + tagHeight + kRadius * 2
        var rect = textField.frame
        if (width < tagWidth) {
            return
        }
        rect.size.width = width + (kRadius * 2)
        
        textField.frame = rect
        
        layoutIfNeeded()
        
        tagDelegate?.updateFrame()
    }
    
    /// 画虚线
    func textFieldDashesWithTextField(_ textField: UITextField) {
        textField.borderStyle = .none
        if let border = __border {
            border.lineWidth = kCLDashesBorderWidth
            border.path = UIBezierPath.init(roundedRect: textField.bounds, cornerRadius: kRadius).cgPath
            return
        }
        let border = CAShapeLayer()
        border.strokeColor = UIColor.mainColor().cgColor
        border.fillColor = nil
        border.path = UIBezierPath.init(roundedRect: textField.bounds, cornerRadius: textField.layer.cornerRadius).cgPath
        border.frame = textField.bounds
        border.lineWidth = kCLDashesBorderWidth
        border.lineDashPattern = [NSNumber(value: 4), NSNumber(value: 2)]
        border.lineJoin = CAShapeLayerLineJoin.round
        __border = border
        textField.layer.addSublayer(border)
    }
    
    func reloadTextFieldFrame() {
        if let last = lastObj {
            let preLeft = last.frame.maxX
            let preY = last.frame.maxY
            
            if (preLeft + marginLeft * 2 + tagWidth > frame.width) {
                inputField.frame = CGRect(x: marginLeft, y: preY + marginTop, width: tagWidth, height: tagHeight)
                _rowsOfTags += 1
            } else {
                inputField.frame = CGRect(x: preLeft + marginLeft, y: last.frame.origin.y, width: tagWidth, height: tagHeight)
            }
            var tagFrame = frame
            tagFrame.size.height = inputField.frame.maxY + marginTop
            frame = tagFrame
        } else {
            _rowsOfTags = 1
            var tagFrame = frame
            tagFrame.size.height = CGFloat(_rowsOfTags * 50)
            frame = tagFrame
            inputField.frame = CGRect(x: marginLeft, y: marginTop, width: tagWidth, height: tagHeight)
        }
        inputField.text = ""
        tagDelegate?.updateFrame()
        textFieldDashesWithTextField(inputField)
    }
    
    /// 重新设置 btn frame
    func refreshLayout() {
        var beginX: CGFloat = 0
        var beginY: CGFloat = marginTop
        _rowsOfTags = 1
        
        for idx in 0..<tagArray.count {
            let item = tagArray[idx]
            var btnFrame = item.frame
            btnFrame.origin.x = beginX + marginLeft
            btnFrame.origin.y = beginY
            if (btnFrame.maxX > frame.width) {
                btnFrame.origin.x = marginLeft
                btnFrame.origin.y = (tagHeight + marginTop) * CGFloat(_rowsOfTags) + marginTop
                beginY = btnFrame.origin.y
                _rowsOfTags += 1
            }
            item.frame = btnFrame
            beginX = btnFrame.maxX
            lastObj = item
        }
    }
    
    /// 添加tag
    func addTag(_ text: String, hasDelegate: Bool = true) {
        if (!tagCache.keys.contains(text)) {
            let tagBtn = TagButton()
            tagBtn.setTitle(text, for: .normal)
            tagCache[text] = tagBtn
            tagArray.append(tagBtn)
            
            addSubview(tagBtn)
            lastObj = tagBtn
            let calcWidth = text.width(withConstrainedHeight: tagHeight, font: .mainFont()) + marginLeft*2
            var tagFrame = inputField.frame
            tagFrame.size.width = calcWidth
            if (tagFrame.maxX > frame.width) {
                _rowsOfTags += 1
                tagFrame.origin.x = marginLeft
                tagFrame.origin.y = tagFrame.maxY + marginTop
            }
            tagBtn.frame = tagFrame
        }
        reloadTextFieldFrame()
        inputField.text = ""
        if (hasDelegate) {
            tagDelegate?.inputAddTag(text)
        }
    }
    
    /// 删除tag
    func removeTag(_ text: String, hasDelegate: Bool = true) {
        if let btn = tagCache[text] {
            tagCache.removeValue(forKey: text)
            btn.removeFromSuperview()
            if let idx = tagArray.firstIndex(of: btn) {
                tagArray.remove(at: idx)
            }
            lastObj = (tagArray.count == 0) ? nil : tagArray.last
            refreshLayout()
            reloadTextFieldFrame()
            if (hasDelegate) {
                tagDelegate?.inputDelTag(text)
            }
        }
    }
    
    /// 删除所有数据
    func reset() {
        for item in tagArray {
            item.removeFromSuperview()
        }
        tagCache.removeAll()
        tagArray.removeAll()
        lastObj = nil
        inputField.frame = CGRect(x: marginLeft, y: marginTop, width: tagWidth, height: tagHeight)
        _rowsOfTags = 1
    }
}

extension TagInputView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.getValue() == "" {
            return false
        }
        addTag(textField.getValue())
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.length == 1 && string.count == 0 {
            __textFieldIsDeleting = true
            reloadTextField(textField, allStr: textField.getValue())
            return true
        }
        if (string == " ") {
            return false
        }
        return true
    }
    
}

extension UITextField {
    func getValue() -> String {
        return text ?? ""
    }
}
