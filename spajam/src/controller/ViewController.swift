//
//  ViewController.swift
//  spajam
//
//  Created by 坂本尚嗣 on 2015/07/02.
//  Copyright (c) 2015年 坂本尚嗣. All rights reserved.
//

import UIKit
import PromiseKit

class ViewController: UIViewController {

    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var mainRootView: MainRootView!
    private var timerRunning = false
    private var lastPollingCallTime : NSTimeInterval = 0
    private var isVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TimerEvent.register(self, {(ev: TimerEvent) -> Void in
            self.didReceiveTimerEvent(ev)
        })
        
        FriendListUpdateRequestEvent.register(self, {(ev : FriendListUpdateRequestEvent) -> Void in
            self.didReceiveFriendListUpdateEvent(ev)
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !User.hasAccount() {
            let vc = PresentationViewController.createVC()
            let nc = UINavigationController(rootViewController: vc)
            nc.setNavigationBarHidden(true, animated: false)
            self.presentViewController(nc, animated: true, completion: nil)
        } else if MyQuizList.instance().list.count == 0 {
            self.showListVC(false)
        } else {
            accessFriendList()

            let name = User.owner().name!
            self.ownerNameLabel.text = "\(name)さん"
            self.timerRunning = true
            self.startPolling()
        }
        self.isVisible = true
    }
    override func viewDidDisappear(animated: Bool) {
        self.isVisible = false
        EventBus.sendEvent(TimerEvent(running: false))
        super.viewDidDisappear(animated)
    }
    
    func showListVC(backEnabled : Bool) {
        let vc = MyQuizViewController.createVC(backEnabled)
        self.presentViewController(vc, animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: event
    func didReceiveTimerEvent(ev : TimerEvent) {
        self.timerRunning = ev.running
        if ev.running {
            self.startPolling()
        }
    }
    func didReceiveFriendListUpdateEvent(ev : FriendListUpdateRequestEvent) {
        
    }
    
    @IBAction func didClickListButton(sender: AnyObject) {
        self.showListVC(true)
    }
    @IBAction func didClickDebug(sender: AnyObject) {
        //特定ユーザIDを決め打ちで取得する
        accessToUserQuiz(89)
    }
    
    private func accessToUsers(index : Int, users : [User]) {
        if index >= users.count  {
            return
        }
        let user = users[0]
        let userId = user.userId.toInt()!
        
        Api.quizListProcess(userId).then {(quizList) -> Void in
            if (!self.isVisible) {
                return
            }
            if let quiz = self.findEnableQuiz(userId, quizList: quizList) {
                let vc = OhakoReceivedViewController.createVCWithQuiz(quiz)
                let nc = UINavigationController(rootViewController: vc)
                nc.setNavigationBarHidden(true, animated: false)
                
                self.addChildViewController(nc)
                self.view.addSubview(nc.view)
                nc.didMoveToParentViewController(self)
                vc.startEnterAnimation()
                EventBus.sendEvent(TimerEvent(running: false))
            } else {
                //クイズがなければ次へ
                self.accessToUsers(index + 1, users: users)
            }
        }
        
    }
    
    private func accessToUserQuiz(userId : Int)  {
        Api.quizListProcess(userId).then {(quizList) -> Void in
            if let quiz = self.findEnableQuiz(userId, quizList: quizList) {
                let vc = OhakoReceivedViewController.createVCWithQuiz(quiz)
                let nc = UINavigationController(rootViewController: vc)
                nc.setNavigationBarHidden(true, animated: false)
                
                self.addChildViewController(nc)
                self.view.addSubview(nc.view)
                nc.didMoveToParentViewController(self)
                vc.startEnterAnimation()
                EventBus.sendEvent(TimerEvent(running: false))
            }
        }
    }
    private func findEnableQuiz(userId: Int, quizList : [Quiz]) -> Quiz? {
        let myList = MyQuizList.instance().list
        return quizList.reduce(nil) {(value : Quiz?, quiz) -> Quiz? in
            if (value != nil) {
                return value
            }
            let c = quiz.category
            if myList[c] != nil && !AnsweredList.instance().hasData(userId, category: c) {
                return quiz
            }
            return nil
        }
    }
    
    
    
    //POlling
    private var lastFriendCount = 0;
    func accessFriendList() {
        //フレンド一覧のポーリング
        Api.getFriendList().then {(list) -> Void in
            if (list.count != self.lastFriendCount) {
                self.mainRootView.friends = list
                self.lastFriendCount = list.count;
            }
        }
    }
    
    func startPolling() {
        let time = NSDate.timeIntervalSinceReferenceDate()
        self.lastPollingCallTime = time
        dispatchAfterOnMain(3.0) {
            self.pollingProcess(time)
        }
    }
    func pollingProcess(time : NSTimeInterval) {
        if (!self.timerRunning || self.lastPollingCallTime != time) {
            return
        }
        Api.getAllUsers().then {(users) -> Void in
            let filtered = self.filterOwner(users)
            let r = self.randomSort(filtered)
            self.accessToUsers(0, users: r)
        }.finally(on: dispatch_get_main_queue()) { () -> Void in
            dispatchAfterOnMain(10) {
                self.pollingProcess(time)
            }
        }
    }
    func filterOwner(users : [User]) -> [User] {
        var result = [User]()
        let ownerId = User.owner().userId
        
        for user in users {
            if user.userId != ownerId {
                result.append(user)
            }
        }
        return result
    }
    
    func randomSort(users : [User]) -> [User] {
        if users.count < 2 {
            return users
        }
        var list = users
        let count = users.count
        for i in 0..<20 {
            let index1 = Int(arc4random_uniform(UInt32(count)))
            let index2 = Int(arc4random_uniform(UInt32(count)))
            var dum = list[index1]
            list[index1] = list[index2]
            list[index2] = dum
        }
        return list
    }
    ///ランダムに抽出
    func randomPick(users : [User]) -> User? {
        let count = users.count
        if (count == 0) {
            return nil
        }
        let index = arc4random_uniform(UInt32(count))
        return users[Int(index)]
    }    
}

