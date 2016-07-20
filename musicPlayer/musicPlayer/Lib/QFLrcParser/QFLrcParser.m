//
//  QFLrcParser.m
//  OC12_歌词解析
//
//  Created by LZXuan on 15-4-25.
//  Copyright (c) 2015年 LZXuan. All rights reserved.
//

#import "QFLrcParser.h"
#import "QFLrcItem.h"

//类的延展 匿名类别


@interface QFLrcParser ()
//我们经常 把一些不公开的方法 声明在 匿名类别中
- (void)parserLrcFilePath:(NSString *)filePath;
@end

@implementation QFLrcParser

- (id)initWithFile:(NSString *)file {
    if (self = [super init]) {
        //先创建空数组
        _allLrcItems = [[NSMutableArray alloc] init];
        //解析 歌词文件
        [self parserLrcFilePath:file];
    }
    return self;
}
/*
 [02:11.27][01:50.22][00:21.95]穿过幽暗地岁月
 [02:16.51][01:55.46][00:26.83]也曾感到彷徨
 [02:21.81][02:00.60][00:32.30]当你低头地瞬间
 */
//解析歌词文件
- (void)parserLrcFilePath:(NSString *)filePath {
    //1.读文件
    NSString *str = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    //2.解析文件 按照\n分割
    NSArray *arr = [str componentsSeparatedByString:@"\n"];
    //3.遍历数组 解析每一行
    for (NSString *infoStr in arr) {
        if (infoStr.length == 0) {
            continue;
        }
        //4.判断歌词行或者信息行
        unichar c = [infoStr characterAtIndex:1];
        if (c >= '0'&&c <= '9') {
            //5.歌词行
            [self parserLrcLineFromStr:infoStr];
        }else {
            //6.信息行
            [self parserInfoLineFromStr:infoStr];
        }
    }
    
}
//歌词行
//[02:11.27][01:50.22][00:21.95]穿过幽暗地岁月
- (void)parserLrcLineFromStr:(NSString *)str {
    //5.1按照 ] 分割
    NSArray *arr = [str componentsSeparatedByString:@"]"];
    //5.2遍历时间
    for (NSInteger i = 0; i < arr.count-1; i++) {
        //[02:11.27
        //5.3提取  02:11.27
        NSString *timeStr = [arr[i] substringFromIndex:1];
        //5.4 按照 : 分割 转化为 秒
        NSArray *timeArr = [timeStr componentsSeparatedByString:@":"];
        //02  11.27
        float minute = [timeArr[0] floatValue];
        float second = [timeArr[1] floatValue];
       
        //创建数据模型对象 存放歌词
        QFLrcItem *model = [[QFLrcItem alloc] init];
        model.time = minute * 60+ second;
        model.lrc = [arr lastObject];//数组的最后一个元素就是歌词
        
        //放入数组管理
        [_allLrcItems addObject:model];
    }
    //7.解析完毕排序  升序
    [_allLrcItems sortUsingSelector:@selector(isTimeOldThanAnother:)];
    
}

/*
 [ti:蓝莲花]

 */
//解析信息行
- (void)parserInfoLineFromStr:(NSString *)str {
    //6.1按照 : 分割
    NSArray *arr = [str componentsSeparatedByString:@":"];
    NSString *newStr = arr[0];
    NSInteger len = [arr[1] length];
    if ([newStr isEqualToString:@"[ti"]) {
        _title = [arr[1] substringToIndex:len-1];
    }else if ([newStr isEqualToString:@"[ar"]) {
        _author = [arr[1] substringToIndex:len-1];
    }else if ([newStr isEqualToString:@"[al"]) {
        _albume = [arr[1] substringToIndex:len-1];
    }else if ([newStr isEqualToString:@"[by"]) {
        _byEditor = [arr[1] substringToIndex:len-1];
    }else if ([newStr isEqualToString:@"[ve"]) {
        _version = [arr[1] substringToIndex:len-1];
    }
}


//获取歌词
- (NSString *)getLrcByTime:(float)second {
    NSInteger index = -2;
    //遍历数组 找 第一个 比second得时间
    for (NSInteger i = 0;i < _allLrcItems.count;  i++) {
        QFLrcItem *model = _allLrcItems[i];
        if (model.time > second) {
            index = i-1;//找到之后退出循环
            break;
        }
    }
    if (index == -1) {
        index = 0;//表示应该显示第0条
    }else if (index == -2)//表示 没有找到 最大的
    {
        //显示最后一条
        index = _allLrcItems.count-1;
    }
    
    return  [_allLrcItems[index] lrc];
}

//数组新特性 arr[i]  等价于 [arr objectAtIndex:i];
@end






