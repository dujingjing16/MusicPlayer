//
//  MusicCell.h
//  MusicPlayer
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 DJJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicModel.h"

@interface MusicCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *singerLabel;
@property (nonatomic, retain) MusicModel * music;
@end
