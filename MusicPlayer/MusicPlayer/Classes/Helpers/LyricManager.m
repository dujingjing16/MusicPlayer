//
//  LyricManager.m
//  MusicPlayer
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 DJJ. All rights reserved.
//

#import "LyricManager.h"
#import "LyricModel.h"

@interface LyricManager ()
// 用来存放歌词
@property (nonatomic, strong) NSMutableArray * lyrics;

@end

@implementation LyricManager

static LyricManager * manager = nil;

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [LyricManager new];
    });
    return manager;
}

// 解析
- (void)loadLyricWithString:(NSString *)lyricStr
{
    // 1.分行
    // componentsSeparatedByString:字符串分割的方法，返回是一个数组，根据你分隔符不一样，数组中的对象数也不同
    NSMutableArray * lyricArray = [[lyricStr componentsSeparatedByString:@"\n"] mutableCopy];
    
    //    if (lyricArray.count == 0) {
    //        return;
    //    }else{
    
    // 最后一行是空@""
    // 所以需要将最后一行移除
    [lyricArray removeLastObject];
    
    // 先将之前歌曲的歌词移除
    [self.lyrics removeAllObjects];
    
    if ([lyricStr isEqualToString:@""]) {
        LyricModel * model = [[LyricModel alloc] initWithTime:1 lyric:@"暂无歌词"];
        [self.lyrics addObject:model];
        
    }else {

    for (NSString * str in lyricArray) {
//        if ([str isEqualToString:@""]) {
//            break;
//        }
        // 2.分开时间和歌词
        NSArray * timeAndLyric = [str componentsSeparatedByString:@"]"];
        if (timeAndLyric.count != 2) {
            continue;
        }
        
//        if (![timeAndLyric[0] isEqualToString:@""]) {
        
        // 3.去掉时间左边的“[”
        NSString * time = [timeAndLyric[0] substringFromIndex:1];
        // time = 02:32.080
        // 4.截取时间获取分和秒
        NSArray * minuteAndSecond = [time componentsSeparatedByString:@":"];
        // 分
        NSInteger minute = [minuteAndSecond[0] integerValue];
        // 秒
        double second = [minuteAndSecond[1] doubleValue];
        // 5.装成一个model
        LyricModel * model = [[LyricModel alloc] initWithTime:(minute * 60 + second) lyric:timeAndLyric[1]];
        // 6.添加到数组中
        [self.lyrics addObject:model];
            
        }
    }
}

- (NSMutableArray *)lyrics
{
    if (!_lyrics) {
        _lyrics = [NSMutableArray array];
    }
    return _lyrics;
}

- (NSArray *)allLyric
{
    return self.lyrics;
}

- (NSInteger)indexWithTime:(NSInteger)time
{
    NSInteger index = 0;
    //遍历数组,找到还没有播放的哪句歌词
    for (int i = 0; i < self.lyrics.count; i++) {
        LyricModel * model = self.lyrics[i];
        if (model.time > time) {
            // 注意如果是第0个元素,而且元素时间比要播放的时间大,i-1就会小于0,这样tableView就会crash
            index = ( i - 1 > 0) ? i - 1 : 0;
            // 一定要break,要不就会一直循环下去
            break;
        }
    }
    return index;
}



@end
