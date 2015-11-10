//
//  DataManager.m
//  MusicPlayer
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 DJJ. All rights reserved.
//

#import "DataManager.h"
#import "MusicModel.h"

@implementation DataManager

// command + control + ⬆️ / ⬇️ 切换.h/.m
static DataManager * manager = nil;

+ (DataManager *)sharedManager
{
    //GCD 提供一种单例方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [DataManager new];
        [manager requestData];
    });
    return manager;
}

- (void)requestData{
    
    // 在子线程中请求数据,防止假死
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 请求数据
        NSArray * dataArray = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:kMusicListURL]];
        
        for (int i = 0; i < dataArray.count; i++) {
//            NSLog(@"%@",dataArray[i]);
            
            MusicModel * music = [MusicModel new];
            [music setValuesForKeysWithDictionary:dataArray[i]];
            [self.musicArray addObject:music];
            
        }
        // 返回主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!self.myBlock) {
                NSLog(@"block 没有代码");
            }else{
                self.myBlock();
            }
        });
    });
    
}

#pragma mark -- 懒加载

- (NSMutableArray *)musicArray
{
    if (!_musicArray) {
        _musicArray = [NSMutableArray array];
    }
    return _musicArray;
}

- (MusicModel *)musicModelWithIndex:(NSInteger)index
{
    return self.musicArray[index];
}



@end
