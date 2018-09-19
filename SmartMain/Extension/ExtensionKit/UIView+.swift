//
//  UIView+.swift
//  BSMaster
//
//  Created by 陈旭 on 2017/9/29.
//  Copyright © 2017年 陈旭. All rights reserved.
//

import Foundation
extension UIView {
    //MARK: 添加顶部线条
    func addTopBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    //MARK: 添加右边线条
    func addRightBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
     //MARK: 添加底部线条
    func addBottomBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
     //MARK: 添加左边线条
    func addLeftBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    // 根据View 返回图片
    func createViewImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

//MARK: UIView Xib 扩展
extension UIView: NibLoadable {
}
protocol NibLoadable {
    
}
extension NibLoadable where Self: UIView {
    /**
     *   返回带有Xib的视图View
     */
    static func loadFromNib() -> Self{
        return Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.first as! Self
    }
}

extension UIButton {
    /**
     *   设置title属性
     */
    func set_Title(_ t:String)  {
        self.setTitle(t, for: UIControlState())
    }
}

extension UIImageView {
    /**
     *   添加UIImage对象属性
     */
    var set_img: String? {
        get {
            return ""
        }set(value) {
            guard let value = value else {
                return
            }
           self.image = UIImage.init(named: value)
        }
    }
    
}
extension UITextView {
 
    func add_Border() {
//        self.addBorder(width: 1, color: MGRgb(210, g: 210, b: 210).withAlphaComponent(0.5))
    }
    
}
extension UIDevice {
    public static func isX() -> Bool {
        if UIScreen.main.bounds.height == 812 {
            return true
        }
        
        return false
    }
}
