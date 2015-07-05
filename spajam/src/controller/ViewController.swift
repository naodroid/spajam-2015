//
//  ViewController.swift
//  spajam
//
//  Created by 坂本尚嗣 on 2015/07/02.
//  Copyright (c) 2015年 坂本尚嗣. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var mainRootView: MainRootView!
    private var timerRunning = false
    private var lastPollingCallTime : NSTimeInterval = 0
    
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
    }
    override func viewDidDisappear(animated: Bool) {
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
    private func accessToUserQuiz(userId : Int) {
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
            if let picked = self.randomPick(users) {
                self.accessToUserQuiz(picked.userId.toInt()!)
            }
        }.finally(on: dispatch_get_main_queue()) { () -> Void in
            dispatchAfterOnMain(10) {
                self.pollingProcess(time)
            }
        }
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

