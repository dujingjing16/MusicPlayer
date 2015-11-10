//
//  PlayingViewController.m
//  MusicPlayer
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 DJJ. All rights reserved.
//

#import "PlayingViewController.h"
#import "PlayerManager.h"
#import "DataManager.h"
#import "LyricManager.h"
#import "LyricModel.h"

@interface PlayingViewController ()<PlayerManagerDelegate,UITableViewDataSource,UITableViewDelegate>

// 记录当前播放的音乐的索引
@property (nonatomic,  assign) NSInteger currentIndex;
// 记录当前正在播放的音乐
@property (nonatomic, strong) MusicModel * currentModel;

#pragma mark -- 控件
@property (strong, nonatomic) IBOutlet UILabel *lab4SongName;
@property (strong, nonatomic) IBOutlet UILabel *lab4SingerName;
@property (strong, nonatomic) IBOutlet UIImageView *img4Pic;
@property (strong, nonatomic) IBOutlet UILabel *lab4PlayedTime;
@property (strong, nonatomic) IBOutlet UILabel *lab4LastTime;
@property (strong, nonatomic) IBOutlet UISlider *slider4Time;
@property (strong, nonatomic) IBOutlet UISlider *slider4Volume;
@property (strong, nonatomic) IBOutlet UIButton *btn4PlayOrPause;
@property (strong, nonatomic) IBOutlet UITableView *tableView4Lyric;
@property (strong, nonatomic) UILabel * volumeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImg;


#pragma mark -- 控件事件
- (IBAction)action4Prev:(UIButton *)sender;
- (IBAction)action4PlayOrPause:(UIButton *)sender;
- (IBAction)action4Next:(UIButton *)sender;
- (IBAction)action4ChangeTime:(UISlider *)sender;
- (IBAction)action4ChangeVolume:(UISlider *)sender;

@end

@implementation PlayingViewController

static NSString * cellIdentifier = @"lyricCell";

static PlayingViewController * playingVC = nil;

+ (instancetype)sharedPlayingPVC
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 拿到main sb
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        // 获取入口指向的视图控制器
        // instantiateInitialViewController
        // 在main sb 拿到我们要用的视图控制器
        playingVC = [sb instantiateViewControllerWithIdentifier:@"playingVC"];
        
    });
    return playingVC;
}
- (IBAction)action4Back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)startPlay{
    
    [[PlayerManager sharedManager] playWithUrlString:self.currentModel.mp3Url];
    
    [self buildUI];
}

- (void)buildUI{
    self.lab4SingerName.text = self.currentModel.singer;
    self.lab4SongName.text = self.currentModel.name;
    [self.img4Pic sd_setImageWithURL:[NSURL URLWithString:self.currentModel.picUrl]];
    [self.backgroundImg sd_setImageWithURL:[NSURL URLWithString:self.currentModel.blurPicUrl]];
    
    [self.slider4Volume setThumbImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
    [self.slider4Time setThumbImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
    [self.slider4Volume addTarget:self action:@selector(sliderChanged:)forControlEvents:UIControlEventValueChanged];
    // 隐藏分割线
    [self.tableView4Lyric setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // 更改button
    [self.btn4PlayOrPause setImage:[UIImage imageNamed:@"Pause"] forState:UIControlStateNormal];
    
     //改变进度条的最大值
    self.slider4Time.maximumValue = [self.currentModel.duration integerValue] / 1000;
    // 重新播放一首歌的时候,设为0
    self.slider4Time.value = 0;
    
    // 更改旋转的角度
    self.img4Pic.transform = CGAffineTransformMakeRotation(0);
    // 解析歌词
    [[LyricManager sharedManager] loadLyricWithString:self.currentModel.lyric];
    // 刷新数据
    [self.tableView4Lyric reloadData];
}

- (void)sliderChanged:(UISlider *) sender{
    
    self.volumeLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 550, 50, 30)];
    _volumeLabel.text = [[NSString alloc]initWithFormat:@"%.0f",100*self.slider4Volume.value];
    _volumeLabel.textAlignment = NSTextAlignmentCenter;
    _volumeLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_volumeLabel];
    
    [UIView animateWithDuration:3 animations:^{
        _volumeLabel.alpha = 0;
    } completion:^(BOOL finished) {
        [_volumeLabel removeFromSuperview];
    }];
}

#pragma mark -- getter方法
// 确保当前播放的音乐是最新的
- (MusicModel *)currentModel
{
    // 取到要播放的model
    MusicModel * music = [[DataManager sharedManager] musicModelWithIndex:self.currentIndex];
    return music;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 如果要播放的音乐跟当前播放的音乐一样,就什么都不干
    if (_index == _currentIndex) {
        return;
    }
    // 如果不等于,则当前播放的音乐改变为要播放的音乐
    _currentIndex = _index;
    [self startPlay];    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currentIndex = -1;
    // 加圆角
    _img4Pic.layer.masksToBounds = YES;
    _img4Pic.layer.cornerRadius = 120;
    // 设置代理
    [PlayerManager sharedManager].delegate = self;
    
    // 注册
    [self.tableView4Lyric registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    self.slider4Volume.value = [[PlayerManager sharedManager] volume];
}

#pragma mark --- 自定义的代理方法

//当播放结束了,开始播放下一首
- (void)playerDidPlayEnd
{
    [self action4Next:nil];
}

// 播放器每0.1秒让代理(也就是这个页面)执行一下这个事件
- (void)playerPlayingWithTime:(NSTimeInterval)time
{
    self.slider4Time.value = time;
    // 已经播放了的时间
    self.lab4PlayedTime.text = [self stringWithTime:time];
    // 剩余时间 = 总时间 - 已经播放了的时间
    NSTimeInterval time1 = [self.currentModel.duration integerValue] / 1000 - time;
    self.lab4LastTime.text = [self stringWithTime:time1];
    
    // 每0.1秒旋转1度
    self.img4Pic.transform = CGAffineTransformRotate(self.img4Pic.transform, M_PI / 180);
    
    // 根据当前播放时间获取到应该播放哪句歌词
    NSInteger index = [[LyricManager sharedManager] indexWithTime:time];
    
    NSIndexPath * path = [NSIndexPath indexPathForRow:index inSection:0];
    // 让tableview选中我们找到的歌词
    [self.tableView4Lyric selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionMiddle];    
    
}
// 根据时间获取到字符串
- (NSString *)stringWithTime:(NSTimeInterval)time
{
    NSInteger minutes = time / 60;
    NSInteger seconds = (int)time % 60;
    if (seconds<10) {
        return [NSString stringWithFormat:@"0%ld:0%ld",minutes,seconds];
    }
    return [NSString stringWithFormat:@"0%ld:%ld",minutes,seconds];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//上一首
- (IBAction)action4Prev:(UIButton *)sender {
    _currentIndex--;
    if (_currentIndex == -1) {
        _currentIndex = [DataManager sharedManager].musicArray.count-1;
    }
    [self startPlay];

}

//暂停或播放
- (IBAction)action4PlayOrPause:(UIButton *)sender {
    // 判断是否正在播放
    if ([PlayerManager sharedManager].isPlaying == YES) {
        // 如果正在播放,就暂停
        [[PlayerManager sharedManager] pause];
        [sender setTitle:@"播放" forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
    }else {
        // 如果暂停就让播放
        [[PlayerManager sharedManager] play];
        [sender setImage:[UIImage imageNamed:@"Pause"] forState:UIControlStateNormal];
   }
}

//下一首
- (IBAction)action4Next:(UIButton *)sender {
    // 在播放下一首的时候先暂停,销毁timer
    [[PlayerManager sharedManager] pause];
    
    _currentIndex++;
    // 判断是否是最后一首
    if (_currentIndex == [DataManager sharedManager].musicArray.count) {
        // 如果是最后一首,就播放第一首
        _currentIndex = 0;
    }
    [self startPlay];
}
// 改变播放进度
- (IBAction)action4ChangeTime:(UISlider *)sender
{
    // 调用接口
    [[PlayerManager sharedManager] seekToTime:sender.value];
    
}
// 改变音量
- (IBAction)action4ChangeVolume:(UISlider *)sender {
    
    [[PlayerManager sharedManager] changeVolume:sender.value];
}

#pragma mark ---- UITableViewDataSource代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [LyricManager sharedManager].allLyric.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [_tableView4Lyric dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    //取到model
    LyricModel * lyric = [LyricManager sharedManager].allLyric[indexPath.row];
    
    cell.textLabel.text = lyric.lyricContext;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}


@end
