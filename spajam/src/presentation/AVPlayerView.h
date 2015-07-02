//
//  AVPlayerView.h
//  navsample
//
//  Created by 坂本尚嗣 on 2015/06/06.
//  Copyright (c) 2015年 坂本尚嗣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class AVPlayerView;

@protocol AVPlayerViewDelegate <NSObject>

- (void)avPlayer:(AVPlayerView *)player didStatuChanged:(AVPlayerStatus)status;

@end


@interface AVPlayerView : UIView

@property (nonatomic, weak) id<AVPlayerViewDelegate> delegate;
//再生時間
@property (nonatomic, readonly) NSTimeInterval duration;
//status
@property (nonatomic, readonly) AVPlayerStatus status;


//指定ファイルで再生準備を行う。statusが.ReadyTolayになるまでplayなどはできないので注意。
- (void)setupWithFile:(NSString *)file;
//再生開始
- (void)play;
//ポーズ
- (void)pause;
//指定位置にシーク。動画時間の範囲外は考慮していない
- (void)seekTo:(NSTimeInterval)time;

@end
