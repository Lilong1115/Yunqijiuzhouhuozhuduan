//
//  OilTableViewController.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/14.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import "OilTableViewController.h"
#import "OilModel.h"

static NSString *kCellID = @"kCellID";

@interface OilTableViewController ()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation OilTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"货物类型";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellID];
    
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self requestData];
}

- (void)requestData {

    [[XSJNetworkTool sharedNetworkTool] requestDataWithRequestType:GET andUrlString:OilType_URL andParameters:nil andSuccessBlock:^(id result) {
        
        if ([result[@"msg"] isEqualToString:@"成功"]) {
            
            NSArray *array = result[@"data"];
            NSMutableArray *arrayM = [NSMutableArray array];
            [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                OilModel *model = [OilModel oilModelWithDict:obj];
                [arrayM addObject:model];
            }];
            
            self.dataArray = arrayM.copy;
            
            [self.tableView reloadData];
        }
        
        
    } andFailBlock:^(NSError *error) {
        
        NSLog(@"%@", error);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];
    
    OilModel *model = self.dataArray[indexPath.row];
    
    cell.textLabel.text = model.hwlxmc;
    
    return cell;
}

//代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OilModel *model = self.dataArray[indexPath.row];
    
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:OilTypeNotification object:model userInfo:nil];
    
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
