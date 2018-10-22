import UIKit
import WebKit


class XBWebViewController: XBBaseViewController {
    
    var progressView: UIProgressView = {
        let progressView    = UIProgressView.init()
        progressView.progressTintColor = UIColor.blue
        progressView.frame = CGRect.init(x: 0, y: 0, w: MGScreenWidth, h: 2)
//        progressView.backgroundColor = UIColor.blue
        return progressView
    }()

    var webView: WKWebView = {
        let webConfiguration        = WKWebViewConfiguration()
        let w = WKWebView(frame: .zero, configuration: webConfiguration)
        return w
    }()
    
    var url = ""

    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress", context: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        if url == XBUrl {
//             navigationItem.title = "用户协议"
//        }else if url == HelpUrl {
//            navigationItem.title = "帮助"
//        }

        if let myURL = URL(string: url) {
            let myRequest   = URLRequest(url: myURL)
            let webviewConfig = WKWebViewConfiguration()
            webView =  WKWebView(frame: self.view.bounds, configuration: webviewConfig)
            view.addSubview(progressView)
            view.insertSubview(webView, belowSubview: progressView)
            webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
            webView.navigationDelegate  = self
            webView.uiDelegate = self
            webView.load(myRequest)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //MobClick.e(.H5)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = self.view.bounds
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "estimatedProgress") {
            print(Float(webView.estimatedProgress))
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            progressView.isHidden = (webView.estimatedProgress == 1)
        }
    }
}

extension XBWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
//        if url == XBUrl {
//            navigationItem.title = "用户协议"
//        }else if url == HelpUrl {
//            navigationItem.title = "帮助"
//        }else{
            self.title = self.webView.title
//        }
        
        // can()
    }
    
}
extension XBWebViewController: WKUIDelegate {
    
//    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
//        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
//
//
//        let sure   = UIAlertAction(title: "确定", style: .default) {[weak self] (action) in
//            if let strongSelf = self{
//                completionHandler()
//
//            }
//        }
//        alert.addAction(sure)
//        present(alert, animated: true, completion: nil)
//    }
    
}
