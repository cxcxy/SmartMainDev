//
//  BSUtil.swift
//  BSMaster
//
//  Created by 陈旭 on 2017/9/29.
//  Copyright © 2017年 陈旭. All rights reserved.
//

import Foundation
import SystemConfiguration
import SystemConfiguration.CaptiveNetwork
public class XBUtil {
    /// 拨打电话
    static func callPhone(_ phone:String){
        let web = UIWebView()
        let tel = URL(string: "tel:\(phone)")
        if let tel = tel {
            web.loadRequest(URLRequest(url: tel))
            UIApplication.currentViewController()?.view.addSubview(web)
        }
    }
    
    class func getHermesConfiguration(_ withName:String) -> String {
        return ConfigManager.getConfigInfo(withName)
    }
    
    /// 获取时间戳， 默认为秒为单位， isSeconds = false 时，为毫秒单位
    static func getCurrentTimerInterval(_ isSeconds:Bool = true) -> TimeInterval {
        let date = Date.init(timeIntervalSinceNow: 0)
        let time = date.timeIntervalSince1970 * (isSeconds ? 1 : 1000)   //以秒为单位
        return time
    }
    
    static func getDateWithTimer(_ dateStr: String) -> Int? {
        let datefmatter = DateFormatter()
        datefmatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        if let date = datefmatter.date(from: dateStr) {
            let dateStamp:TimeInterval = date.timeIntervalSince1970
            let dateStr:Int = Int(dateStamp)
            return dateStr
        }else {
            return nil
        }
    }
    // MARK: - 时间戳-时间字符串(特定)
    public class func timestampToDateStr(_ timestamp: Int, dateFormat: String?) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat ?? ""
        let confromTimesp = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let resultDateStr = formatter.string(from: confromTimesp)
        return resultDateStr
    }
    // MARK: - 输入时间字符串(特定)-输出时间字符串(特定)
    public class func dateStringToString(_ dateStr: String?, inputFormatter formatter1: String?, outFormatter formatter2: String?) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = formatter1 ?? ""
        let formatterDate: Date? = inputFormatter.date(from: dateStr ?? "")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = formatter2 ?? ""
        var outputDateStr: String? = nil
        if let aDate = formatterDate {
            outputDateStr = outputFormatter.string(from: aDate)
        }
        return outputDateStr
    }
    // MARK: - 输入时间-输出时间字符串(特定)
    class func dateToStringDate(_ date: Date?, dateFormat: String?) -> String? {
        var resultDateStr: String?
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat ?? ""
        if let date = date {
            resultDateStr = formatter.string(from: date)
        }
        return resultDateStr
    }
    // MARK: - 输入时间(特定)-输出时间(特定)
    public class func dateToDate(_ date: Date?, dateFormat: String?) -> Date? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = dateFormat ?? ""
        var formatterStr: String?
        if let date = date {
            formatterStr = inputFormatter.string(from: date)
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = dateFormat ?? ""
        var outputDate: Date?
        outputDate = outputFormatter.date(from: formatterStr ?? "")

        return outputDate
    }
    // MARK: - 输入时间字符串(特定)-输出时间
    class func stringDateToDate(_ dateStr: String?, dateFormat: String?) -> Date? {
        var resultDate: Date?
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat ?? ""
        resultDate = formatter.date(from: dateStr ?? "")
        return resultDate
    }
    
    // MARK: - 比较时间前后
    public class func compareOneDay(_ oneDay: String?, withAnotherDay another: String?, formatter: String?) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter ?? ""
        let dateA: Date? = dateFormatter.date(from: oneDay ?? "")
        let dateB: Date? = dateFormatter.date(from: another ?? "")
        var result: ComparisonResult? = nil
        if let aB = dateB {
            result = dateA?.compare(aB)
        }
        if result == .orderedDescending {
            //过期
            return 1
        } else if result == .orderedAscending {
            //未过期
            return -1
        }
        return 0
    }

    public class func currentTopViewController() -> UIViewController {
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        return currentTopViewController(rootViewController: rootViewController!)
    }
    /// - Returns: 当前手机链接的wifi名称
    public class func getUsedSSID() -> String {
        let interfaces = CNCopySupportedInterfaces()
        var ssid = ""
        if interfaces != nil {
            let interfacesArray = CFBridgingRetain(interfaces) as! Array<AnyObject>
            if interfacesArray.count > 0 {
                let interfaceName = interfacesArray[0] as! CFString
                let ussafeInterfaceData = CNCopyCurrentNetworkInfo(interfaceName)
                if (ussafeInterfaceData != nil) {
                    let interfaceData = ussafeInterfaceData as! Dictionary<String, Any>
                    ssid = interfaceData["SSID"]! as! String
                }
            }
        }
        return ssid
    }
    public class func currentTopViewController(rootViewController: UIViewController) -> UIViewController {
        if (rootViewController.isKind(of: UITabBarController.self)) {
            let tabBarController = rootViewController as! UITabBarController
            return currentTopViewController(rootViewController: tabBarController.selectedViewController!)
        }
        
        if (rootViewController.isKind(of: UINavigationController.self)) {
            let navigationController = rootViewController as! UINavigationController
            return currentTopViewController(rootViewController: navigationController.visibleViewController!)
        }
        
        if ((rootViewController.presentedViewController) != nil) {
            return currentTopViewController(rootViewController: rootViewController.presentedViewController!)
        }
        return rootViewController
    }
 

    //／ 获取 当前字符串 占多少位字节
    static func numberOfChars(_ str: String) -> String {
        var number  = 0
        var index:Int? = nil
        guard str.characters.count > 0 else {return ""}
        for i in 0...str.characters.count - 1 {
            
            let c: unichar = (str as NSString).character(at: i)
            if (c >= 0x4E00) {
                number += 2
            }else {
                number += 1
            }
            if number > 12 {
                index = i
                break
            }
        }
        if let index = index {
            return (str as NSString).substring(to: index)
        }else {
            return str
        }
    }
    // 复制当前字符串
    public class  func copyStr(_ str:String?)  {
        guard let str = str else {
            return
        }
        let pasteboard = UIPasteboard.general
        pasteboard.string = str
        XBHud.showMsg("复制成功")
    }

    // MARK: - 把秒数转换成时分秒（00小时00分00秒）格式
    ///
    /// - Parameter time: time(Int格式)
    /// - Returns: String格式(00:00:00)
    static func getDetailTimeWithTimestamp(timeStamp: Int?,formatTypeText: Bool = true) -> String  {
        guard let time = timeStamp else {
            return ""
        }
        var house_text:String = "小时"
        var minute_text:String = "分"
        var second_text:String = "秒"
        if formatTypeText == false {
            house_text = ":"
            minute_text = ":"
            second_text = ""
        }
        let ms = time
        let ss = 1
        let mi = ss * 60
        let hh = mi * 60
        let dd = hh * 24
        let day = ms / dd
        
        let hour = (ms - day * dd) / hh
        let minute = (ms - day * dd - hour * hh) / mi
        let second = (ms - day * dd - hour * hh - minute * mi) / ss
        
        var timerStr = String(hour).AddZero() + house_text + String(minute).AddZero() + minute_text
        
        if hour == 0 {
//            if minute == 0 {
//                timerStr = String(second).AddZero() + second_text
//            }else {
                timerStr = String(minute).AddZero() + minute_text + String(second).AddZero() + second_text
//            }
           
        } else {
            timerStr = String(hour).AddZero() + house_text + String(minute).AddZero() + minute_text + String(second).AddZero() + second_text
        }
        return timerStr
        
    }
}

public extension UIDevice {
    /**
     *   获取当前手机型号
     */
    var model_Name: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod1,1":  return "iPod Touch 1"
        case "iPod2,1":  return "iPod Touch 2"
        case "iPod3,1":  return "iPod Touch 3"
        case "iPod4,1":  return "iPod Touch 4"
        case "iPod5,1":  return "iPod Touch (5 Gen)"
        case "iPod7,1":   return "iPod Touch 6"
            
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":  return "iPhone 4"
        case "iPhone4,1":  return "iPhone 4s"
        case "iPhone5,1":   return "iPhone 5"
        case  "iPhone5,2":  return "iPhone 5 (GSM+CDMA)"
        case "iPhone5,3":  return "iPhone 5c (GSM)"
        case "iPhone5,4":  return "iPhone 5c (GSM+CDMA)"
        case "iPhone6,1":  return "iPhone 5s (GSM)"
        case "iPhone6,2":  return "iPhone 5s (GSM+CDMA)"
        case "iPhone7,2":  return "iPhone 6"
        case "iPhone7,1":  return "iPhone 6 Plus"
        case "iPhone8,1":  return "iPhone 6s"
        case "iPhone8,2":  return "iPhone 6s Plus"
        case "iPhone8,4":  return "iPhone SE"
        case "iPhone9,1":   return "国行、日版、港行iPhone 7"
        case "iPhone9,2":  return "港行、国行iPhone 7 Plus"
        case "iPhone9,3":  return "美版、台版iPhone 7"
        case "iPhone9,4":  return "美版、台版iPhone 7 Plus"
        case "iPhone10,1","iPhone10,4":   return "iPhone 8"
        case "iPhone10,2","iPhone10,5":   return "iPhone 8 Plus"
        case "iPhone10,3","iPhone10,6":   return "iPhone X"
            
        case "iPad1,1":   return "iPad"
        case "iPad1,2":   return "iPad 3G"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":   return "iPad 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":  return "iPad Mini"
        case "iPad3,1", "iPad3,2", "iPad3,3":  return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":   return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":   return "iPad Air"
        case "iPad4,4", "iPad4,5", "iPad4,6":  return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":  return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":  return "iPad Mini 4"
        case "iPad5,3", "iPad5,4":   return "iPad Air 2"
        case "iPad6,3", "iPad6,4":  return "iPad Pro 9.7"
        case "iPad6,7", "iPad6,8":  return "iPad Pro 12.9"
        case "AppleTV2,1":  return "Apple TV 2"
        case "AppleTV3,1","AppleTV3,2":  return "Apple TV 3"
        case "AppleTV5,3":   return "Apple TV 4"
        case "i386", "x86_64":   return "Simulator"
        default:  return identifier
        }
    }
}
import Foundation
import RxSwift
import ObjectiveC

public extension NSObject {
    fileprivate struct AssociatedKeys {
        static var DisposeBag = "rx_disposeBag"
    }
    
    fileprivate func doLocked(_ closure: () -> Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        closure()
    }
    
    var rx_disposeBag: DisposeBag {
        get {
            var disposeBag: DisposeBag!
            doLocked {
                let lookup = objc_getAssociatedObject(self, &AssociatedKeys.DisposeBag) as? DisposeBag
                if let lookup = lookup {
                    disposeBag = lookup
                } else {
                    let newDisposeBag = DisposeBag()
                    self.rx_disposeBag = newDisposeBag
                    disposeBag = newDisposeBag
                }
            }
            return disposeBag
        }
        
        set {
            doLocked {
                objc_setAssociatedObject(self, &AssociatedKeys.DisposeBag, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}

public extension Reactive where Base: NSObject {
    var disposeBag: DisposeBag {
        get { return base.rx_disposeBag }
        set { base.rx_disposeBag = newValue }
    }
}
