//
//  MusicListController.m
//  MusicPlayer
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 DJJ. All rights reserved.
//

#import "MusicListController.h"
#import "MusicCell.h"
#import "DataManager.h"
#import "MusicModel.h"
#import "PlayerManager.h"
#import "PlayingViewController.h"

@interface MusicListController ()

@end

static NSString * cellIdentfier = @"musicCell";

static NSString * customCell = @"customCell";

@implementation MusicListController

// 代码规范,每一个模块之间要空一行

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.barTintColor = [UIColor cyanColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"MusicCell" bundle:nil] forCellReuseIdentifier:customCell];
    
    // 实现block
    [DataManager sharedManager].myBlock = ^(){
        [self.tableView reloadData];
    };
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [DataManager sharedManager].musicArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MusicCell * cell = [tableView dequeueReusableCellWithIdentifier:customCell forIndexPath:indexPath];
    
//    cell.textLabel.text = @"音乐";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    MusicModel * music = [DataManager sharedManager].musicArray[indexPath.row];
    
    MusicModel * music = [[DataManager sharedManager] musicModelWithIndex:indexPath.row];
    cell.music = music;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    MusicCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//    NSLog(@"%@",cell.music);
    
    // 播放音乐
//    [[PlayerManager sharedManager] playWithUrlString:cell.music.mp3Url];
    
    // 拿到模态出来的视图控制器
    PlayingViewController * playingVC = [PlayingViewController sharedPlayingPVC];
    playingVC.index = indexPath.row;
    [self showDetailViewController:playingVC sender:nil];
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
