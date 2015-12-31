//
//  KKActionSheet.swift
//  KKAlertView
//
//  Created by lkk on 15/12/28.
//  Copyright © 2015年 lkk. All rights reserved.
//

import UIKit

private let ScreenWidth = UIScreen.mainScreen().bounds.size.width
private let ScreenHeight = UIScreen.mainScreen().bounds.size.height

private let SheetBackgroundColor = UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha:1)

private let Space: CGFloat = 20
private let ButtonHeight: CGFloat = 50.0
private let LineHeight:CGFloat = 1.0
private let CancelLineHeight: CGFloat = 5

private let TitleViewColor = UIColor.whiteColor()
private let TitleFont = UIFont.systemFontOfSize(14)
private let TitleColor = UIColor.grayColor()


private let ButtonNormalBackgroundColor = UIColor.whiteColor()
private let ButtonHighlightedBackgroundColor = UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha:1)
private let ButtonTitleColor = UIColor.blackColor()
private let ButtonDestructiveTitleColor = UIColor.redColor()
private let ButtonTitleFont = UIFont.systemFontOfSize(16)

class KKActionSheet: UIView {

    var title: String? {
        set {
            if newValue != nil {
                if titleLabel == nil {
                    titleLabel = self.initialTitleLabel()
                    titleView = UIView(frame: CGRectMake(0, 0, ScreenWidth, Space*3))
                    titleView.backgroundColor = TitleViewColor
                    mainView.addSubview(titleView)
                    titleView.addSubview(titleLabel!)
                }
                titleLabel!.text = newValue
                let newSize = newValue?.sizeWithFont(TitleFont, maxWidth: titleLabel!.frame.size.width)
                let frame = titleLabel!.frame
                titleLabel!.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, newSize!.height)
                heightContent = newSize!.height+Space*2+1
                titleView.frame = CGRectMake(0, 0, ScreenWidth, heightContent-1)
            }
        }
        get {
            return self.title
        }
    }
    
    let windowFrame = UIScreen.mainScreen().bounds
    
    var titleLabel: UILabel?
    var titleView: UIView!
    
    var buttons = [UIButton]()
    var actions = [KKAction]()
    var tempWindow: KKTempWindow!
    var heightContent = CGFloat(0)
    var mainView:UIView!
    var cancelBtnView:UIView!
    var cancelBtnAction:KKAction!
    
    func initialTitleLabel() -> UILabel {
        let titleFrame = CGRectMake(Space, Space, ScreenWidth-Space*2, Space)
        titleLabel = UILabel(frame: titleFrame)
        titleLabel?.textAlignment = NSTextAlignment.Center
        titleLabel?.font = TitleFont
        titleLabel?.textColor = TitleColor
        titleLabel?.numberOfLines = 0
        titleLabel?.lineBreakMode = NSLineBreakMode.ByCharWrapping
        heightContent = Space*3 + LineHeight
        return titleLabel!
    }
    
    init(title: String?,cancelTitle:String,cancelAction:KKAction) {
        super.init(frame: windowFrame)
        setup()
        self.title = title

        cancelBtnView = UIView(frame: CGRectMake(0, 0, ScreenWidth, ButtonHeight+CancelLineHeight))
        mainView.addSubview(cancelBtnView)
        cancelBtnView.backgroundColor = UIColor.clearColor()
        
        let cancelButton = UIButton(frame: CGRectMake(0.0, CancelLineHeight, ScreenWidth, ButtonHeight))
        cancelButton.setBackgroundImage(UIImage.getImageWithColor(ButtonNormalBackgroundColor), forState: UIControlState.Normal)
        cancelButton.setBackgroundImage(UIImage.getImageWithColor(ButtonHighlightedBackgroundColor), forState: UIControlState.Highlighted)
        cancelButton.setTitleColor(ButtonTitleColor, forState: UIControlState.Normal)
        cancelButton.setTitle(cancelTitle, forState: UIControlState.Normal)
        cancelButton.titleLabel?.font = ButtonTitleFont
        cancelButton.addTarget(self, action: Selector("cancelButtonClicked"), forControlEvents: UIControlEvents.TouchUpInside)
        cancelBtnView.addSubview(cancelButton)
        cancelBtnAction = cancelAction
        refreshButtonFrame()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight)
        self.backgroundColor = UIColor.clearColor()
        let bgBtn = UIButton(frame: self.frame)
        bgBtn.backgroundColor = UIColor.clearColor()
        bgBtn.addTarget(self, action: "dismiss", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(bgBtn)
        mainView = UIView(frame: self.frame)
        mainView.backgroundColor = SheetBackgroundColor
        self.addSubview(mainView)
    }
    
    func addButton(title: String?,isDestructive:Bool,action:KKAction) {
        let button = UIButton(frame: CGRectMake(0.0, 0.0, ScreenWidth, ScreenHeight))
        button.setTitleColor(isDestructive ?ButtonDestructiveTitleColor :ButtonTitleColor, forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage.getImageWithColor(ButtonNormalBackgroundColor), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage.getImageWithColor(ButtonHighlightedBackgroundColor), forState: UIControlState.Highlighted)
        button.setTitle(title, forState: UIControlState.Normal)
        button.titleLabel?.font = ButtonTitleFont
        button.addTarget(self, action: Selector("buttonClicked:"), forControlEvents: UIControlEvents.TouchUpInside)
        button.tag = buttons.count
        buttons.append(button)
        actions.append(action)
        mainView.addSubview(button)
        refreshButtonFrame()
    }
    
    func cancelButtonClicked(){
        cancelBtnAction()
        dismiss()
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
        
        tempWindow.alpha = 0
        
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            var frame = self.mainView.frame
            frame.origin.y = ScreenHeight-frame.size.height
            self.mainView.frame = frame
            self.tempWindow.alpha = 1
            }, completion: nil)
    }
    
    func dismiss() {
        tempWindow.alpha = 1
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            var frame = self.mainView.frame
            frame.origin.y = ScreenHeight
            self.mainView.frame = frame
            self.tempWindow.alpha = 0
            }) { (completion) -> Void in
                self.removeFromSuperview()
                self.tempWindow.hidden = true
                self.tempWindow.alpha = 1
        }
    }
    
    func refreshButtonFrame() {
        var buttonsY = heightContent
        let count = buttons.count
        resetFrame(count)
        
        for button in buttons{
            let frame: CGRect = CGRectMake(
                0,buttonsY,
                ScreenWidth,
                ButtonHeight)
            button.frame = frame
            buttonsY = buttonsY+ButtonHeight+LineHeight
        }
    }
    
    func resetFrame(count: Int) {
        mainView.frame = CGRectMake(0.0, ScreenHeight,ScreenWidth, heightContent + CGFloat(count) * (ButtonHeight+LineHeight)+ButtonHeight+CancelLineHeight)
        var frame = cancelBtnView.frame
        frame.origin.y = mainView.frame.size.height - frame.size.height
        cancelBtnView.frame = frame
    }
}

extension UIImage {
    class func getImageWithColor(color: UIColor) -> UIImage {
        let rect = CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

