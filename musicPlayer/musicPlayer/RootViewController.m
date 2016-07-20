//
//  RootViewController.m
//  musicPlayer
//
//  Created by apple on 16/5/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "RootViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QFLrcParser.h"
#import "MVViewController.h"
#import "SongsInfoViewController.h"
#import "SwitchPicViewController.h"

@interface RootViewController ()<AVAudioPlayerDelegate>

{
    AVAudioPlayer *_player;
    BOOL startBtnIsSelect;
    BOOL circleBtnIsSelect;
    BOOL oneSongBtnIsSelect;
    @protected NSInteger songsNumb;
    NSMutableArray *_songsList;
    NSMutableArray *_oriSongsList;
    float songDuration;
    float songCurTime;
    NSTimer *_songCurrentTime;
    int miao;
    int fen;
    int timeTag;
    QFLrcParser *_lrcPar;
    BOOL rightBtnIsClick;
    
}

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self creatPlayList];
    [self creatBtn];
    [self showSongsName];
    [self creatPlayer];
    [self setTimeLine];
    [self createSlider];
    [self creatLyiLab];
    [self customNavigationBtn];
    [self creatSongsInfoBtn];
    
}

-(void)creatBtn{
    
    startBtnIsSelect = NO;
    circleBtnIsSelect = NO;
    songsNumb = 0;
    
#pragma mark 三个主按钮
    for (int n = 1; n < 4; n++) {
        NSString *str = [NSString stringWithFormat:@"%d",n];
        int i = n * 100;
        UIButton *btu = [[UIButton alloc]initWithFrame:CGRectMake(-37.5 + i, 600, 50, 50)];
        [self.view addSubview:btu];
        btu.tag = n;
        [btu setBackgroundImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
        }
    UIButton *up = [self.view viewWithTag:1];
    UIButton *play = [self.view viewWithTag:2];
    UIButton *next = [self.view viewWithTag:3];
    
    [play addTarget:self action:@selector(selectPlayBtn) forControlEvents:UIControlEventTouchUpInside];
    [next addTarget:self action:@selector(selectNextBtn) forControlEvents:UIControlEventTouchUpInside];
    [up addTarget:self action:@selector(selectUpBtn) forControlEvents:UIControlEventTouchUpInside];
    
#pragma mark 循环和随机
    UIButton *circleBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 640, 20, 20)];
    [self.view addSubview:circleBtn];
    circleBtn.tag = 4;
    [circleBtn setBackgroundImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
    [circleBtn addTarget:self action:@selector(selectCircleBtn) forControlEvents:UIControlEventTouchUpInside];
    
#pragma mark 单曲循环
    UIButton *oneSong = [[UIButton alloc]initWithFrame:CGRectMake(345, 640, 20, 20)];
    [self.view addSubview:oneSong];
    oneSong.tag = 5;
    [oneSong setBackgroundImage:[UIImage imageNamed:@"oneSong"] forState:UIControlStateNormal];
    oneSong.alpha = 0.4;
    [oneSong addTarget:self action:@selector(selectOneSongBtn) forControlEvents:UIControlEventTouchUpInside];
 
}

#pragma mark 播放暂停
-(void)selectPlayBtn{
    
    UIButton *play = [self.view viewWithTag:2];

    if (startBtnIsSelect == NO) {
        [play setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [_player play];
        startBtnIsSelect = YES;
    }else{
        startBtnIsSelect = NO;
        [play setBackgroundImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
        [_player pause];
    }
}

#pragma mark 下一首
-(void)selectNextBtn{

    if (songsNumb == _songsList.count - 1) {
        songsNumb = 0;
    }else{
    songsNumb++;
    }
    [self creatPlayer];
    if (startBtnIsSelect == YES) {
        [_player play];
    }
}
#pragma mark 上一首
-(void)selectUpBtn{
    
    if (songsNumb == 0) {
        songsNumb =_songsList.count - 1;
    }else{
        songsNumb--;
    }
    [self creatPlayer];
    if (startBtnIsSelect == YES) {
        [_player play];
    }
}
#pragma mark 循环随机方法
-(void)selectCircleBtn{
    
    UIButton *ranBtn = [self.view viewWithTag:4];
    
    if (circleBtnIsSelect == NO) {
        [ranBtn setBackgroundImage:[UIImage imageNamed:@"randon"] forState:UIControlStateNormal];
        
        NSMutableArray *randonArr = [[NSMutableArray alloc]init];
        for (int n = 0; n < _oriSongsList.count; n++) {
            NSString *songsss = _songsList[arc4random() % _songsList.count];
            [randonArr addObject:songsss];
            [_songsList removeObject:songsss];
        }
        _songsList = [NSMutableArray arrayWithArray:randonArr];
        
        circleBtnIsSelect = YES;
    }else{
        circleBtnIsSelect = NO;
        [ranBtn setBackgroundImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
        _songsList = [NSMutableArray arrayWithArray:_oriSongsList];
    }
}
#pragma mark 单曲方法
-(void)selectOneSongBtn{
    UIButton *oneSong = [self.view viewWithTag:5];
    
    if (oneSongBtnIsSelect == NO) {
        oneSongBtnIsSelect = YES;
        oneSong.alpha = 1;
        NSMutableArray *oneSongArr = [NSMutableArray arrayWithObject:_songsList[songsNumb]];
        [_songsList removeAllObjects];
        _songsList = [NSMutableArray arrayWithArray:oneSongArr];
        songsNumb = 0;
    }else{
        _songsList = [NSMutableArray arrayWithArray:_oriSongsList];
        oneSongBtnIsSelect = NO;
        oneSong.alpha = 0.4;
    }
}

#pragma mark 显示歌名
-(void)showSongsName{
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 400, 375, 30)];
    [self.view addSubview:lab];
    lab.text = _songsList[songsNumb];
    lab.textColor = [UIColor blackColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont boldSystemFontOfSize:25];
    lab.tag = 88;
}

#pragma mark 创建歌单
-(void)creatPlayList{
    
    _songsList = [[NSMutableArray alloc]init];
//    NSFileManager *fm = [NSFileManager defaultManager];
//    NSArray *arr = [fm subpathsOfDirectoryAtPath:@"/Users/apple/Documents/作业/16.5.13/musicPlayer/icon/音乐播放器素材/music" error:nil];
    NSArray *arr = @[@"Beat It",@"Poker Face",@"像梦一样自由",@"北京北京",@"春天里",@"江南-style",@"狐狸叫",@"蓝莲花"];
//    NSString *musicName = [[NSString alloc]init];
    for (NSString *str in arr) {
//        if ([str hasSuffix:@"mp3"]) {
//            NSRange rag = [str rangeOfString:@".mp3"];
//            musicName = [str substringToIndex:rag.location];
            [_songsList addObject:str];
//        }
    }
    _oriSongsList = [[NSMutableArray alloc]initWithArray:_songsList];
}

#pragma mark 创建播放对象
-(void)creatPlayer{
    //找到歌曲
    NSString *path = [[NSBundle mainBundle]pathForResource:_songsList[songsNumb] ofType:@"mp3"];
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    _player.delegate = self;
    [_player stop];
    //歌名
    UILabel *songsName = [self.view viewWithTag:88];
    songsName.text = _songsList[songsNumb];
    
    //通知传值——fail,先发后收收不到
//    NSNotification *not = [[NSNotification alloc]initWithName:@"getSongInfo" object:nil userInfo:@{@"SongsName":_songsList[songsNumb]}];
//    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//    [center postNot       ification:not];
    
    rightBtnIsClick = NO;
    //时间条
    songDuration = _player.duration;
    UILabel *durLab = [self.view viewWithTag:44];
    NSString *durStr = [NSString stringWithFormat:@"%d:%.2d",(int)songDuration / 60,(int)songDuration - (((int)songDuration / 60) * 60)];
    durLab.text = durStr;
    UILabel *curLab = [self.view viewWithTag:45];
    curLab.text = @"0:00";
    
    UISlider *sli = [self.view viewWithTag:33];
    sli.value = 0;
    
    [self setSongsPic];//歌曲图片
    [self creatLrcPar:path];
    
}

#pragma mark 播放一曲完成
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{

        if (songsNumb == _songsList.count - 1) {
            songsNumb = 0;
        }else{
            songsNumb++;
        }
        [self creatPlayer];
        [_player play];
        [self setSongsPic];

}

#pragma mark 歌曲图片
-(void)setSongsPic{
    
    UIImageView *songsView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, 375, 315)];
    [self.view addSubview:songsView];
    songsView.tag = 26;
    
    NSString *path = [[NSBundle mainBundle]pathForResource:_songsList[songsNumb] ofType:@"jpg"];
    UIImage *songPic = [[UIImage alloc]initWithContentsOfFile:path];
    songsView.image =songPic;
}


#pragma mark slider时间轴
-(void)createSlider{

    UISlider *sli = [[UISlider alloc]initWithFrame:CGRectMake(50, 560, 268, 40)];
    [self.view addSubview:sli];
    sli.minimumTrackTintColor = [UIColor blackColor];
    [sli setThumbImage:[UIImage imageNamed:@"TimeTag"] forState:UIControlStateNormal];
    
    sli.tag = 33;
    
    [sli addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    
}
//时间轴方法
-(void)sliderChange:(UISlider *)sld{

    _player.currentTime = sld.value * _player.duration ;
    UILabel *curLab = [self.view viewWithTag:45];
    curLab.text = [NSString stringWithFormat:@"%d:%.2d",(int)_player.currentTime/60,((int)_player.currentTime)%60];
    
    UILabel *lrcLab = [self.view viewWithTag:47];
    lrcLab.text = [_lrcPar getLrcByTime:_player.currentTime];
}

#pragma mark 时间显示
-(void)setTimeLine{
    
    //总时间
    UILabel *durLab = [[UILabel alloc]initWithFrame:CGRectMake(290, 570, 75, 20)];
    [self.view addSubview:durLab];
    durLab.tag = 44;
    NSString *durStr = [NSString stringWithFormat:@"%d:%.2d",(int)songDuration / 60,(int)songDuration - (((int)songDuration / 60) * 60)];
    durLab.text = durStr;
    durLab.textColor = [UIColor blackColor];
    durLab.textAlignment = NSTextAlignmentRight;
    
    //当前时间
    UILabel *curLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 570, 40, 20)];
    [self.view addSubview:curLab];
    curLab.tag = 45;
    curLab.text = @"0:00";
    curLab.textColor = [UIColor blackColor];
    _songCurrentTime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeGo) userInfo:nil repeats:YES];
    
}

//定时器
-(void)timeGo{
    
    UILabel *curLab = [self.view viewWithTag:45];
    UISlider *sld = [self.view viewWithTag:33];
    sld.value = _player.currentTime / _player.duration;
    curLab.text = [NSString stringWithFormat:@"%d:%.2d",(int)_player.currentTime/60,((int)_player.currentTime)%60];
    
    UILabel *lrcLab = [self.view viewWithTag:47];
    lrcLab.text = [_lrcPar getLrcByTime:_player.currentTime];
    
    
    //wifi密码G3ek0a9s
}

#pragma mark 歌词
-(void)creatLyiLab{
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(30, 440, 315, 100)];
    lab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lab];
    lab.tag = 47;
    lab.numberOfLines = 0;
    lab.textColor = [UIColor grayColor];
    
}
-(void)creatLrcPar:(NSString *)path{
    
    NSString *lrcPath = [path stringByReplacingOccurrencesOfString:@"mp3" withString:@"lrc"];
    _lrcPar = [[QFLrcParser alloc]initWithFile:lrcPath];
    
}

#pragma mark 右ncBtn
-(void)customNavigationBtn{
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"leftBtn"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickLiftBtn)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}

-(void)clickLiftBtn{
    
    UIView *view = [self.view viewWithTag:19];
    
    if (rightBtnIsClick == NO) {
        [self.view bringSubviewToFront:view];
        view.hidden = NO;
        rightBtnIsClick = YES;
    }else{
        view.hidden = YES;
        rightBtnIsClick = NO;
    }
    
    
    
}

#pragma mark 建立歌曲信息
-(void)creatSongsInfoBtn{
    
    NSArray *arr = @[@"歌曲信息",@"更换封面",@"MV"];
    
    UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(240, 60, 135, 117)];
    [self.view addSubview:infoView];
    infoView.backgroundColor = [UIColor blackColor];
    infoView.alpha = 0.7;
    infoView.tag = 19;
    
    for (int n = 0; n < 3; n++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, n*40, 135, 37)];
        btn.tag = n+21;
        btn.backgroundColor = [UIColor whiteColor];
        btn.alpha = 0.7;
        [infoView addSubview:btn];
        [btn setTitle:arr[n] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickInfoBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    infoView.hidden = YES;
    
}

-(void)clickInfoBtn:(UIButton *)btn{
    
    if (btn.tag == 21) {
        
        SongsInfoViewController *svc = [[SongsInfoViewController alloc]init];
        svc.path = _songsList[songsNumb];
        [self.navigationController pushViewController:svc animated:YES];
    }else if (btn.tag == 22){
        
        SwitchPicViewController *svc = [[SwitchPicViewController alloc]init];
        [self.navigationController pushViewController:svc animated:YES];
        
    }else if (btn.tag == 23){
        
        MVViewController *mvc = [[MVViewController alloc]init];
        mvc.songsName = _songsList[songsNumb];
        [self.navigationController pushViewController:mvc animated:YES];
        
    }
    
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
