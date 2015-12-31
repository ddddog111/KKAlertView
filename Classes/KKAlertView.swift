//
//  KKAlertView.swift
//  KKAlertView
//
//  Created by lkk on 15/12/28.
//  Copyright © 2015年 lkk. All rights reserved.
//

private let ScreenWidth = UIScreen.mainScreen().bounds.size.width
private let ScreenHeight = UIScreen.mainScreen().bounds.size.height

private let AlertWidth: CGFloat = ScreenWidth-60
private let AlertSpace: CGFloat = 20

private let ButtonBackgroundColor = UIColor.redColor()
private let ButtonTitleColor = UIColor.whiteColor()
private let ButtonTitleFont = UIFont.systemFontOfSize(16)
private let ButtonHeight: CGFloat = 40.0
private let ButtonBorderWidth:CGFloat = 0.5
private let ButtonCorner = true

private let TitleFont = UIFont.systemFontOfSize(16)
private let TitleColor = UIColor.blackColor()
private let MessageFont = UIFont.systemFontOfSize(14)
private let MessageColor = UIColor.blackColor()


import UIKit

typealias KKAction = ()->Void

class KKTempWindow: UIWindow {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(white: 0, alpha: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class KKAlertView: UIView {

    var title: String? {
        set {
            if newValue != nil {
                if titleLabel == nil {
                    titleLabel = self.initialTitleLabel()
                    self.addSubview(titleLabel!)
                }
                titleLabel!.text = newValue
            }
        }
        get {
            return self.title
        }
    }
    
    var message: String! {
        set {
            if newValue != nil {
                if messageLabel == nil {
                    messageLabel = self.initialMessageLabel()
                    self.addSubview(messageLabel!)
                }
                messageLabel!.text = newValue
                let newSize = newValue?.sizeWithFont(MessageFont, maxWidth: messageLabel!.frame.size.width)
                let messageFrame = messageLabel!.frame
                messageLabel!.frame = CGRectMake(messageFrame.origin.x, messageFrame.origin.y, messageFrame.size.width, newSize!.height)
                heightContent = messageFrame.origin.y + newSize!.height
            }
        }
        get {
            return self.message
        }
    }
    
    let windowFrame = UIScreen.mainScreen().bounds
    
    var titleLabel: UILabel?
    var messageLabel: UILabel!
    
    var buttons = [UIButton]()
    var actions = [KKAction]()
    var tempWindow: KKTempWindow!
    
    var heightContent = CGFloat(0)
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialTitleLabel() -> UILabel {
        let titleFrame = CGRectMake(AlertSpace, AlertSpace, AlertWidth-AlertSpace*2, AlertSpace)
        titleLabel = UILabel(frame: titleFrame)
        titleLabel?.textAlignment = NSTextAlignment.Center
        titleLabel?.font = TitleFont
        titleLabel?.textColor = TitleColor
        return titleLabel!
    }
    
    func initialMessageLabel() -> UILabel {
        var messageFrame = CGRectMake(AlertSpace, AlertSpace, AlertWidth-AlertSpace*2, AlertSpace)
        if (titleLabel != nil){
            messageFrame = CGRectMake(AlertSpace, AlertSpace*3, AlertWidth-AlertSpace*2, AlertSpace)
        }
        messageLabel = UILabel(frame: messageFrame)
        messageLabel?.font = MessageFont
        messageLabel?.numberOfLines = 0
        messageLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        messageLabel?.textAlignment = NSTextAlignment.Center
        messageLabel?.textColor = MessageColor
        return messageLabel!
    }
    
    init(title: String?, message: String,buttonTitle:String,isNormal:Bool,action:KKAction) {
        super.init(frame: windowFrame)
        self.title = title
        self.message = message
        setup()
        self.addButton(buttonTitle, isNormal: isNormal, action: action)
    }
    
    func setup() {
        self.frame = CGRectMake(0.0, 0.0, AlertWidth, ScreenHeight)
        self.center = CGPointMake(windowFrame.size.width/2, windowFrame.size.height/2)
        self.backgroundColor = UIColor.whiteColor()
    }
    
    func addButton(title: String?,isNormal:Bool,action:KKAction) {
        let button = UIButton(frame: CGRectMake(0.0, 0.0, AlertWidth, ScreenHeight))
        if isNormal {
            button.setTitleColor(ButtonTitleColor, forState: UIControlState.Normal)
            button.backgroundColor = ButtonBackgroundColor
        }else{
            button.setTitleColor(ButtonBackgroundColor, forState: UIControlState.Normal)
            button.backgroundColor = ButtonTitleColor
        }
        button.setTitle(title, forState: UIControlState.Normal)
        button.titleLabel?.font = ButtonTitleFont
        button.addTarget(self, action: Selector("buttonClicked:"), forControlEvents: UIControlEvents.TouchUpInside)
        button.tag = buttons.count
        buttons.append(button)
        actions.append(action)
        self.addSubview(button)
        refreshButtonFrame()
    }
    
    func buttonClicked(sender: AnyObject) {
        let button = sender as! UIButton
        let action = actions[button.tag]
        action()
        dismiss()
    }
    
    func show() {
        if tempWindow == nil {
            tempWindow = KKTempWindow(frame: windowFrame)
        }
        
        if tempWindow.hidden {
            tempWindow.hidden = false
        }
        
        tempWindow.addSubview(self)
        tempWindow.makeKeyAndVisible()
        
        self.transform = CGAffineTransformMakeScale(1.2, 1.2);
        tempWindow.alpha = 0
        
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.transform = CGAffineTransformIdentity
            self.tempWindow.alpha = 1
            }, completion: nil)
    }
    
    func dismiss() {
        self.removeFromSuperview()
        tempWindow.alpha = 1
        
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.tempWindow.alpha = 0
            }) { (completion) -> Void in
                self.tempWindow.hidden = true
                self.tempWindow.alpha = 1
        }
    }
    
    func refreshButtonFrame() {
        let count = buttons.count
        resetFrame(count)
        
        if count == 1 {
            let firstButton =  buttons[0] as UIButton
            let buttonFrame = CGRectMake(AlertSpace, heightContent+AlertSpace, self.frame.size.width-AlertSpace*2, ButtonHeight)
            firstButton.frame = buttonFrame
            firstButton.layer.masksToBounds = true
            firstButton.layer.cornerRadius = ButtonHeight/2
            firstButton.layer.borderColor = ButtonBackgroundColor.CGColor
            firstButton.layer.borderWidth = 0.5
        } else if count == 2 {
            let buttonWidth = (self.frame.size.width-AlertSpace*3)/2
            let firstButton =  buttons[0] as UIButton
            var buttonFrame = CGRectMake(AlertSpace, heightContent+AlertSpace, buttonWidth, ButtonHeight)
            firstButton.frame = buttonFrame
            firstButton.layer.masksToBounds = ButtonCorner
            firstButton.layer.cornerRadius = ButtonHeight/2
            firstButton.layer.borderColor = ButtonBackgroundColor.CGColor
            firstButton.layer.borderWidth = ButtonBorderWidth
            
            let secondButton =  buttons[1] as UIButton
            buttonFrame = CGRectMake(AlertSpace*2+buttonWidth, heightContent+AlertSpace, buttonWidth, ButtonHeight)
            secondButton.frame = buttonFrame
            secondButton.layer.masksToBounds = ButtonCorner
            secondButton.layer.cornerRadius = ButtonHeight/2
            secondButton.layer.borderColor = ButtonBackgroundColor.CGColor
            secondButton.layer.borderWidth = ButtonBorderWidth
        } else {
            for button in buttons{
                print(heightContent)
                heightContent = heightContent+AlertSpace
                let frame: CGRect = CGRectMake(
                    AlertSpace,heightContent,
                    self.frame.size.width-AlertSpace*2,
                    ButtonHeight)
                button.frame = frame
                button.layer.masksToBounds = ButtonCorner
                button.layer.cornerRadius = ButtonHeight/2
                button.layer.borderColor = ButtonBackgroundColor.CGColor
                button.layer.borderWidth = ButtonBorderWidth
                heightContent = heightContent+ButtonHeight
            }
        }
    }
    
    func resetFrame(count: Int) {
        if count == 1 || count == 2 {
            self.frame = CGRectMake(0.0, 0.0, self.frame.size.width, heightContent + ButtonHeight+AlertSpace*2)
            self.center = CGPointMake(windowFrame.size.width/2, windowFrame.size.height/2)
        } else {
            self.frame = CGRectMake(0.0, 0.0, self.frame.size.width, heightContent + CGFloat(count) * ButtonHeight+AlertSpace*CGFloat(count+1))
            self.center = CGPointMake(windowFrame.size.width/2, windowFrame.size.height/2)
        }
        self.setAllCorner(5)
    }
}

extension String{
    func sizeWithFont(font: UIFont, maxWidth: CGFloat) -> CGSize {
        let content = self as NSString
        let rect = content.boundingRectWithSize(
            CGSizeMake(maxWidth, CGFloat.max),
            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: [NSFontAttributeName: font],
            context: nil)
        return rect.size
    }
}

extension UIView {
    func setAllCorner(value:CGFloat){
        let maskPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: value)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.CGPath
        self.layer.mask = maskLayer
    }
}

