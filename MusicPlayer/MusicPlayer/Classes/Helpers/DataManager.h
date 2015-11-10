//
//  DataManager.h
//  MusicPlayer
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 DJJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicModel.h"

typedef void(^UpdateUI)();

@interface DataManager : NSObject

+ (DataManager *)sharedManager;

@property (nonatomic, retain) NSMutableArray * musicArray;

@property (nonatomic, copy) UpdateUI myBlock;

/**
 *  根据cell的索引返回一个model
 *
 *  @param index 索引值
 *
 *  @return model
 */
- (MusicModel *)musicModelWithIndex:(NSInteger)index;


@end
