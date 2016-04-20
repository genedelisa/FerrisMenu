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
    func angleDidChange(radians:CGFloat)
}


public class FerrisMenu : UIView {
    
    private let debug = false
    
    public var delegate:FerrisMenuDelegate?
    
    var diameter = CGFloat(200)
    
    public var buttons = [UIButton]()
    
    private var numberOfButtons = 0.0
    
    private var touchBeginAngle = CGFloat(0)
    
    private var currentMenuAngle = CGFloat(0)
    
    /// should the menu close when a button is pressed?
    public var hideOnButtonAction = true
    
    /// does it move?
    public var stationary = false
    
    /// animation on display
    public var rotateOnDisplay = false
    
    /// animation on hide
    public var rotateOnHide = true
    
    // the angle between buttons
    var theta = 0.0
    
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
    

    public func createMenu(items:[FerrisMenuItem]) {
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
                container.backgroundColor = UIColor.blueColor()
                container.layer.borderColor = UIColor.blueColor().CGColor
                container.layer.borderWidth = 1
            }
            
            let button = UIButton(type: .Custom)
            button.backgroundColor = UIColor.greenColor()
            button.tag = i
            button.addTarget(items[i].target, action: items[i].selector,
                             forControlEvents:.TouchUpInside)
            if hideOnButtonAction {
                button.addTarget(self, action: #selector(buttonAction(_:)),
                                 forControlEvents:.TouchUpInside)
            }
            
            if let title = items[i].title {
                button.setTitle("\(title)", forState: .Normal)
                button.setTitle("\(title)", forState: .Highlighted)
                if let textColor = items[i].textColor {
                    button.setTitleColor(textColor, forState: .Normal)
                } else {
                    button.setTitleColor(UIColor.blackColor(), forState: .Normal)
                }
                if let textColor = items[i].textHighlightColor {
                    button.setTitleColor(textColor, forState: .Highlighted)
                } else {
                    button.setTitleColor(UIColor.redColor(), forState: .Highlighted)
                }
                
                if let bg = items[i].backgroundColor {
                    button.backgroundColor = bg
                }
                
                var attributes:[String : AnyObject]
                if let font = items[i].font {
                    button.titleLabel!.font = font
                    attributes = [NSFontAttributeName: font]
                    
                } else {
                    button.titleLabel!.font = UIFont.systemFontOfSize(UIFont.systemFontSize())
                    attributes = [NSFontAttributeName: UIFont.systemFontOfSize(UIFont.systemFontSize())]
                }
                
                button.sizeToFit()
                let constraintRect = CGSize(width: button.frame.size.width, height: button.frame.size.width)
                let boundingBox = title.boundingRectWithSize(constraintRect,
                                                             options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                                                             attributes: attributes,
                                                             context: nil)
                
                // make it a circle
                let labelPadding = CGFloat(16)
                button.bounds.size.width = boundingBox.width + labelPadding
                button.bounds.size.height = button.bounds.size.width
                button.layer.cornerRadius = button.bounds.size.width / 2.0
                
            }
            if let iconName = items[i].iconName {
                if let icon = UIImage(named: iconName) {
                    button.setImage(icon, forState: .Normal )
                    button.sizeToFit()
                    button.backgroundColor = UIColor.clearColor()
                    
                }
            }
            button.frame.origin.y = container.center.y - (button.bounds.size.height / 2)
            buttons.append(button)
            
            if debug {
                button.titleLabel!.textColor = UIColor.redColor()
                button.backgroundColor = UIColor.greenColor()
                button.layer.borderColor = UIColor.redColor().CGColor
                button.layer.borderWidth = 1
            }
            
            container.layer.anchorPoint = CGPoint(x: 1.0, y: 0.5)
            container.layer.position = CGPoint(x: self.bounds.size.width / 2.0,
                                               y: self.bounds.size.height / 2.0)
            
            let rotation = CGFloat(theta) * CGFloat(i) + CGFloat(startAngle)
            container.transform = CGAffineTransformMakeRotation(rotation)
            
            //TODO: make this work for less than a unit circle
            let buttonRotation =  -rotation
            button.transform = CGAffineTransformMakeRotation(buttonRotation)
            
            container.addSubview(button)
            self.addSubview(container)
        }
        
    }
    
    func buttonAction(button:UIButton) {
        print("hiding action")
        if hideOnButtonAction {
            hide()
        }
    }
    
    func angleBetweenCenterAndPoint(point:CGPoint) -> CGFloat {
        let center = CGPoint(x: self.bounds.size.width / 2.0,
                             y: self.bounds.size.height / 2.0)
        return atan2(center.y - point.y, point.x - center.x)
    }
    
    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let point = touches.first?.locationInView(self) {
            touchBeginAngle = angleBetweenCenterAndPoint(point)
        }
    }
    
    override public func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !stationary {
            if let point = touches.first?.locationInView(self) {
                let currentAngle = angleBetweenCenterAndPoint(point)
                let angleDifference = touchBeginAngle - currentAngle
                self.transform = CGAffineTransformRotate(self.transform, angleDifference)
                
                // same as getting the keypath
                //self.currentMenuAngle = atan2(transform.b, transform.a)
                
                //the rotation, in radians, in the z axis
                if let angle = self.valueForKeyPath("layer.transform.rotation.z") {
                    self.currentMenuAngle = CGFloat(angle.doubleValue)
                    delegate?.angleDidChange(self.currentMenuAngle)
                }
                //print("menu angle \(self.currentMenuAngle) \(self.currentMenuAngle.radiansToDegrees)")
                
                // make the buttons "right side up"
                for i in 0..<buttons.count {
                    buttons[i].transform = CGAffineTransformRotate(buttons[i].transform, -CGFloat(angleDifference) )
                }
            }
        }
    }
    
    // so the text is "right side up"
    func resetButtonTransform() {
        for i in 0..<buttons.count {
            buttons[i].transform = CGAffineTransformMakeRotation(-CGFloat(self.theta) * CGFloat(i))
        }
    }
    

    // don't set, I should probably make another get only prop based on this.
    public var displayed = false
    
    public func display(duration: Double = 1, delay: Double = 0) {
        displayed = true
        self.touchBeginAngle = 0
        self.currentMenuAngle = 0
        resetButtonTransform()
        if rotateOnDisplay {
            rotate(1)
        }
        self.transform = CGAffineTransformMakeScale(0, 0)
        UIView.animateWithDuration(
            duration,
            delay: delay,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0,
            options: UIViewAnimationOptions.CurveLinear,
            animations: {
                self.transform = CGAffineTransformMakeScale(1.0, 1.0)
                self.alpha = 1
                print("displayed \(self)")
            }, completion: { (success) -> Void in
        })
        
    }
    
    public func hide(duration: Double = 1, delay: Double = 0) {
        displayed = false
        if rotateOnHide {
            rotate(1)
        }
        self.transform = CGAffineTransformRotate(self.transform, 0)
        UIView.animateWithDuration(
            duration,
            delay: delay,
            options: UIViewAnimationOptions.CurveEaseIn,
            animations: {
                self.transform = CGAffineTransformMakeScale(0.01, 0.01)
            }, completion: { (success) -> Void in
                self.alpha = 0
        })
        
    }
    
    func rotate(repeatCount:Float = FLT_MAX) {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = M_PI * 2.0
        rotation.duration = 1
        rotation.cumulative = true
        rotation.repeatCount = repeatCount
        self.layer.addAnimation(rotation, forKey: "rotationAnimation")
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
