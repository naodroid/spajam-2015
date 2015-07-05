//
//  CreateQuestionTableViewCell.swift
//  spajam
//
//  Created by 坂本尚嗣 on 2015/07/04.
//  Copyright (c) 2015年 坂本尚嗣. All rights reserved.
//

import UIKit
import SDWebImage

class MyQuizCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var categoryImageView: UIImageView!
    
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var hexImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var hasQuizImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    func updateCell(#category : CategoryInfo, hasQuiz : Bool) {
        self.categoryLabel.text = category.name
        
        if hasQuiz {
            self.hexImageView.image = UIImage(named: "settings_ohako_selected")
            self.hasQuizImageView.image = UIImage(named: "settings_ohako_kentei_button_selected")
        } else {
            self.hexImageView.image = UIImage(named: "settings_ohako_default")
            self.hasQuizImageView.image = UIImage(named: "settings_ohako_kentei_button_default")
        }
        
        let url = NSURL(string : category.imageUrl)
        self.categoryImageView.sd_setImageWithURL(url!)
        
        
        let pw = self.bounds.size.width
        let ph = self.bounds.size.height
        
        
        
    }
}


