//
//  String+.swift
//  XBPMDev
//
//  Created by mac on 2018/4/2.
//  Copyright © 2018年 mac-cx. All rights reserved.
//

import UIKit
extension Int {
    func mapPercentage() -> Int {
        let i  = ( self.toFloat / 40 ) * 100
        return Int(i)
    }
}
extension String {
    func filterWhitespaces() -> String {
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        let phone_str_arr = self.components(separatedBy: whitespace)
        let phont_str_item_arr = phone_str_arr.filter({ (str) -> Bool in
            return str != ""
        })
        let phoneStr    = XBUtil.jointImgStr(imgArray: phont_str_item_arr, spaceStr: "")
        
        let phone_Str    = XBUtil.filterPhoneNumber(phoneStr)
        return phone_Str
    }
    //将原始的url编码为合法的url  处理URL中的中文问题
    func urlEncodedNew() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? self
    }
    //将编码后的url转换回原始的url
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
    /**
     替换手机号中间四位为“****”
     */
//    mutating func get_formted_xxPhone() ->  String{
//        
//        //开始字符索引
//        let startIndex = self.characters.index(self.startIndex, offsetBy: 3)
//        //结束字符索引
//        let endIndex = self.characters.index(self.startIndex, offsetBy: 7)
//        let range = Range<String.Index>(startIndex..<endIndex)
//        var s = String()
//        for _ in 0..<7 - 3{
//            s += "*"
//        }
//        return self.replacingCharacters(in: range, with: s)
//    }
    /**
     *   判断显示当天的时间，还是之前的日子
     */
    var isTimerStr: String? {
        get {
            let datefmatter = DateFormatter()
            datefmatter.dateFormat="yyyy-MM-dd HH:mm:ss"
            if let date = datefmatter.date(from: self) {
                let dateStamp:TimeInterval = date.timeIntervalSince1970
                let dateStr:Int = Int(dateStamp)
                if dateStr.isYear {
                    if dateStr.isToday {
                        return dateStr.formartHHMM()
                    }else {
                        return dateStr.formartMMdd()
                    }
                }else {
                    return dateStr.formartyyyyMMdd()
                }
                
            }else {
                return self
            }
            
        }
    }
    /**
     *   判断密码是否符合 6-12位的规则
     */
    var isPasswordSure: Bool {
        get {
            if !(self.length <= 12 && self.length >= 6) {
                return false
            }else {
                return true
            }
        }
    }
    func AddZero() -> String{
        if self.length == 1 {
            return "0" + self
        }else{
            return self
        }
    }
    /**
     *   判断验证码是否符合 6位的规则
     */
    var isCodeSure: Bool {
        get {
            if self.length == 0 {
                XBHud.showWarnMsg("请输入验证码")
                return false
            }
            if self.length != 6 {
                XBHud.showWarnMsg("请输入6位验证码")
                return false
            }
            return true
            
        }
    }
    /**
     *   判断字符串是否是 x 位
     */
    func isStrLeng(_ leng: Int) -> Bool {
        if self.length > leng {
            return true
        }else {
            return false
        }
    }
    /// 身份证正则
    ///
    /// - Returns: true or false
    /// 身份证号的需求给出的是最后一位可以为大写的X英文字母，但是我发现即使改变options：的值，也没有区分，所以做了一个小写x返回false的判断。
    func IsLegalForIDCardNumber()->Bool{
        
        let pattern = "(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
//        let isMatch:Bool = pred.evaluateWithObject(idCard)
        let isMatch:Bool = pred.evaluate(with: self)
        return isMatch;
        
    }
    func validateMobile() -> Bool {
        // 手机号以 13 14 15 18 开头   八个 \d 数字字符
        let phoneRegex = "^((13[0-9])|(17[0-9])|(14[^4,\\D])|(15[^4,\\D])|(18[0-9]))\\d{8}$|^1(7[0-9])\\d{8}$";
        let phoneTest = NSPredicate(format: "SELF MATCHES %@" , phoneRegex)
        return (phoneTest.evaluate(with: self));
    }
    /**
     *   格式化地址， 比如 北京市-北京市-朝阳区   -->  北京市朝阳区
     */
    func formatAddressArea() -> String {
        let areaArr = self.components(separatedBy: "-")
        if areaArr.count == 3 {
            let areaStr1 = areaArr[0]
            let areaStr2 = areaArr[1]
            let areaStr3 = areaArr[2]
            if areaStr1 == areaStr2 {
                return areaStr1 +  areaArr[2]
            }else {
                return areaStr1 + areaStr2 + areaStr3
            }
        }else {
            return self.replace(target: "-", withString: "")
        }
    }
    /**
     *   格式化展示地址方式， 
     */
    func formatShowAddressArea() -> String {
        let areaArr = self.components(separatedBy: "-")
        if areaArr.count == 3 {
            let areaStr1 = areaArr[0]
            let areaStr2 = areaArr[1]
            let areaStr3 = areaArr[2]
            if areaStr3 != "其他" {
                return areaStr3
            }else if areaStr2 != "其他" {
                return areaStr2
            }else {
                return areaStr1
            }
        }else {
            return self.replace(target: "-", withString: "")
        }
    }
    /**
     计算高度的，根据宽度计算  带换行的
     
     - parameter width:
     - parameter font:
     
     - returns:
     */
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont, lineSpace: CGFloat) -> CGFloat {
        let attributeString = NSMutableAttributedString.init(string: self)
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = lineSpace

        attributeString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, self.characters.count))
        attributeString.addAttribute(NSAttributedStringKey.font, value: font, range: NSMakeRange(0, self.characters.count))
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = attributeString.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        
        return boundingBox.height
    }
}
extension String{
    /**
     *   替换字符串里面的 字符
     */
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    /**
     *   判断是否为"" 或者是否为nil
     */
    var isNone: Bool {
        get {
            return self == "" ? true : false
        }
    }

}

extension String {
    /**
     *   末尾是否包含 关键字
     */
    func isEndInclude(_ key:String) -> Bool {
        if self.lowercased().hasSuffix(key) {
            return true
        }else {
            return false
        }
    }
    /**
     *   末尾是否包含 关键字
     */
    func isFirstInclude(_ key:String) -> Bool {
        if self.lowercased().hasPrefix(key) {
            return true
        }else {
            return false
        }
    }
}
public extension Int{
    
    public var w_scale : CGFloat
    {
        let screen_w = UIScreen.main.bounds.width
        let design_w = CGFloat(375)
        let scale_x  = CGFloat(self) * screen_w / design_w
        return scale_x
    }
    
    public var h_scale : CGFloat{
        
        let screen_h = UIScreen.main.bounds.height
        let design_h = CGFloat(667)
        let scale_y  = CGFloat(self) * screen_h / design_h
        return scale_y
    }
    
}
