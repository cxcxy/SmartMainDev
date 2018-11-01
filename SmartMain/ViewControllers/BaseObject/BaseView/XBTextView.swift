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
    func initialSetup()  {
        btnClear.isHidden = true
        textField.delegate = self
        let input = textField.rx.text.orEmpty.asDriver()
        input.map{ $0.count == 0 }
            .drive(btnClear.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    @IBAction func clickClearAction(_ sender: Any) {
        textField.text = ""
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
