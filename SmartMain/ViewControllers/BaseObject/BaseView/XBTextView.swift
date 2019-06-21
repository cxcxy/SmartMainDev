//
//  XBTextView.swift
//  XB
//
//  Created by mac on 2018/3/8.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit


typealias XBTextViewContent = ((_ contentStr: String) -> ())
@IBDesignable class XBTextView: UIView,UITextFieldDelegate {
    //显示进度的文本标签
    /**
     *   设置text属性
     */
    var text: String? {
        get {
            return textField.text ?? ""
        }set(value) {
           textField.text = value ?? ""
        }
    }
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var btnClear: UIButton!
     let disposeBag = DisposeBag()
    
    var contentBlock: XBTextViewContent?
    @IBInspectable open var placeholder: String = "" {
        didSet {
            textField.placeholder = placeholder
        }
    }
    @IBInspectable open var isPass: Bool = false {
        didSet {
            textField.isSecureTextEntry = isPass
        }
    }
    @IBInspectable open var isNumber: Bool = false {
        didSet {
            textField.keyboardType = isNumber ? .numberPad : .default
        }
    }
    @IBInspectable open var maxInput: Int = 1000
    
    @IBInspectable open var isBoard: Bool = true {
        didSet {
            if isBoard {
                self.setCornerRadius(radius: 20)
                self.addBorder(width: 0.5, color: XBNavColor)
            }else {
                self.setCornerRadius(radius: 0)
                self.addBorder(width: 0.0, color: UIColor.clear)
            }
        }
    }
    func initialSetup()  {
        self.setCornerRadius(radius: 20)
        self.addBorder(width: 0.5, color: XBNavColor)
        btnClear.isHidden = true
        textField.delegate = self
        let input = textField.rx.text.orEmpty.asDriver()
        input.map{ $0.count == 0 }
            .drive(btnClear.rx.isHidden)
            .disposed(by: disposeBag)
        
        Noti(.tf_valuechanged, object: self.textField).takeUntil(self.rx.deallocated).subscribe(onNext: { [weak self](notification) in
            guard let `self` = self else { return }
            self.greetingTextFieldChanged(sender: notification as NSNotification)
        }).disposed(by: rx_disposeBag)
        
//        NotificationCenter.default.addObserver(self, selector:
//            #selector(self.greetingTextFieldChanged), name:
//            NSNotification.Name(rawValue:
//                "UITextFieldTextDidChangeNotification"),
//                                                      object: self.textField)
//
    }
    @objc func greetingTextFieldChanged(sender:NSNotification) {
        
        let textField: UITextField = sender.object as! UITextField
        guard let _: UITextRange = textField.markedTextRange else{
            if (textField.text! as NSString).length > maxInput{
                textField.text = (textField.text! as NSString).substring(to: maxInput)
            }
            return
        }
        
    }
    @IBAction func clickClearAction(_ sender: Any) {
        textField.text = ""
        self.btnClear.isHidden = true
    }
    
    /*** 下面的几个方法都是为了让这个自定义类能将xib里的view加载进来。这个是通用的，我们不需修改。 ****/
    var contentView:UIView!

    //初始化时将xib中的view添加进来
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = loadViewFromNib()
        addSubview(contentView)
        self.backgroundColor = UIColor.black
        addConstraints()
        //初始化属性配置
        initialSetup()
    }
    
    //初始化时将xib中的view添加进来
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView = loadViewFromNib()
        addSubview(contentView)
        addConstraints()
        self.backgroundColor = UIColor.black
        //初始化属性配置
        initialSetup()
    }
    //加载xib
    func loadViewFromNib() -> UIView {
        let className = type(of: self)
        let bundle = Bundle(for: className)
        let name = NSStringFromClass(className).components(separatedBy: ".").last
        let nib = UINib(nibName: name!, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    //设置好xib视图约束
    func addConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        var constraint = NSLayoutConstraint(item: contentView, attribute: .leading,
                                            relatedBy: .equal, toItem: self, attribute: .leading,
                                            multiplier: 1, constant: 0)
        addConstraint(constraint)
        constraint = NSLayoutConstraint(item: contentView, attribute: .trailing,
                                        relatedBy: .equal, toItem: self, attribute: .trailing,
                                        multiplier: 1, constant: 0)
        addConstraint(constraint)
        constraint = NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal,
                                        toItem: self, attribute: .top, multiplier: 1, constant: 0)
        addConstraint(constraint)
        constraint = NSLayoutConstraint(item: contentView, attribute: .bottom,
                                        relatedBy: .equal, toItem: self, attribute: .bottom,
                                        multiplier: 1, constant: 0)
        addConstraint(constraint)
    }

}
