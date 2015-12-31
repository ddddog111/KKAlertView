# KKAlertView
Custom AlertView And ActionSheet

It is simple and easily customizable alert and actionsheet written in swift.



## demo Screenshot

###AlertView
<p><img src="https://raw.githubusercontent.com/keke1201/KKAlertView/master/ScreenShots/AlertView_normal.png" alt="AlertView_normal" width="150" />
<img src="https://raw.githubusercontent.com/keke1201/KKAlertView/master/ScreenShots/AlertView_twoBtn.png" alt="AlertView_twoBtn" width="150" />
<img src="https://raw.githubusercontent.com/keke1201/KKAlertView/master/ScreenShots/AlertView_threeBtn.png" alt="custom_content" width="150" />

###ActionSheet

<p><img src="https://raw.githubusercontent.com/keke1201/KKAlertView/master/ScreenShots/ActionSheet_normal.png" alt="ActionSheet_normal" width="150" />
<img src="https://raw.githubusercontent.com/keke1201/KKAlertView/master/ScreenShots/ActionSheet_oneBtn.png" alt="ActionSheet_oneBtn" width="150" />
<img src="https://raw.githubusercontent.com/keke1201/KKAlertView/master/ScreenShots/ActionSheet_twoBtn.png" alt="ActionSheet_twoBtn" width="150" />
<img src="https://raw.githubusercontent.com/keke1201/KKAlertView/master/ScreenShots/ActionSheet_threeBtn.png" alt="ActionSheet_threeBtn" width="150" />


## Installation

Drag `KKAlertView`and `KKActionSheet` to your project.

## How to use

###AlertView



```Swift 
let alertView = KKAlertView(title: nil,message:"两个button",buttonTitle:"确定",isNormal:true,action: { () -> Void in
            print("确定")
        })     
        alertView.addButton("取消", isNormal: false) { () -> Void in
            print("取消")
        }        
        alertView.show()
        ```
        
###ActionSheet

```Swift 
let actionSheet = KKActionSheet(title: "退出后不会删除任何历史数据，下次登录依然可以使用本账号。", cancelTitle:"取消", cancelAction: { () -> Void in
            print("取消")
        })
        actionSheet.addButton("退出登录", isDestructive: true) { () -> Void in
            print("退出登录")
        }
        actionSheet.show()
        ```
        
        
