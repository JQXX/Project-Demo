//
//  SongsInfoViewController.m
//  musicPlayer
//
//  Created by apple on 16/5/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SongsInfoViewController.h"


@interface SongsInfoViewController ()

//{
//    NSString *_path;
//}

@end

@implementation SongsInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //先发后收收不到
//    NSNotificationCenter *cen = [NSNotificationCenter defaultCenter];
//    [cen addObserver:self selector:@selector(reciveNot:) name:@"getSongInfo" object:nil];
    
    [self creatWebView];
    
}

//-(void)reciveNot:(NSNotification *)not{
//    
//    NSDictionary *dic = not.userInfo;
//    _path = dic[@"SongsName"];
//    
//}





-(void)creatWebView{
    
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 375, 617)];
    
    [self.view addSubview:web];
    NSString *str = [NSString stringWithFormat:@"http://www.baidu.com/s?wd=%@",_path];
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:str];
//    NSLog(@"%@",str);
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [web loadRequest:req];
    
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
