//
//  MainViewController.swift
//  KKAlertViewDemo
//
//  Created by lkk on 15/12/28.
//  Copyright © 2015年 lkk. All rights reserved.
//

import UIKit

private struct X {
    var title: String
    var block: ()->Void
}

class MainViewController: UIViewController {

    private var items = [X]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let table = UITableView(frame: view.bounds, style: UITableViewStyle.Grouped)
        table.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        view.addSubview(table)
        
        setupItems()
        
        table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "id")
        table.delegate = self
        table.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
    }
    
    func setupItems() {
        items = [
            X(title: "NormalAlert", block: { self.showNormalAlert()}),
            X(title: "TwoButtonAlert", block: { self.showTwoButtonAlert()}),
            X(title: "ThreeButtonAlert", block: { self.showThreeButtonAlert()}),
            X(title: "NormalActionSheet", block: { self.showNormalActionSheet()}),
            X(title: "OneBtnActionSheet", block: { self.showOneBtnActionSheet()}),
            X(title: "TwoBtnActionSheet", block: { self.showTwoBtnActionSheet()}),
            X(title: "ThreeBtnActionSheet", block: { self.showThreeBtnActionSheet()})
        ]
    }
}

extension MainViewController{  //alert
    func showNormalActionSheet() {
        KKActionSheet(title: "标题可以为空", cancelTitle:"确定", cancelAction: { () -> Void in
            print("确定")
        }).show()
    }
    
    func showOneBtnActionSheet() {
        let actionSheet = KKActionSheet(title: "退出后不会删除任何历史数据，下次登录依然可以使用本账号。", cancelTitle:"取消", cancelAction: { () -> Void in
            print("取消")
        })
        actionSheet.addButton("退出登录", isDestructive: true) { () -> Void in
            print("退出登录")
        }
        actionSheet.show()
    }
    
    func showTwoBtnActionSheet() {
        let actionSheet = KKActionSheet(title: nil, cancelTitle:"确定", cancelAction: { () -> Void in
            print("确定")
        })
        actionSheet.addButton("不确定", isDestructive: false) { () -> Void in
            print("不确定")
        }
        actionSheet.addButton("不知道", isDestructive: false) { () -> Void in
            print("不知道")
        }
        actionSheet.show()
    }
    func showThreeBtnActionSheet() {
        let actionSheet = KKActionSheet(title: "three button", cancelTitle:"cancel", cancelAction: { () -> Void in
            print("cancel")
        })
        actionSheet.addButton("first", isDestructive: false) { () -> Void in
            print("first")
        }
        actionSheet.addButton("second", isDestructive: false) { () -> Void in
            print("second")
        }
        actionSheet.addButton("third", isDestructive: false) { () -> Void in
            print("third")
        }
        actionSheet.show()
    }
}

extension MainViewController{  //alert
    func showNormalAlert() {
        KKAlertView(title: "标题可以为空",message:"正文不能为空",buttonTitle:"确定",isNormal:true,action: { () -> Void in
            print("确定")
        }).show()
        
    }
    func showTwoButtonAlert() {
        let alertView = KKAlertView(title: nil,message:"两个button",buttonTitle:"确定",isNormal:true,action: { () -> Void in
            print("确定")
        })
        alertView.addButton("取消", isNormal: false) { () -> Void in
            print("取消")
        }
        alertView.show()
    }
    func showThreeButtonAlert() {
        let alertView = KKAlertView(title: "三个button",message:"三个button",buttonTitle:"first",isNormal:true,action: { () -> Void in
            print("first")
        })
        alertView.addButton("second", isNormal: false) { () -> Void in
            print("second")
        }
        alertView.addButton("third", isNormal: false) { () -> Void in
            print("third")
        }
        alertView.show()
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("id")!
        cell.textLabel!.text = items[indexPath.row].title
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        items[indexPath.row].block()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}
