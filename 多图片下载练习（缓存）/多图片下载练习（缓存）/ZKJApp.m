//
//  ZKJApp.m
//  多图片下载练习（缓存）
//
//  Created by ZKJ on 2016/11/15.
//  Copyright © 2016年 ZKJ. All rights reserved.
//

#import "ZKJApp.h"

@implementation ZKJApp

+ (instancetype)appWithDic:(NSDictionary *)dic
{
    ZKJApp *app = [[self alloc] init];
    [app setValuesForKeysWithDictionary:dic];
    return app;
}

@end
