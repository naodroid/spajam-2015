//
//  AnswerViewController.swift
//  spajam
//
//  Created by 坂本尚嗣 on 2015/07/05.
//  Copyright (c) 2015年 坂本尚嗣. All rights reserved.
//

import UIKit

class AnswerViewController: UIViewController {
    
    //IB
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var countDownLabel: UILabel!
    
    @IBOutlet weak var resultImageView: UIImageView!
    
    
    private var buttons : Array<UIButton>! = nil;
    private var images : Array<UIImageView>! = nil
    
    private var countDownRunning = true
    
    
    var quiz : Quiz! = nil
    var loadImageCount = 0
    var countdownTime = 10
    
    //
    class func createVCWithQuiz(storyboard : UIStoryboard, quiz : Quiz) -> AnswerViewController {
        let vc = storyboard.instantiateViewControllerWithIdentifier("Answer") as!AnswerViewController
        vc.quiz = quiz
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let name = self.quiz.userName
        self.titleLabel.text = "\(name)さんのオハコ検定"
        
        self.callForWait()
        
        self.buttons = [
            self.button1, self.button2, self.button3, self.button4
        ]
        self.images = [
            self.image1, self.image2, self.image3, self.image4
        ]
        
        //画像を読み込む
        self.loadImageCount = 0
        for i in 0..<4 {
            let img = self.images[i]
            let ans = self.quiz.answers[i]
            let url = NSURL(string : ans.imageUrl)!
            img.hidden = true
            img.sd_setImageWithURL(url, completed: {
                (image, error, cachetype, url) -> Void in
                if (image != nil) {
                    self.imageLoadFinished()
                    
                } else {
                    self.showErrorDialog()
                }
            })
            let btn = self.buttons[i]
            btn.tag = i
            btn.addTarget(self, action: "didSelectButton:", forControlEvents: .TouchUpInside)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Event
    
    func didSelectButton(button : UIButton) {
        self.countDownRunning = false
        
        let index = button.tag
        let rank = self.quiz.answers[index].rank
        let img = self.quiz.answers[index].imageUrl
        
        switch rank {
        case .Teacher:
            self.resultImageView.image = UIImage(named: "kentei_result3")
        case .Friend:
            self.resultImageView.image = UIImage(named: "kentei_result2")
        case .Fickle:
            self.resultImageView.image = UIImage(named: "kentei_result1")
        }
        
        
        //通信処理
        Api.addFriend(self.quiz.userId,
            answerRank: rank,
            selectedImage: img,
            category: self.quiz.category).then {(result) -> Void in
               self.showResultWithRank(rank)
        }
    }
    func showResultWithRank(rank: QuizRank) {
        //結果をどう表示すべきか
        EventBus.sendEvent(FriendListUpdateRequestEvent())
        
        self.resultImageView.hidden = false
        self.resultImageView.transform = CGAffineTransformMakeScale(1.5, 1.5)
        self.resultImageView.alpha = 0
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.resultImageView.transform = CGAffineTransformIdentity
            self.resultImageView.alpha = 1
            
            dispatchAfterOnMain(2.0) {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        });
    }
    
    
    //
    private func imageLoadFinished() {
        self.loadImageCount++;
        if (self.loadImageCount >= 4) {
            //アニメーションスタート
            for i in 0..<4 {
                let img = self.images[i]
                img.alpha = 1
                img.hidden = false
                
                let dirX = i % 2 == 0 ? -1 : 1
                let dirY = i < 2 ? -1 : 1
                
                let dx = CGFloat(280 * dirX)
                let dy = CGFloat(280 * dirY)
                
                img.transform = CGAffineTransformMakeTranslation(dx, dy)
            }
            UIView.animateWithDuration(0.6, animations: { () -> Void in
                for i in 0..<4 {
                    let img = self.images[i]
                    img.transform = CGAffineTransformIdentity
                }
            })
        }
    }
    
    //
    
    private func showErrorDialog() {
        //dismiss
    }

    func callForWait(){
        let delay = 1 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.stepsAfterDelay()
        }
    }
    
    
    func stepsAfterDelay(){
        if (!self.countDownRunning) {
            return
        }
        if countdownTime <= 0 {
            // 終了
            self.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        self.countDownLabel.text = String(countdownTime)
        countdownTime--
        self.callForWait()
    }
}

