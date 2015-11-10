//
//  LyricManager.h
//  MusicPlayer
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 DJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricManager : NSObject

+ (instancetype)sharedManager;

- (void)loadLyricWithString:(NSString *)lyricStr;

// 用来存放歌词
@property (nonatomic, strong) NSArray * allLyric;

/**
 *  根据播放时间获取到该播放的歌词索引
 *
 *  @param time <#time description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)indexWithTime:(NSInteger)time;

@end
