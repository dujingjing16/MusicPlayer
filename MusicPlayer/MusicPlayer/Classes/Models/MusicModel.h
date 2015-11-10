//
//  MusicModel.h
//  MusicPlayer
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 DJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * mp3Url;
@property (nonatomic, retain) NSString * ID;
@property (nonatomic, retain) NSString * singer;
@property (nonatomic, retain) NSString * lyric;
@property (nonatomic, retain) NSString * picUrl;
@property (nonatomic, retain) NSString * blurPicUrl;
@property (nonatomic, retain) NSString * album;
@property (nonatomic, retain) NSString * duration;
@property (nonatomic, retain) NSString * artists_name;

@end
