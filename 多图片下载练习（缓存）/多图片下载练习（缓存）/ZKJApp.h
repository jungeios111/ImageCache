//
//  ZKJApp.h
//  多图片下载练习（缓存）
//
//  Created by ZKJ on 2016/11/15.
//  Copyright © 2016年 ZKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKJApp : NSObject

/** 名字 */
@property(nonatomic,copy) NSString *name;
/** 图片 */
@property(nonatomic,copy) NSString *icon;
/** 下载量 */
@property(nonatomic,copy) NSString *download;

+ (instancetype)appWithDic:(NSDictionary *)dic;

@end
