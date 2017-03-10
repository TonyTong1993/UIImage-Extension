//
//  LPShareImage.h
//  TYImage
//
//  Created by 童万华 on 2017/3/9.
//  Copyright © 2017年 童万华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LPShareImage : NSObject


/**
 获取游戏详情分享海报

 @param shareTitle 游戏名
 @param path 游戏配图
 @param detail 详情介绍
 @param number 玩家人数
 @return 目标图片
 */
-(UIImage *)shareGameInfo:(NSString *)shareTitle filePath:(NSString *)path detail:(NSString *)detail number:(NSString*)number;

/**
 获取游戏通关分享海报

 @param shareTitle 游戏名
 @param path 游戏配图路径
 @param grades 相关成绩eg：grades = @{@"time":@"1:50:20",@"point":@"26",@"experience":@"10",@"bonus":@"5.0"};
 @param detail 游戏详情
 @return 目标图片
 */
-(UIImage *)shareGamePass:(NSString *)shareTitle filePath:(NSString *)path grades:(NSDictionary *)grades detail:(NSString *)detail;

/**
  获取乐跑结束海报

 @param shareTitle 学习名
 @param path 跑步轨迹
 @param grades 成绩eg： grades = @{@"mileage":@"20.5km",@"speed":@"20'20''",@"time":@"1:50:00",@"point":@"26",@"bonus":@"5.0"};
 @return 海报
 */
-(UIImage *)shareGameEnd:(NSString *)shareTitle filePath:(NSString *)path grades:(NSDictionary *)grades;
@end
