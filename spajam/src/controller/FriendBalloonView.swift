//
//  FriendBalloonView.swift
//  spajam
//
//  Created by 坂本尚嗣 on 2015/07/05.
//  Copyright (c) 2015年 坂本尚嗣. All rights reserved.
//

import UIKit
import QuartzCore

class FriendBalloonView: UIView {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var relationLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame : frame)
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let layer = self.iconImageView.layer
        layer.cornerRadius = CGFloat(38)
    }
   
    
    func updateWithFriend(friend : Friend) {
        let url = NSURL(string: friend.image)!
        iconImageView.sd_setImageWithURL(url)
        userNameLabel.text = "\(friend.name)さん"
        relationLabel.text = self.textForRelation(friend.category, rank: friend.rank)
    }
    func textForRelation(category: String, rank: QuizRank) -> String {
        switch rank {
        case .Teacher:
            return "\(category)の師匠"
        case .Friend:
            return "\(category)の同士"
        case .Fickle:
            return "\(category)ニワカ"
        }
    }
    
    class func createView() -> FriendBalloonView {
        let nib = UINib(nibName: "FriendBalloonView", bundle: nil)
        let array = nib.instantiateWithOwner(nil, options: nil)
        return array[0] as! FriendBalloonView
    }
    

}
