//
//  FerrisMenu.swift
//  FerrisMenu
//
//  Created by Gene De Lisa on 4/18/16.
//  Copyright © 2016 Gene De Lisa. All rights reserved.
//

import Foundation
import UIKit

public struct FerrisMenuItem {
    var title:String?
    var iconName:String?
    var target:AnyObject
    var selector:Selector
    var font:UIFont?
    var textColor:UIColor?
    var textHighlightColor:UIColor?
    var backgroundColor:UIColor?
    
    public init(title:String?,
                iconName:String?,
                target:AnyObject,
                selector:Selector,
                font:UIFont? = nil,
                textColor:UIColor? = nil,
                textHighlightColor:UIColor? = nil,
                backgroundColor:UIColor? = nil) {
        self.title = title
        self.iconName = iconName
        self.target = target
        self.selector = selector
        self.font = font
        self.textColor = textColor
        self.textHighlightColor = textHighlightColor
        self.backgroundColor = backgroundColor
    }
}

public protocol FerrisMenuDelegate {
    func angleDidChange(_ radians:CGFloat)
}


open class FerrisMenu : UIView {
    
    fileprivate let debug = false
    
    open var delegate:FerrisMenuDelegate?
    
    var diameter = CGFloat(200)
    
    open var buttons = [UIButton]()
    
    fileprivate var numberOfButtons = 0.0
    
    fileprivate var touchBeginAngle = CGFloat(0)
    
    fileprivate var currentMenuAngle = CGFloat(0)
    
    /// should the menu close when a button is pressed?
    open var hideOnButtonAction = true
    
    /// does it move?
    open var stationary = false
    
    /// animation on display
    open var rotateOnDisplay = false
    
    /// animation on hide
    open var rotateOnHide = true
    
    /// make all buttons the size of the largest button. Useful for text buttons.
    open var equalSizeButtons = true
    
    // the angle between buttons
    var theta = 0.0

    /// the padding between the button's content and frame
    var labelPadding = CGFloat(16)
    
    public override init(frame: CGRect) {
        super.init(frame:frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        diameter = frame.size.width
        self.layer.cornerRadius = diameter / 2.0
        
    }
    

    open func createMenu(_ items:[FerrisMenuItem]) {
        for v in subviews {
            v.removeFromSuperview()
        }
        
        self.numberOfButtons = Double(items.count)
        print("creating menu with \(numberOfButtons) buttons")
        
        let startAngle = 0
        
        // in radians (2pi radians in a unit circle)
        self.theta =  M_PI * 2.0 / self.numberOfButtons
        
        // so this is a half circle
        //self.theta =  M_PI / (self.numberOfButtons - 1)
        
        // this is a quarter circle
        //self.theta =  M_PI / 2.0 / (self.numberOfButtons - 1)
        
        
        for i in 0 ..< Int(items.count) {
            // each view has its own container. so the label can be rotated. Otherwise the label
            // at 6 oclock will be upside down.
            let container = UIView(frame: CGRect(x: 0, y: 0, width: diameter/2, height: 50))
            if debug {
                container.backgroundColor = UIColor.blue
                container.layer.borderColor = UIColor.blue.cgColor
                container.layer.borderWidth = 1
            }
            
            let button = UIButton(type: .custom)
            button.backgroundColor = UIColor.green
            button.tag = i
            button.addTarget(items[i].target, action: items[i].selector,
                             for:.touchUpInside)
            if hideOnButtonAction {
                button.addTarget(self, action: #selector(buttonAction(_:)),
                                 for:.touchUpInside)
            }
            
            if let title = items[i].title {
                button.setTitle("\(title)", for: UIControlState())
                button.setTitle("\(title)", for: .highlighted)
                if let textColor = items[i].textColor {
                    button.setTitleColor(textColor, for: UIControlState())
                } else {
                    button.setTitleColor(UIColor.black, for: UIControlState())
                }
                if let textColor = items[i].textHighlightColor {
                    button.setTitleColor(textColor, for: .highlighted)
                } else {
                    button.setTitleColor(UIColor.red, for: .highlighted)
                }
                
                if let bg = items[i].backgroundColor {
                    button.backgroundColor = bg
                }
                
                var attributes:[String : AnyObject]
                if let font = items[i].font {
                    button.titleLabel!.font = font
                    attributes = [NSFontAttributeName: font]
                    
                } else {
                    button.titleLabel!.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
                    attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: UIFont.systemFontSize)]
                }
                
                button.sizeToFit()
                let constraintRect = CGSize(width: button.frame.size.width, height: button.frame.size.width)
                let boundingBox = title.boundingRect(with: constraintRect,
                                                             options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                             attributes: attributes,
                                                             context: nil)
                
                // make it a circle
                setButtonSize(button, diameter: boundingBox.width)
            }
            if let iconName = items[i].iconName {
                if let icon = UIImage(named: iconName) {
                    button.setImage(icon, for: UIControlState() )
                    button.sizeToFit()
                    button.backgroundColor = UIColor.clear
                }
            }
            button.frame.origin.y = container.center.y - (button.bounds.size.height / 2)
            buttons.append(button)
            
            if debug {
                button.titleLabel!.textColor = UIColor.red
                button.backgroundColor = UIColor.green
                button.layer.borderColor = UIColor.red.cgColor
                button.layer.borderWidth = 1
            }
            
            container.layer.anchorPoint = CGPoint(x: 1.0, y: 0.5)
            container.layer.position = CGPoint(x: self.bounds.size.width / 2.0,
                                               y: self.bounds.size.height / 2.0)
            
            let rotation = CGFloat(theta) * CGFloat(i) + CGFloat(startAngle)
            container.transform = CGAffineTransform(rotationAngle: rotation)
            
            //TODO: make this work for less than a unit circle
            let buttonRotation =  -rotation
            button.transform = CGAffineTransform(rotationAngle: buttonRotation)
            
            container.addSubview(button)
            self.addSubview(container)
        }
        
        if equalSizeButtons {
            equalizeButtonSizes()
        }
    }
    
    func equalizeButtonSizes() {
        let maxsize: CGFloat = buttons.map{ $0.bounds.size.width }.reduce(CGFloat.leastNormalMagnitude, max)
        
        buttons.forEach {
            setButtonSize($0, diameter: maxsize - labelPadding)
        }
    }


    ///  Make the button a circle
    ///
    ///  - parameter button: the button to modify
    ///  - parameter diameter:   the diameter
    func setButtonSize(_ button:UIButton, diameter:CGFloat) {
        button.bounds.size.width = diameter + labelPadding
        button.bounds.size.height = button.bounds.size.width
        button.layer.cornerRadius = button.bounds.size.width / 2.0
    }
    
    
    func buttonAction(_ button:UIButton) {
        print("hiding action")
        if hideOnButtonAction {
            hide()
        }
    }
    
    func angleBetweenCenterAndPoint(_ point:CGPoint) -> CGFloat {
        let center = CGPoint(x: self.bounds.size.width / 2.0,
                             y: self.bounds.size.height / 2.0)
        return atan2(center.y - point.y, point.x - center.x)
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let point = touches.first?.location(in: self) {
            touchBeginAngle = angleBetweenCenterAndPoint(point)
        }
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !stationary {
            if let point = touches.first?.location(in: self) {
                let currentAngle = angleBetweenCenterAndPoint(point)
                let angleDifference = touchBeginAngle - currentAngle
                self.transform = self.transform.rotated(by: angleDifference)
                
                // same as getting the keypath
                //self.currentMenuAngle = atan2(transform.b, transform.a)
                
                //the rotation, in radians, in the z axis
                if let angle = self.value(forKeyPath: "layer.transform.rotation.z") {
                    self.currentMenuAngle = CGFloat((angle as AnyObject).doubleValue)
                    delegate?.angleDidChange(self.currentMenuAngle)
                }
                //print("menu angle \(self.currentMenuAngle) \(self.currentMenuAngle.radiansToDegrees)")
                
                // make the buttons "right side up"
                for i in 0..<buttons.count {
                    buttons[i].transform = buttons[i].transform.rotated(by: -CGFloat(angleDifference) )
                }
            }
        }
    }
    
    // so the text is "right side up"
    func resetButtonTransform() {
        for i in 0..<buttons.count {
            buttons[i].transform = CGAffineTransform(rotationAngle: -CGFloat(self.theta) * CGFloat(i))
        }
    }
    

    // don't set, I should probably make another get only prop based on this.
    open var displayed = false
    
    open func display(_ duration: Double = 1, delay: Double = 0) {
        displayed = true
        self.touchBeginAngle = 0
        self.currentMenuAngle = 0
        resetButtonTransform()
        if rotateOnDisplay {
            rotate(1)
        }
        self.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(
            withDuration: duration,
            delay: delay,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0,
            options: UIViewAnimationOptions.curveLinear,
            animations: {
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.alpha = 1
                print("displayed \(self)")
            }, completion: { (success) -> Void in
        })
        
    }
    
    open func hide(_ duration: Double = 1, delay: Double = 0) {
        displayed = false
        if rotateOnHide {
            rotate(1)
        }
        self.transform = self.transform.rotated(by: 0)
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: UIViewAnimationOptions.curveEaseIn,
            animations: {
                self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }, completion: { (success) -> Void in
                self.alpha = 0
        })
        
    }
    
    func rotate(_ repeatCount:Float = FLT_MAX) {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = M_PI * 2.0
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = repeatCount
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    
}

extension Int {
    var degreesToRadians: Double { return Double(self) * M_PI / 180 }
    var radiansToDegrees: Double { return Double(self) * 180 / M_PI }
}

extension Double {
    var degreesToRadians: Double { return self * M_PI / 180 }
    var radiansToDegrees: Double { return self * 180 / M_PI }
}

extension CGFloat {
    var doubleValue:      Double  { return Double(self) }
    var degreesToRadians: CGFloat { return CGFloat(doubleValue * M_PI / 180) }
    var radiansToDegrees: CGFloat { return CGFloat(doubleValue * 180 / M_PI) }
}

extension Float  {
    var doubleValue:      Double { return Double(self) }
    var degreesToRadians: Float  { return Float(doubleValue * M_PI / 180) }
    var radiansToDegrees: Float  { return Float(doubleValue * 180 / M_PI) }
}
