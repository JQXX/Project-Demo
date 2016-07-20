//
//  QFLrcParser.h
//  OC12_歌词解析
//
//  Created by LZXuan on 15-4-25.
//  Copyright (c) 2015年 LZXuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QFLrcParser : NSObject
{
    NSString *_author; // 歌词作者 [ar:歌词作者]
    NSString *_albume; // 歌词所在的唱片集 [al:这首歌所在的唱片集]
    NSString *_byEditor; // 本lrc编辑作者 [by:本LRC文件的创建者]
    NSString *_title; // 歌曲标题 [ti:歌词(歌曲)的标题]
    NSString *_version; // 歌曲版本 [ve:程序的版本]
    // 1lrc文件有 n个 lrc词条
    NSMutableArray *_allLrcItems;//存放的是QFLRcItem 类的对象地址
}
//- (NSString *) author;
//- (NSString *) albume;
//- (NSString *) byEditor;
//- (NSString *) title;
//- (NSString *) version;

@property (nonatomic,readonly)NSString *author;
@property (nonatomic,readonly)NSString *albume;
@property (nonatomic,readonly)NSString *byEditor;
@property (nonatomic,readonly)NSString *title;
@property (nonatomic,readonly)NSString *version;

// 初始化这个lrc
- (id) initWithFile:(NSString *)file;
// 通过second取得当前的歌词
- (NSString *) getLrcByTime:(float)second;

@end
