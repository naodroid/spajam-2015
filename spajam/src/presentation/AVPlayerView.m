//
//  AVPlayerView.m
//  navsample
//
//  Created by 坂本尚嗣 on 2015/06/06.
//  Copyright (c) 2015年 坂本尚嗣. All rights reserved.
//

#import "AVPlayerView.h"
#import <AVFoundation/AVFoundation.h>

static NSString* const kStatusKey = @"status";

@interface AVPlayerView()
@property (nonatomic) AVPlayerItem *item;
@property (nonatomic) AVPlayer *player;


@property (nonatomic) BOOL isSeeking;
@property (nonatomic) NSMutableArray *seekingList;

@end


//------------------------------
@implementation AVPlayerView
@dynamic duration;
@dynamic status;


+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (void)dealloc {
    [self disposeItem];
}

//override properties
- (NSTimeInterval)duration {
    if (self.player.status != AVPlayerStatusReadyToPlay) {
        return 0;
    }
    CMTime d = self.item.duration;
    return CMTimeGetSeconds(d);
}

//--
- (void)setupWithFile:(NSString *)file {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"sample" ofType:@"m4v"];
    
    NSURL *url = [NSURL fileURLWithPath:path];
    AVAsset *asset = [AVAsset assetWithURL:url];
    self.item = [[AVPlayerItem alloc] initWithAsset:asset];
    [self.item addObserver:self
                forKeyPath:kStatusKey
                   options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                   context:nil];
    
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.item];
    AVPlayerLayer *layer = (AVPlayerLayer *)self.layer;
    layer.player = self.player;
}

- (void)disposeItem {
    if (!self.item) {
        return;
    }
    [self.item removeObserver:self forKeyPath:kStatusKey];
    self.item = nil;
}
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:kStatusKey]) {
        [self.delegate avPlayer:self didStatuChanged:self.player.status];
    }
}

//--------------------------------------------------------
//for playing
- (void)play {
    [self.player play];
}

- (void)pause {
    [self.player pause];
}
- (void)seekTo:(NSTimeInterval)time {
    if (!self.seekingList) {
        self.seekingList = [NSMutableArray array];
    }
    
    [self.seekingList addObject:@(time)];
    if (self.isSeeking) {
        return;
    }
    self.isSeeking = YES;
    [self p_seekToFirstIndexTime];
    
}
- (void)p_seekToFirstIndexTime {
    if (self.seekingList.count == 0) {
        self.isSeeking = NO;
        return;
    }
    NSTimeInterval time = (NSTimeInterval)[self.seekingList[0] doubleValue];
    NSTimeInterval current = CMTimeGetSeconds(self.player.currentTime);
    NSTimeInterval max = 0.03;
    if (fabs(current - time) < max || time < 0) {
        [self.seekingList removeObjectAtIndex:0];
    } else {
        if (time < current) {
            time = current - max;
        } else {
            time = current + max;
        }
    }
    if (time < 0) {
        time = 0;
    }
    
    CMTime cmTime = CMTimeMakeWithSeconds(time, NSEC_PER_SEC);
    CMTime lerance = CMTimeMakeWithSeconds(0.01, NSEC_PER_SEC);
    [self.player seekToTime:cmTime
            toleranceBefore:lerance
             toleranceAfter:lerance
          completionHandler:^(BOOL finished) {
              [self p_seekToFirstIndexTime];
             }];
}

@end
