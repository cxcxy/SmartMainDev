//
//  SectionedSlider.swift
//  SectionedSlider
//
//  Created by Leonardo Cardoso on 06.06.17.
//  Copyright © 2017 leocardz.com. All rights reserved.
//

import UIKit

public protocol SectionedSliderDelegate {
    
	func sectionChanged(slider: SectionedSlider, selected: Int)
    
}

public class StyleKit : NSObject {

    //// Drawing Methods

    public static func drawSlider(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 156.5, height: 400), resizing: ResizingBehavior = .aspectFit, factor: CGFloat = 0.0, sections: CGFloat = 10, palette: Palette = Palette()) {
        
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!

        let sectionOriginalHeight: CGFloat = 400
        let sectionOriginalWidth: CGFloat = 156.5
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: sectionOriginalWidth, height: sectionOriginalHeight), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: 1, y: 1)


        let sectionsSafe: CGFloat = sections < 2 ? 2 : (sections > 100 ? 100 : sections)
        let sectionHeight: CGFloat = sectionOriginalHeight / sectionsSafe
        
        let slideHeight: CGFloat = floor(factor / (1.0 / sectionsSafe) + 1) * sectionHeight
        
        print(slideHeight)
        

        //// BackgroundView Drawing
        let backgroundViewPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: sectionOriginalWidth, height: sectionOriginalHeight))
        palette.viewBackgroundColor.setFill()
        backgroundViewPath.fill()
        

        
        
        //// Group
        context.saveGState()
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        
        
        //// SectionedMask Drawing
        context.saveGState()
        context.translateBy(x: 78, y: 200)
        context.rotate(by: -180 * CGFloat.pi/180)
        
        let sectionedMaskPath = UIBezierPath(rect: CGRect(x: -78, y: -200, width: sectionOriginalWidth, height: slideHeight))
        palette.sliderColor.setFill()
        sectionedMaskPath.fill()
        
        context.restoreGState()
        
        
        //// BodyView Drawing
        context.saveGState()
        context.setBlendMode(.sourceIn)
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        
        let bodyViewPath = UIBezierPath()
        bodyViewPath.move(to: CGPoint(x: 0, y: 0))

        bodyViewPath.close()
        palette.sliderColor.setFill()
        bodyViewPath.fill()
        
        context.endTransparencyLayer()
        context.restoreGState()


        context.saveGState()
        context.setBlendMode(.multiply)
        
        context.restoreGState()
    
        context.endTransparencyLayer()
        context.restoreGState()
        
        context.restoreGState()

    }




    @objc(SectionedSliderResizingBehavior)
    public enum ResizingBehavior: Int {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.

        public func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }

            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)

            switch self {
                case .aspectFit:
                    scales.width = min(scales.width, scales.height)
                    scales.height = scales.width
                case .aspectFill:
                    scales.width = max(scales.width, scales.height)
                    scales.height = scales.width
                case .stretch:
                    break
                case .center:
                    scales.width = 1
                    scales.height = 1
            }

            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
}

class SectionedSliderLayer: CALayer {
    
    // MARK: - Properties
    @NSManaged var factor: CGFloat
    
    // MARK: - Initializers
    override init() {
        
        super.init()
        
        factor = 0
        
    }
    
    override init(layer: Any) {
        
        super.init(layer: layer)
        
        if let layer = layer as? SectionedSliderLayer {
            
            factor = layer.factor
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
}

internal class Flow {
    
    // MARK: - Functions
    // Execute code block asynchronously
    static func async(block: @escaping () -> Void) {
        
        DispatchQueue.main.async(execute: block)
        
    }
    
    // Execute code block asynchronously after given delay time
    static func delay(for delay: TimeInterval, block: @escaping () -> Void) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: block)
        
    }
    
}

open class Palette {
    
    var viewBackgroundColor: UIColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000)
    var sliderBackgroundColor: UIColor = UIColor(red: 0.185, green: 0.184, blue: 0.184, alpha: 1.000)
    var sliderColor: UIColor = UIColor(red: 0.147, green: 0.000, blue: 0.697, alpha: 1.000)
    
    public init(viewBackgroundColor: UIColor? = nil, sliderBackgroundColor: UIColor? = nil, sliderColor: UIColor? = nil) {
        
        self.viewBackgroundColor = viewBackgroundColor ?? self.viewBackgroundColor
        self.sliderBackgroundColor = sliderBackgroundColor ?? self.sliderBackgroundColor
        self.sliderColor = sliderColor ?? self.sliderColor
        
    }
    
}

@IBDesignable
open class SectionedSlider: UIView {
    
    // MARK: - IBDesignable and IBInspectable
    @IBInspectable var viewBackgroundColor: UIColor? {
        didSet {
            palette.viewBackgroundColor = viewBackgroundColor ?? palette.viewBackgroundColor
        }
    }
    
    @IBInspectable var sliderBackgroundColor: UIColor? {
        didSet {
            palette.sliderBackgroundColor = sliderBackgroundColor ?? palette.sliderBackgroundColor
        }
    }
    
    @IBInspectable var sliderColor: UIColor? {
        didSet {
            palette.sliderColor = sliderColor ?? palette.sliderColor
        }
    }
    
    @IBInspectable open var sections: Int = 100 {
        willSet {
//            if newValue < 2 || newValue > 20 {
//                debugPrint("sections must be between 2 and 20")
//            }
        }
    }

    @IBInspectable open var selectedSection: Int = 0 {
        didSet {
            if selectedSection < 0 || selectedSection > sections {
                debugPrint("sections must be between 0 and \(sections)")
            } else {
                factor = CGFloat(selectedSection) / CGFloat(sections)
            }
        }
    }

    var factor: CGFloat = 0.0 {
        willSet {
            (layer as? SectionedSliderLayer)?.factor = newValue
            print("newValue----",newValue)
            print("factor----",abs(Int(ceil(CGFloat(newValue) * CGFloat(sections)))))
			delegate?.sectionChanged(slider: self, selected: abs(Int(ceil(CGFloat(newValue) * CGFloat(sections)))))

            draw()
        }
    }
    
    // MARK: - Properties
    private var keyPath: String = "factor"
    private var palette: Palette = Palette()
    open var delegate: SectionedSliderDelegate? {
        didSet {
            let factor = self.factor
            self.factor = factor
        }
    }
    
    override open class var layerClass: AnyClass {
        
        return SectionedSliderLayer.self
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
    }
    
    public init(frame: CGRect, selectedSection: Int, sections: Int, palette: Palette = Palette()) {
        
        super.init(frame: frame)
        
        defer {
            self.backgroundColor = palette.viewBackgroundColor
            
            self.sections = sections
            self.selectedSection = selectedSection
            self.palette = palette
        }
        
        addPanGesture()

        draw()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
    // MARK: - Lifecyle
    override open func awakeFromNib() {
        
        super.awakeFromNib()
        
        addPanGesture()

        draw()
        
    }
    
    override open func draw(_ layer: CALayer, in ctx: CGContext) {
        
        guard let layer: SectionedSliderLayer = layer as? SectionedSliderLayer else { return }
        
        let frame = CGRect(origin: CGPoint(x: 0, y: 0), size: layer.frame.size)
        
        UIGraphicsPushContext(ctx)
        
        switch keyPath {
            
        case "factor":
            
            StyleKit.drawSlider(frame: frame, factor: layer.factor, sections: CGFloat(sections), palette: palette)
            break
            
        default:
            
            break
            
        }
        
        UIGraphicsPopContext()
        
    }
    
    // MARK: - Functions
    
    private func addPanGesture() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(SectionedSlider.dragged(gesture:)))
        self.addGestureRecognizer(gesture)
    }
    
    private func resetManipulables() {
        
        guard let layer: SectionedSliderLayer = layer as? SectionedSliderLayer else { return }
        
        layer.factor = 0.0
        
    }
    
    func draw() {
        
        needsDisplay()
        
    }
    
    func needsDisplay() {
        
        layer.contentsScale = UIScreen.main.scale
        layer.setNeedsDisplay()
        
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        super.touchesBegan(touches, with: event)

        guard
            let touch = touches.first
            else { return }

        var x = self.frame.height - touch.location(in: self).y
        x = x < 0 ? -1 : (x > self.frame.height ? self.frame.height : x)

        factor = x / self.frame.height
        print("touchesBegan",factor)

    }
    
    @objc private func dragged(gesture: UIPanGestureRecognizer) {
        
        let point = gesture.location(in: self)
        var x = self.frame.height - point.y
        x = x < 0 ? -1 : (x > self.frame.height ? self.frame.height : x)
        factor = x / self.frame.height
        print("dragged",factor)
        
    }
    
}
