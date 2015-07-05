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
    
    private var buttons : Array<UIButton>! = nil;
    private var images : Array<UIImageView>! = nil
    
    
    var quiz : Quiz! = nil
    var loadImageCount = 0
    
    //
    class func createVCWithQuiz(storyboard : UIStoryboard, quiz : Quiz) -> AnswerViewController {
        let vc = storyboard.instantiateViewControllerWithIdentifier("Answer") as!AnswerViewController
        vc.quiz = quiz
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

}

