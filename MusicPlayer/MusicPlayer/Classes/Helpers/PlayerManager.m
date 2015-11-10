//
//  PlayerManager.m
//  MusicPlayer
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 DJJ. All rights reserved.
//

#import "PlayerManager.h"
#import <AVFoundation/AVFoundation.h>
#import "PlayingViewController.h"

@interface PlayerManager ()
// 计时器
@property (nonatomic, strong) NSTimer * timer;

// 播放器 -> 全局唯一,因为如果有两个播放器的话,就会同时播放两个音乐
@property (nonatomic, strong) AVPlayer * player;

@end

@implementation PlayerManager

static PlayerManager * manager = nil;
// 单例方法
+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [PlayerManager new];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {

        // 添加通知中心,当self 发出AVPlayerItemDidPlayToEndTimeNotification时触发playerDidPlayEnd事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidPlayEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
    }
    return self;
}

- (void)changeVolume:(CGFloat)volume
{
    self.player.volume = volume;
}

- (CGFloat)volume
{
    return self.player.volume;
}

#pragma mark --- 切歌的功能
- (void)playerDidPlayEnd:(NSNotification *)not
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerDidPlayEnd)]) {
        // 接收到item播放结束后,让代理去干一件事情,代理会怎么干,播放器不需要知道
        [self.delegate playerDidPlayEnd];
    }
}

#pragma mark -- 对外
// 给一个链接,让AVPlayer播放
- (void)playWithUrlString:(NSString *)urlStr{
    // 创建一个item
    AVPlayerItem * item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:urlStr]];
    // 对item添加观察者
    // 观察item的状态
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    // 替换当前正在播放的音乐
    [self.player replaceCurrentItemWithPlayerItem:item];
    
}

// 懒加载
- (AVPlayer *)player
{
    if (!_player) {
        _player = [AVPlayer new];
    }
    return _player;
}

#pragma mark -- 观察响应

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
//    NSLog(@"%@",keyPath);
//    NSLog(@"%@",change);
    
    //先把正在播放的观察者移除掉
    if (self.player.currentItem) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    AVPlayerItemStatus status = [change[@"new"]  integerValue];
    switch (status) {
        case AVPlayerItemStatusFailed:
            NSLog(@"加载失败");
            break;
        case AVPlayerItemStatusUnknown:
            NSLog(@"资源不对");
            break;
        case AVPlayerItemStatusReadyToPlay:
            NSLog(@"准备好了,可以播放了");
            // 开始播放
            // 先暂停,将NSTimer销毁,然后再播放,创建NSTimer
            [self pause];
            [self play];
            break;
        default:
            break;
    }
    
}

- (void)play
{
    // 如果正在播放,不做处理,就直接返回
    if (_isPlaying == YES) {
        return;
    }
    [self.player play];
    // 开始播放设为YES
    _isPlaying = YES;
    
    // 添加计时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playingWithSeconds) userInfo:nil repeats:YES];
    
}

- (void)playingWithSeconds
{
//    NSLog(@"%lld",self.player.currentTime.value / self.player.currentTime.timescale);
    // 计算一下播放器现在的播放秒数
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerPlayingWithTime:)]) {
        NSTimeInterval time = self.player.currentTime.value / self.player.currentTime.timescale;
        [self.delegate playerPlayingWithTime:time];
    }
}

- (void)pause
{
    [self.player pause];
    // 暂停播放后设为NO
    _isPlaying = NO;
    
    [_timer invalidate];
}

- (void)seekToTime:(NSTimeInterval)time
{
    [self pause];
    // 获取歌曲秒数 = value / timescale
    [self.player seekToTime:CMTimeMakeWithSeconds(time, self.player.currentTime.timescale) completionHandler:^(BOOL finished) {
        if (finished) {
            // 拖拽成功后再播放
            [self play];
        }
    }];
}



@end






