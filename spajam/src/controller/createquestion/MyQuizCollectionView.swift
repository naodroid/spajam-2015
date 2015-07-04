//
//  MyQuizCollectionView.swift
//  spajam
//
//  Created by 坂本尚嗣 on 2015/07/05.
//  Copyright (c) 2015年 坂本尚嗣. All rights reserved.
//

import UIKit

class MyQuizCollectionView: UICollectionView {

    var lastFrame : CGRect = CGRectZero
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.updateCellSize()
        
    }
    
    private func updateCellSize() {
        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            let viewW = self.bounds.size.width
            let viewH = self.bounds.size.height
            
            let w = CGFloat(viewW * CGFloat(0.44))
            let h = CGFloat(viewH * CGFloat(0.49))
            
            layout.itemSize = CGSizeMake(w, h)
            self.lastFrame = self.frame
        }
    }

}
