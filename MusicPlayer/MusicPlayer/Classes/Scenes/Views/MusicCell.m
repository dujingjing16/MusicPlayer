//
//  MusicCell.m
//  MusicPlayer
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 DJJ. All rights reserved.
//

#import "MusicCell.h"

@implementation MusicCell

// 重写set方法
- (void)setMusic:(MusicModel *)music
{
    _music = music;       // 不写的话,点击cell,cell上取model的时候打印为空
    _nameLabel.text = music.name;
    _singerLabel.text = music.singer;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:music.picUrl]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
