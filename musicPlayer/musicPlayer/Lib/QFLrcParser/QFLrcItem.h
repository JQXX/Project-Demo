//
//  QFLrcItem.h
//  OC12_歌词解析
//
//  Created by LZXuan on 15-4-25.
//  Copyright (c) 2015年 LZXuan. All rights reserved.
//

#import <Foundation/Foundation.h>

//封装一个数据模型类
/*
 *解析文件时我们需要存储歌词和时间 ，时间和歌词是一个整体，那么我们一般会设计一个数据模型类 专门来存放这个整体的数据
 
 [02:11.27][01:50.22][00:21.95]穿过幽暗地岁月
 [02:16.51][01:55.46][00:26.83]也曾感到彷徨
 [02:21.81][02:00.60][00:32.30]当你低头地瞬间
 
 */
@interface QFLrcItem : NSObject
{
    float _time;
    NSString *_lrc;
}

@property (nonatomic) float time;
@property (nonatomic) NSString *lrc;
- (BOOL)isTimeOldThanAnother:(QFLrcItem *)another;
@end
