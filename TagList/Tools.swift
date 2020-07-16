//
//  Tools.swift
//  TagList
//
//  Created by xuyazhong on 2020/7/10.
//  Copyright © 2020 xyz. All rights reserved.
//

import UIKit

let ScreenWidth: CGFloat = UIScreen.main.bounds.width
let ScreenHeight: CGFloat = UIScreen.main.bounds.height

var isFullScreen: Bool {
    if #available(iOS 11, *) {
        guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else {
            return false
        }
        
        if unwrapedWindow.safeAreaInsets.left > 0 || unwrapedWindow.safeAreaInsets.bottom > 0 {
            //                print(unwrapedWindow.safeAreaInsets)
            return true
        }
    }
    return false
}

var kNavigationBarHeight: CGFloat {
    return isFullScreen ? 88 : 64
}

extension UIView {
    func round (radius: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = radius
    }
    
    func round (radius: CGFloat, bgColor: UIColor) {
        layer.masksToBounds = true
        layer.cornerRadius = radius
        backgroundColor = bgColor
    }
    
}

extension UIColor {
    
    @objc static func colorFromHex(_ hexValue: UInt) -> UIColor {
        return colorFromHex(hexValue,alpha: 1)
    }
    
    @objc static func colorFromHex(_ hexValue: UInt,alpha:Float) -> UIColor {
        return UIColor(
            red: CGFloat((hexValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hexValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hexValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    open class func mainColor() -> UIColor {
        return UIColor.colorFromHex(0x0843d5)
    }
    
}

extension UIFont {
    open class func mainFont() -> UIFont {
        return UIFont.systemFont(ofSize: 14)
    }
}

extension String {
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont = .mainFont()) -> CGFloat {
        let textWidth = NSString(string: self).boundingRect(with: CGSize(width: CGFloat.infinity, height: height), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : font], context: nil).size.width
        return CGFloat(ceilf(Float(textWidth)))
    }
    
    func substring(beginIndex: Int = 0, toIndex: Int) -> String {
        
        let subStr = prefix(toIndex)
        return String(subStr)
        
    }
    
}

extension UITextField {
    func setPlaceholder(text: String) {
        setPlaceholder(text: text, color: .colorFromHex(0xcfcfcf))
    }

    func setPlaceholder(text: String, color: UIColor) {
        setPlaceholder(text: text, color: color, font: UIFont.mainFont())
    }
    
    func setPlaceholder(text: String, color: UIColor, font: UIFont) {
        let placeholderText = NSAttributedString(string: text, attributes: [
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.font: font
        ])
        attributedPlaceholder = placeholderText
        self.font = font
    }
}
