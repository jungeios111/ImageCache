//
//  ViewController.m
//  多图片下载练习（缓存）
//
//  Created by ZKJ on 2016/11/15.
//  Copyright © 2016年 ZKJ. All rights reserved.
//

#import "ViewController.h"
#import "ZKJApp.h"

@interface ViewController ()

/** 所有的数据 */
@property(nonatomic,strong) NSArray *dataArray;
/** 内存缓存 */
@property(nonatomic,strong) NSMutableDictionary *imageDic;
/** 存所有的任务对象 */
@property(nonatomic,strong) NSMutableDictionary *operationDic;
/** 任务队列 */
@property(nonatomic,strong) NSOperationQueue *queue;

@end

@implementation ViewController

- (NSMutableDictionary *)imageDic
{
    if (!_imageDic) {
        _imageDic = [NSMutableDictionary dictionary];
    }
    return _imageDic;
}

- (NSMutableDictionary *)operationDic
{
    if (!_operationDic) {
        _operationDic = [NSMutableDictionary dictionary];
    }
    return _operationDic;
}

- (NSOperationQueue *)queue
{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 3;
    }
    return _queue;
}

- (NSArray *)dataArray
{
    if (!_dataArray) {
        NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"apps" ofType:@"plist"]];
        NSMutableArray *appArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            [appArray addObject:[ZKJApp appWithDic:dic]];
        }
        _dataArray = appArray;
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"这是一个测试demo");
    NSLog(@"这是一个测试demo");
    NSLog(@"这是一个测试demo");
    NSLog(@"这是一个测试demo");
    NSLog(@"这是一个测试demo");
    NSLog(@"这是一个测试demo");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    static NSString *cellName = @"zkjApp";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    ZKJApp *app = self.dataArray[row];
    cell.textLabel.text = app.name;
    cell.detailTextLabel.text = app.download;
    
    UIImage *image = self.imageDic[app.icon];
    if (image) {
        cell.imageView.image = image;
    } else {
        NSString *cachesFile = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *imageFile = [app.icon lastPathComponent];
        NSString *file = [cachesFile stringByAppendingPathComponent:imageFile];
        NSData *data = [NSData dataWithContentsOfFile:file];
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            cell.imageView.image = image;
            self.imageDic[app.icon] = image;
        } else {
            cell.imageView.image = [UIImage imageNamed:@"placeholder"];
            NSOperation *operation = self.operationDic[app.icon];
            if (operation == nil) {
                operation = [NSBlockOperation blockOperationWithBlock:^{
                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:app.icon]];
                    if (data == nil) {
                        [self.operationDic removeObjectForKey:app.icon];
                        return ;
                    }
                    UIImage *image = [UIImage imageWithData:data];
                    self.imageDic[app.icon] = image;
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }];
                    [data writeToFile:file atomically:YES];
                    [self.operationDic removeObjectForKey:app.icon];
                }];
                [self.queue addOperation:operation];
                self.operationDic[app.icon] = operation;
            }
        }
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.imageDic = nil;
    self.operationDic = nil;
    [self.queue cancelAllOperations];
}


@end
