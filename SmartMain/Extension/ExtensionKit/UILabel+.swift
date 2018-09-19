//
//  UILabel+.swift
//  XBShinkansen
//
//  Created by mac on 2018/3/8.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit
extension UITextView {
    /**
     *   设置text属性  - 增加 5 行间距
     */
    var set_text: String? {
        get {
            return self.text
        }set(value) {
            self.text = value
            // 行距
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            // 字体的行间距
            let attributes = [NSAttributedStringKey.font: self.font, NSAttributedStringKey.paragraphStyle: paragraphStyle] as [NSAttributedStringKey : Any]
            self.attributedText = NSAttributedString(string: value ?? "", attributes: attributes)
        }
    }
}
extension UILabel {
    /**
     *   设置text属性
     */
    var set_text: String? {
        get {
            return self.text
        }set(value) {
            self.text = value ?? ""
        }
    }
    /// 设置行间距
    func setLineHeightAndLineBreak(_ lineHeight: CGFloat) {

        let text = self.text ?? ""
        let paraph = NSMutableParagraphStyle()
        //将行间距设置为28
        paraph.lineSpacing      = lineHeight
        paraph.alignment        = self.textAlignment
        paraph.lineBreakMode    = self.lineBreakMode   // 使用本身类型

        //样式属性集合
        let attributes = [NSAttributedStringKey.font:UIFont.init(name: "PingFangSC-Regular", size: self.font.pointSize),
                          NSAttributedStringKey.paragraphStyle: paraph]
        self.attributedText = NSAttributedString(string: text, attributes: attributes)
        

    }
    /// 增加label 行间距为3
    func setXBLine_Style()  {
        self.setLineHeightAndLineBreak(3)
    }
    //／ 指定的范围字体加颜色
    func colorRangeWithText( _ str1:String,str2:String,str3:String = "",changeColor:UIColor,lineSpacing:Int){
        
        let  mustr1 = NSMutableAttributedString.init(string: str1 + str2 + str3)
        let strLeng = str1.characters.count
        let str1Leng = str2.characters.count
        let range = NSMakeRange(strLeng, str1Leng)
        
        if lineSpacing>0 {
            // 行距
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = CGFloat(lineSpacing)
            mustr1.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: (mustr1).length))
        }
        // 颜色
        mustr1.addAttribute(NSAttributedStringKey.foregroundColor, value: changeColor, range: range)
        self.attributedText = mustr1
        
    }
    //／ 指定的字体 str1 改变颜色字体
    func strokeWithText( _ str1:String,str2:String,str1Font:CGFloat,str1Color:UIColor,lineSpacing:Int){
        
        let  mustr1 = NSMutableAttributedString.init(string: str1 + str2)
        
        let strLeng = str1.count
        let str2Leng = str2.characters.count
        let str1Range = NSMakeRange(0, strLeng)
        if lineSpacing>0 {
            // 行距
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = CGFloat(lineSpacing)
            paragraphStyle.lineBreakMode = self.lineBreakMode   // 使用本身类型
            mustr1.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: (mustr1).length))
        }
        // 颜色
        mustr1 .addAttribute(NSAttributedStringKey.foregroundColor, value: str1Color, range: str1Range)
        // 字体
        mustr1 .addAttribute(NSAttributedStringKey.font, value:UIFont.systemFont(ofSize: str1Font), range: str1Range)
        
        self.attributedText = mustr1
        
    }
    //／ 指定的字体 str1 改变颜色字体 - 改变背景色
    func strokeBackGroundColorWithText( _ str1:String,str2:String,str1Font:CGFloat,str1Color:UIColor,str1BackGroundColor:UIColor,lineSpacing:Int){
        
        let  mustr1 = NSMutableAttributedString.init(string: str1 + str2)
        
        let strLeng = str1.count
        
        let str1Range = NSMakeRange(0, strLeng)
        if lineSpacing>0 {
            // 行距
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = CGFloat(lineSpacing)
            paragraphStyle.lineBreakMode = self.lineBreakMode   // 使用本身类型
            
            mustr1.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: (mustr1).length))
        }
        // 颜色
        mustr1 .addAttribute(NSAttributedStringKey.foregroundColor, value: str1Color, range: str1Range)
        // 字体
        mustr1 .addAttribute(NSAttributedStringKey.font, value:UIFont.systemFont(ofSize: str1Font), range: str1Range)
        // 背景色
        mustr1 .addAttribute(NSAttributedStringKey.backgroundColor, value:str1BackGroundColor, range: str1Range)
        self.attributedText = mustr1
        
    }
    //／ 指定的 str2 字体改变颜色字体
    func strokeWithAfterText( _ str1:String,str2:String,str2Font:CGFloat,str2Color:UIColor,str2BackgroundColor:UIColor,lineSpacing:Int){
        
        let  mustr1 = NSMutableAttributedString.init(string: str1 + str2)
        
        let strLeng     = str1.count
        let str2Leng    = str2.count
        
        let str1Range = NSMakeRange(strLeng, str2Leng)
        
        
        if lineSpacing>0 {
            // 行距
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = CGFloat(lineSpacing)
            paragraphStyle.lineBreakMode = self.lineBreakMode   // 使用本身类型
            mustr1.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: (mustr1).length))
        }
        // 颜色
        mustr1 .addAttribute(NSAttributedStringKey.foregroundColor, value: str2Color, range: str1Range)
        // 字体
        mustr1 .addAttribute(NSAttributedStringKey.font, value:UIFont.systemFont(ofSize: str2Font), range: str1Range)
        // 背景色
        mustr1 .addAttribute(NSAttributedStringKey.backgroundColor, value:str2BackgroundColor, range: str1Range)
        self.attributedText = mustr1
        
    }
}
