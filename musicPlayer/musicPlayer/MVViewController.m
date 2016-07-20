//
//  MVViewController.m
//  musicPlayer
//
//  Created by apple on 16/5/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MVViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface MVViewController ()

{
    AVPlayerViewController *_Player;
}

@end

@implementation MVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatPlayer];
}

-(void)creatPlayer{
    
    _Player = [[AVPlayerViewController alloc]init];
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:_songsName ofType:@"mp4"]];
    _Player.player = [[AVPlayer alloc]initWithURL:url];
    [self presentViewController:_Player animated:YES completion:nil];
    
    [_Player.player play];
    
    
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

@end
