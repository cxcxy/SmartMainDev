

import UIKit
let launchTime: Double = 3.0  // 倒计时时间
class XBLaunchView: UIView {
//    var centeViewModel = CenterViewModel()

    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var timeButton: UIButton!
    var isRemove = false
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        startTime()
        XBDelay.start(delay: launchTime) { [weak self] in
            if let strongSelf = self {
                if !strongSelf.isRemove {
                    strongSelf.removeView()
                }
            }
        }
    }
    //MARK: 开始倒计时
    func startTime() {
        self.timeButton.startTimer(Int(launchTime) + 1,
                                   title: "跳过",
                                   mainBGColor: UIColor.clear,
                                   mainTitleColor: MGRgb(128, g: 128, b: 128),
                                   countBGColor: UIColor.clear,
                                   countTitleColor: MGRgb(128, g: 128, b: 128),
                                   isEnabled: true,
                                   handle: nil)

    }
    override func removeFromSuperview() {
        UIView.animate(withDuration: 1, animations: {
            self.alpha = 0
        }, completion: { (finished: Bool) in
            super.removeFromSuperview()
        })
    }

    @IBAction func clickTimeAction(_ sender: Any) {
         self.removeView()
        
    }
    //MARK: 移除试图
    func removeView() {
        isRemove = true
//        self.requestCheakVersion()
        self.requestVoucherUnnoticed()
        self.removeFromSuperview()
    }

    // 检查更新 接口
    func requestCheakVersion() {
//        XBUpdateVersionManager.checkUpdateVersion { (versionType,versionModel) in
//
//            guard let iosUrl = versionModel.iosurl else {
//                return
//            }
//            guard let urlString = URL.init(string: iosUrl) else{
//                return
//            }
//            if versionType == .oldVersion {
//                let v = XBUpdateVersionView.loadFromNib()
//                v.versionType   = versionType
//                v.versionModel  = versionModel
//                v.initOrigin()
//                v.clickActionTouchBlock = {(_ type: String) -> Void in
//                    if (type == "update") {
//
//                        UIApplication.shared.openURL(urlString)
//
//                    }
//                }
//                v.show()
//            }
//        }
    }
    // 检查未读 接口
    func requestVoucherUnnoticed() {
//        if XBUserManager.userid.toString.length > 0 {
//            let req_model = RelationCompListReqModel()
//            req_model.accountId = XBUserManager.accountId
//            
//            centeViewModel.requestVoucherUnnoticed(m: req_model) {/*[weak self]*/ (arr, totalAmount, status) in
//                //guard let `self` = self else { return }
//                
//                if arr.count == 0 {
//                    return
//                }
//                //弹出未通知的体验券页面
//                let add_view = XBCouponPopView.loadFromNib()
//                add_view.unnoticedVouListArr = arr
//                add_view.totalAmount = totalAmount.doubleValue
//                add_view.updateAmount()
//                //        add_view.frame = CGRect(x: (MGScreenHeight - 360)*(125.0/(125.0 + 182.0)),
//                //                                y: MGScreenWidthHalf,
//                //                                width: 261,
//                //                                height: 462)
//                add_view.sureBlock = {
//                }
//                add_view.show()
//            }
//        }
    }
}
