//
//  FerrisMenu.swift
//  CircleLayout
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

@IBDesignable
public class FerrisMenu : UIView {
    let debug = false
    
    @IBInspectable
    var diameter = CGFloat(200)
    
    var buttons = [UIButton]()
    
    @IBInspectable
    var numberOfButtons = 0.0
    
    let buttonDiameter = CGFloat(25.0)
    
    var touchBeginAngle = CGFloat(0)
    
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
    }
    
    public func createMenu(items:[FerrisMenuItem]) {
        for v in subviews {
            v.removeFromSuperview()
        }
        
        self.numberOfButtons = Double(items.count)
        print("creating menu with \(numberOfButtons) buttons")
        
        // in radians
        let theta = 2.0 * M_PI / self.numberOfButtons
        
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
            
            
            if debug {
                button.titleLabel!.textColor = UIColor.redColor()
                button.backgroundColor = UIColor.greenColor()
                button.layer.borderColor = UIColor.redColor().CGColor
                button.layer.borderWidth = 1
            }
            
            
            button.frame.origin.y = container.center.y - (button.bounds.size.height / 2)
            buttons.append(button)
            
            
            container.layer.anchorPoint = CGPoint(x: 1.0, y: 0.5)
            container.layer.position = CGPoint(x: self.bounds.size.width / 2.0,
                                               y: self.bounds.size.height / 2.0)
            
            let rotation = CGFloat(theta) * CGFloat(i)
            container.transform = CGAffineTransformMakeRotation(rotation)
            let buttonRotation = -rotation
            button.transform = CGAffineTransformMakeRotation(buttonRotation)
            
            container.addSubview(button)
            self.addSubview(container)
        }
        
    }
    
    func buttonAction(button:UIButton) {
        print(button.tag)
    }
    
    func angleBetweenCenterAndPoint(point:CGPoint) -> CGFloat {
        let center = CGPoint(x: self.bounds.size.width / 2.0,
                             y: self.bounds.size.height / 2.0)
        
        //  atan2 reurns the angle in radians between the positive x axis and the point given by the coordinates.  Calculate the x and y distance of a touch from the center of our view and pass that to atan2, which will return us the angle of the touch relative to our center
        
        return atan2(center.y - point.y, point.x - center.x)
    }
    
    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let point = touches.first?.locationInView(self) {
            touchBeginAngle = angleBetweenCenterAndPoint(point)
        }
    }
    
    override public func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let point = touches.first?.locationInView(self) {
            let currentAngle = angleBetweenCenterAndPoint(point)
            let angleDifference = touchBeginAngle - currentAngle
            self.transform = CGAffineTransformRotate(self.transform, angleDifference)
            // make the buttons "right side up"
            for i in 0..<buttons.count {
                buttons[i].transform = CGAffineTransformRotate(buttons[i].transform, -CGFloat(angleDifference) * CGFloat(1))
            }
        }
    }
    
    // so the text is "right side up"
    func resetButtonTransform() {
        let theta = 2.0 * M_PI / numberOfButtons // radians, remember
        
        for i in 0..<buttons.count {
            buttons[i].transform = CGAffineTransformMakeRotation(-CGFloat(theta) * CGFloat(i))
        }
    }
    
    public var displayed = false
    
    public func display(duration: Double = 1, delay: Double = 0) {
        displayed = true
        self.touchBeginAngle = 0
        resetButtonTransform()
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
    
    
    
}



extension Double {
    var radians: Double {
        return self * (Double(180) / Double(M_PI))
    }
    
    var degrees: Double {
        return self  * Double(M_PI) / 180.0
    }
}


extension Float {
    var radians: Float {
        return self * (Float(180) / Float(M_PI))
    }
    
    var degrees: Float {
        return self  * Float(M_PI) / 180.0
    }
}
