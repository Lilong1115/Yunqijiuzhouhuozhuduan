//
//  CityTableViewController.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/13.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

//城市
#import "CityTableViewController.h"
#import "cityModel.h"
#import "MMNavigationController.h"

//ID
static NSString *kCityCellID = @"kCityCellID";

@interface CityTableViewController ()

//数据源
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, weak) UILabel *headerLabel;

@end

@implementation CityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"城市";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCityCellID];
    
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    grayView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    headerLabel.text = @"(省-市-区)";
    headerLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];

    [grayView addSubview:headerLabel];
    
    self.tableView.tableHeaderView = grayView;
    self.headerLabel = headerLabel;
    
    //设置隐藏没有内容显示的线
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self requestDataWithCityID:self.cityID];
    
}

//参数请求城市
- (void)requestDataWithCityID:(NSString *)cityID {

    NSDictionary *parameters;
    
    if (cityID == nil) {
        parameters = nil;
    } else {
        parameters = @{
                       @"id": cityID,
                       };
    }

    
    [[XSJNetworkTool sharedNetworkTool] requestDataWithRequestType:GET andUrlString:CityAddress_URL andParameters:parameters andSuccessBlock:^(id result) {
        
        if ([result[@"msg"] isEqualToString:@"成功"]) {
            
            NSArray *array = result[@"data"];
            
            NSMutableArray *arrayM = [NSMutableArray array];
            
            [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                cityModel *model = [cityModel cityModelWithDict:obj];
                
                [arrayM addObject:model];
            }];
            
            self.dataArray = arrayM.copy;
        }
        
        [self.tableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        
        NSLog(@"%@", error);
    }];
}

//数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCityCellID forIndexPath:indexPath];

    cityModel *model = self.dataArray[indexPath.row];
    
    cell.textLabel.text = model.csmc;
    
    return cell;
}

//代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    cityModel *model = self.dataArray[indexPath.row];
    
    NSString *cityID = model.csbh;
    NSString *city = model.csmc;
    
    CityTableViewController *cityVC = [[CityTableViewController alloc]init];
    
    //MMNavigationController *nav = [[MMNavigationController alloc]initWithRootViewController:cityVC];
    
    NSLog(@"%ld", [model.csxzdj integerValue]);
    
    cityVC.cityID = cityID;
    cityVC.city = [self.headerLabel.text stringByAppendingFormat:@"%@", city];
    
    cityVC.tag = self.tag;
    
    if ([model.csxzdj integerValue] == 0) {
        
        
        [self.navigationController pushViewController:cityVC animated:YES];
        
    } else if ([model.csxzdj integerValue] == 1) {
    
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:CityNotification object:model userInfo:@{
                @"tag": [NSString stringWithFormat:@"%ld", self.tag],                                                                                                    }];
        
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
                
        NSArray *pushVCAry=[self.navigationController viewControllers];
        
        
        //下面的pushVCAry.count-3 是让我回到视图1中去
        
        UIViewController *popVC=[pushVCAry objectAtIndex:pushVCAry.count-3];
 
        [self.navigationController popToViewController:popVC animated:YES];
    }
    
}

//设置城市ID
- (void)setCityID:(NSString *)cityID {

    _cityID = cityID;
    
    [self requestDataWithCityID:cityID];
    
}

- (void)setCity:(NSString *)city {

    _city = city;
    
    self.headerLabel.text = city;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
