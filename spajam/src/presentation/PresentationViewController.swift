//
//  PresentationViewController.swift
//  spajam
//
//  Created by 坂本尚嗣 on 2015/07/04.
//  Copyright (c) 2015年 坂本尚嗣. All rights reserved.
//

import UIKit

class PresentationViewController: UIViewController, AVPlayerViewDelegate, UIScrollViewDelegate  {

    @IBOutlet weak var playerView: AVPlayerView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var lastOffsetX : CGFloat = 0
    
    private let timeInPage : [NSTimeInterval] = [2.0, 4.2, 7.0, 8.5, 11.0];
    
    
    //-----------------------------------
    class func createVC() -> PresentationViewController {
        return PresentationViewController(nibName: "PresentationViewController", bundle: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.delegate = self
        
        self.pageControl.hidden = true
        
        self.playerView.delegate = self
        self.playerView.setupWithFile("sample.m4a")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: AVPlayer
    func avPlayer(player: AVPlayerView!, didStatuChanged status: AVPlayerStatus) {
        switch status {
        case AVPlayerStatus.ReadyToPlay:
            self.setupScrollView()
            break;
        case AVPlayerStatus.Failed:
            break;
        case AVPlayerStatus.Unknown:
            break;
        }
    }
    
    //MARK: seek movie
    func setupScrollView() {
        let bounds = self.scrollView.bounds
        let viewW = bounds.size.width
        let width = viewW * 4
        let height = bounds.size.height
        self.scrollView.contentSize = CGSizeMake(width, height)
        
        self.pageControl.hidden = false
        self.pageControl.numberOfPages = 4
        
        self.scrollView.contentOffset = CGPointMake(-320, 0)
        
        self.scrollView.setContentOffset(CGPointZero, animated: true)
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        let scrollW = scrollView.bounds.size.width
        
        
        if abs(offset - lastOffsetX) < CGFloat(2) && Int(offset) % Int(scrollW) > 0{
            return
        }
        self.lastOffsetX = offset
        
        
        let contentW = scrollView.contentSize.width
        if contentW <= scrollW {
            return
        }
        
        let page : Int
        let diff : CGFloat
        let sectionStart : NSTimeInterval
        let sectionEnd : NSTimeInterval
        
        if offset >= 0 {
            page = Int(offset / scrollW)
            sectionStart = self.timeInPage[page]
            sectionEnd = self.timeInPage[page + 1]
            diff = offset - CGFloat(page) * scrollW
        } else {
            page = 0
            sectionStart = 0
            sectionEnd = self.timeInPage[0]
            diff = offset + scrollW
        }
        let ratio = NSTimeInterval(diff / scrollW)
        
        let seekTime = (sectionEnd - sectionStart) * ratio + sectionStart
        
        self.playerView.seekTo(seekTime)
        
        self.pageControl.currentPage = Int((offset + scrollW / 2) / scrollW)
    }
}
