//
//  DeliveryTableViewController.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/13.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import "DeliveryTableViewController.h"
#import "FirstTableViewCell.h"
#import "SecondTableViewCell.h"
#import "ThirdTableViewCell.h"
#import "CityTableViewController.h"
#import "OilTableViewController.h"
#import "MapViewController.h"
#import "MMNavigationController.h"
#import "cityModel.h"
#import "OilModel.h"
#import "DeliveryMenuModel.h"
#import "BLDatePickerView.h"
#import "UserInfo.h"
#import "DeliveryModel.h"

//ID
static NSString *kFirstTableViewCellID = @"kFirstTableViewCellID";

static NSString *kSecondTableViewCellID = @"kSecondTableViewCellID";

static NSString *kThirdTableViewCellID = @"kThirdTableViewCellID";


@interface DeliveryTableViewController ()<BLDatePickerViewDelegate>

//菜单数组
@property (nonatomic, strong) NSArray *menuArray;

//日期选择器
@property (nonatomic, strong) BLDatePickerView *datePickerView;

//订单模型
@property (nonatomic, strong) DeliveryModel *deliveryModel;

//出发地城市模型
@property (nonatomic, strong) cityModel *startModel;
//目的地城市模型
@property (nonatomic, strong) cityModel *endModel;
//货物类型模型
@property (nonatomic, strong) OilModel *oilModel;
//装货地址
@property (nonatomic, copy) NSString *loadAddress;
//装货纬度
@property (nonatomic, copy) NSString *loadLatitude;
//装货经度
@property (nonatomic, copy) NSString *loadLongitude;
//卸货地址
@property (nonatomic, copy) NSString *unloadAddress;
//卸货纬度
@property (nonatomic, copy) NSString *unloadLatitude;
//卸货经度
@property (nonatomic, copy) NSString *unloadLongitude;
//中转地址
@property (nonatomic, copy) NSString *transitAddress;
//中转纬度
@property (nonatomic, copy) NSString *transitLatitude;
//中转经度
@property (nonatomic, copy) NSString *transitLongitude;
//发货日期
@property (nonatomic, copy) NSString *date;
//全部内容
@property (nonatomic, strong) NSMutableDictionary *contentDict;
//是否含税
@property (nonatomic, copy) NSString *tick;

//出发地颜色
@property (nonatomic, strong) UIColor *startColor;
//目的地颜色
@property (nonatomic, strong) UIColor *endColor;

@end

@implementation DeliveryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.menuArray = [DeliveryMenuModel deliveryMenuArray];
    
    self.tableView.bounces = NO;
    
    //注册
    //[self.tableView registerClass:[FirstTableViewCell class] forCellReuseIdentifier:kFirstTableViewCellID];
    //[self.tableView registerClass:[SecondTableViewCell class] forCellReuseIdentifier:kSecondTableViewCellID];
    //[self.tableView registerClass:[ThirdTableViewCell class] forCellReuseIdentifier:kThirdTableViewCellID];
    
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 80)];
    
    //提交按钮
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit addTarget:self action:@selector(clickSubmitButton) forControlEvents:UIControlEventTouchUpInside];
    [submit setTitle:@"提交" forState:UIControlStateNormal];
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submit setBackgroundColor:[UIColor redColor]];
    submit.frame = CGRectMake(16, 20, ScreenW - 16 * 2, 40);
    submit.layer.cornerRadius = 5;
    submit.layer.masksToBounds = YES;
    [footer addSubview:submit];
    
    footer.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.tableView.tableFooterView = footer;
    
    self.tick = @"0";
    self.startColor = [UIColor blackColor];
    self.endColor = [UIColor blackColor];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedCity:) name:CityNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedOilType:) name:OilTypeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedAddress:) name:AddressNotification object:nil];
    
}


//提交按钮
- (void)clickSubmitButton {
    
    [self.tableView endEditing:YES];
    
    self.startColor = [UIColor blackColor];
    self.endColor = [UIColor blackColor];
    
    if (self.startModel == nil || self.endModel == nil) {
        
        if (self.startModel == nil) {
            self.startColor = [UIColor redColor];
        }
        
        if (self.endModel == nil) {
            self.endColor = [UIColor redColor];
        }
        
        //刷新第1行
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        
        JCAlertController *alert = [JCAlertController alertWithTitle:@"提示" message:@"请完善标题变红的信息!" type:JCAlertTypeNormal];
        
        [alert addButtonWithTitle:@"取消" type:JCButtonTypeCancel clicked:^{
            
        }];
        
        [self jc_presentViewController:alert presentType:JCPresentTypeFIFO presentCompletion:^{

        } dismissCompletion:^{
            
        }];
        
    } else {
        
        [self submitData];
    }
    
}


//判断是否为空值
- (NSString *)getStr:(NSString *)str {

    if (self.contentDict[str]) {
        return self.contentDict[str];
    } else {
        return nil;
    }
}


//提交
- (void)submitData {
 
    JCAlertController *alert = [JCAlertController alertWithTitle:@"提交订单" message:@"确认提交?" type:JCAlertTypeNormal];
    
    [alert addButtonWithTitle:@"取消" type:JCButtonTypeWarning clicked:nil];
    [alert addButtonWithTitle:@"确定" type:JCButtonTypeWarning clicked:^{
        
        self.deliveryModel.fhdbz = [self getStr:@"15"];
        self.deliveryModel.fhdhwzl = [self getStr:@"2"];
        self.deliveryModel.fhdjscs = self.endModel.csbh;
        self.deliveryModel.fhdkscs = self.startModel.csbh;
        self.deliveryModel.fhdkspc = [self getStr:@"6"];
        self.deliveryModel.fhdthrq = self.date;
        self.deliveryModel.fhdxhcsxx = self.unloadAddress;
        self.deliveryModel.fhdxhzb = [NSString stringWithFormat:@"%@-%@", self.unloadLongitude, self.unloadLatitude];
        self.deliveryModel.fhdydj = [self getStr:@"3"];
        self.deliveryModel.fhdyfdj = [self getStr:@"4"];
        self.deliveryModel.fhdyskdl = [self getStr:@"5"];
        self.deliveryModel.fhdzhcsxx = self.loadAddress;
        self.deliveryModel.fhdzhzb = [NSString stringWithFormat:@"%@-%@", self.loadLongitude, self.loadLatitude];
        self.deliveryModel.jscs = self.endModel.csmc;
        self.deliveryModel.kscs = self.startModel.csmc;
        self.deliveryModel.uuid = [UserInfo account].uuid;
        self.deliveryModel.xhlxrmc = [self getStr:@"12"];
        self.deliveryModel.zzdz = self.transitAddress;
        self.deliveryModel.zzjwd = [NSString stringWithFormat:@"%@-%@", self.transitLongitude, self.transitLatitude];
        self.deliveryModel.xhlxrsjh = [self getStr:@"13"];
        self.deliveryModel.zhlxrmc = [self getStr:@"9"];
        self.deliveryModel.zhlxrsjh = [self getStr:@"10"];
        self.deliveryModel.sfhs = self.tick;
        self.deliveryModel.fhdhwlx = [NSString stringWithFormat:@"%ld", self.oilModel.hwlxbh];
        
        [self.deliveryModel submitDataWithSuccessBlock:^(id result) {
            
            if ([result[@"msg"] isEqualToString:@"成功"]) {
                [LLGHUD showSuccessWithStatus:@"提交成功"];
                //设置清空数据
                self.deliveryModel = nil;
                self.startModel = nil;
                self.endModel = nil;
                self.oilModel = nil;
                self.loadAddress = nil;
                self.loadLatitude = nil;
                self.loadLongitude = nil;
                self.unloadAddress = nil;
                self.unloadLatitude = nil;
                self.unloadLongitude = nil;
                self.transitAddress = nil;
                self.transitLatitude = nil;
                self.transitLongitude = nil;
                self.date = nil;
                self.contentDict = nil;
                self.tick = nil;
                
                for (int i = 0; i < self.menuArray.count; i++) {
                    
                    DeliveryMenuModel *model = self.menuArray[i];
                    
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    
                    if ([model.cellID isEqualToString:kThirdTableViewCellID]) {
                        ThirdTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                        
                        //NSLog(@"%d", i);
                        
                        cell.dismissData = @"消除数据";
                    } else if ([model.cellID isEqualToString:kSecondTableViewCellID]) {
                        
                        SecondTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                        
                        cell.dismissData = @"消除数据";
                    }
                }
                
                [self.tableView reloadData];
                
                
            } else {
                [LLGHUD showErrorWithStatus:@"提交失败"];
            }
            
        } failBlock:^(NSError *error) {
            
        }];
        
    }];
    
    [self jc_presentViewController:alert presentType:JCPresentTypeFIFO presentCompletion:nil dismissCompletion:nil];

}


- (void)selectedAddress:(NSNotification *)noti {
    
    switch ([noti.userInfo[@"index"] integerValue]) {
        case 7:
            self.loadAddress = noti.object;
            self.loadLatitude = noti.userInfo[@"latitude"];
            self.loadLongitude = noti.userInfo[@"longitude"];
            break;
        case 11:
            self.unloadAddress = noti.object;
            self.unloadLatitude = noti.userInfo[@"latitude"];
            self.unloadLongitude = noti.userInfo[@"longitude"];
            break;
        case 14:
            self.transitAddress = noti.object;
            self.transitLatitude = noti.userInfo[@"latitude"];
            self.transitLongitude = noti.userInfo[@"longitude"];
            break;
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[noti.userInfo[@"index"] integerValue] inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    
}

- (void)selectedOilType:(NSNotification *)noti {

    OilModel *model = noti.object;
    
    self.oilModel = model;
    
    //刷新第2行
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

//通知监听事件
- (void)selectedCity:(NSNotification *)noti {

    cityModel *model = noti.object;
    
    //NSLog(@"%@", noti.userInfo[@"tag"]);
    
    [model setValue:noti.userInfo[@"tag"]forKey:@"tag"];
    
    if ([noti.userInfo[@"tag"] isEqualToString:@"100"]) {
        self.startModel = model;
    } else {
        self.endModel = model;
    }
    
    //NSLog(@"%ld", model.tag);
    
    //刷新第一行
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.menuArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DeliveryMenuModel *menuModel = self.menuArray[indexPath.row];
    
    if ([menuModel.cellID isEqualToString:kFirstTableViewCellID]) {
        //FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFirstTableViewCellID forIndexPath:indexPath];
        
        FirstTableViewCell *cell = [[FirstTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFirstTableViewCellID];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //跳转选择城市
        __weak DeliveryTableViewController *weakSelf = self;
        cell.clickButtonBlock = ^(NSInteger tag){
            
            __strong DeliveryTableViewController *strongSelf = weakSelf;
            
            CityTableViewController *cityVC = [[CityTableViewController alloc]init];
            
            cityVC.tag = tag;
            
            MMNavigationController *nav = (MMNavigationController *)strongSelf.navigationController;
            
            [nav pushViewController:cityVC animated:YES];
            
        };
        
        if (self.startModel) {
            cell.model = self.startModel;
        }
        if (self.endModel) {
            cell.model = self.endModel;
        }
        
        cell.startColor = self.startColor;
        cell.endColor = self.endColor;
        
        return cell;
    } else if ([menuModel.cellID isEqualToString:kSecondTableViewCellID]) {
    
        //SecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSecondTableViewCellID forIndexPath:indexPath];
        
        SecondTableViewCell *cell = [[SecondTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSecondTableViewCellID];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (menuModel.toDate) {
            if (self.date) {
                cell.date = self.date;
            }
        } else {
            if (self.oilModel) {
                cell.oilModel = self.oilModel;
            }
            switch (indexPath.row) {
                case 7:
                    cell.address = self.loadAddress;
                    break;
                case 11:
                    cell.address = self.unloadAddress;
                    break;
                case 14:
                    cell.address = self.transitAddress;
                    break;
            }
        }
        
        cell.menuModel = menuModel;
        
        return cell;
    } else {
        
        //ThirdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kThirdTableViewCellID forIndexPath:indexPath];
        
        //NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];//以indexPath来唯一确定cell
        
        
        ThirdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kThirdTableViewCellID];
        
        if (cell == nil) {
             cell = [[ThirdTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kThirdTableViewCellID];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        __weak DeliveryTableViewController *weakSelf = self;
        cell.contentBlock = ^(NSString *content){
            __strong DeliveryTableViewController *strongSelf = weakSelf;
            
            [strongSelf.contentDict setValue:content forKey:[NSString stringWithFormat:@"%ld", indexPath.row]];
            
        };
        
        cell.tickBlock = ^(NSString *tick){
            __strong DeliveryTableViewController *strongSelf = weakSelf;
            
            strongSelf.tick = tick;
            
        };
        
        
        cell.menuModel = menuModel;
        
        return cell;
        
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DeliveryMenuModel *model = self.menuArray[indexPath.row];
    
    if ([model.cellID isEqualToString:kSecondTableViewCellID]) {
        
        if (model.toMap == YES) {
            
            MapViewController *mapVC = [[MapViewController alloc] init];
            
            //选取第几行标记
            mapVC.index = indexPath.row;
            
            [self.navigationController pushViewController:mapVC animated:YES];
            
        } else {
            
            if (model.toDate) {
                
                [tableView endEditing:YES];
                [self.datePickerView bl_show];
                
            } else {
                
                
                [self.navigationController pushViewController:[[OilTableViewController alloc] init] animated:YES];
            }
            
        }
        
 
    };
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 第一界面中dealloc中移除监听的事件
- (void)dealloc{
    // 移除当前对象监听的事件
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - - lazy load
// 第一步
- (BLDatePickerView *)datePickerView{
    if (!_datePickerView) {
        _datePickerView = [[BLDatePickerView alloc] init];
        _datePickerView.pickViewDelegate = self;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [formatter setDateFormat:@"YYYY"];
        
        //现在时间,你可以输出来看下是什么格式
        
        NSDate *datenow = [NSDate date];
        
        //----------将nsdate按formatter格式转成nsstring
        
        NSInteger yearNum = [[formatter stringFromDate:datenow] integerValue];
        
        [formatter setDateFormat:@"MM"];
        NSInteger monthNum = [[formatter stringFromDate:datenow] integerValue];
        [formatter setDateFormat:@"dd"];
        NSInteger dayNum = [[formatter stringFromDate:datenow] integerValue];
        
        [_datePickerView bl_setUpDefaultDateWithYear:yearNum month:monthNum day:dayNum];
        
        _datePickerView.topViewBackgroundColor = [UIColor grayColor];
        
        
    }
    return _datePickerView;
}


#pragma mark - - BLDatePickerViewDelegate
//选择之后
- (void)bl_selectedDateResultWithYear:(NSString *)year
                                month:(NSString *)month
                                  day:(NSString *)day{

    NSString *yearStr = [year substringToIndex:year.length - 1];
    NSString *monthStr = [month substringToIndex:month.length - 1];
    NSString *dayStr = [day substringToIndex:day.length - 1];
    
    //创建日期格式化对象
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *endDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@-%@-%@",yearStr,monthStr,dayStr]];
    
    NSInteger idx = [self calcDaysFromBegin:[NSDate date] end:endDate];
    
    if (idx < 0 || idx > 7 - 1) {
        self.date = @"";
        
    } else {
        self.date = [NSString stringWithFormat:@"%@-%@-%@",yearStr,monthStr,dayStr];
    }
    
    //刷新第8行
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:8 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
 
}


- (NSInteger) calcDaysFromBegin:(NSDate *)beginDate end:(NSDate *)endDate
{
    //创建日期格式化对象
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //取两个日期对象的时间间隔：
    //这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:typedef double NSTimeInterval;
    NSTimeInterval time=[endDate timeIntervalSinceDate:beginDate];
    
    int days=((int)time)/(3600*24);
    //int hours=((int)time)%(3600*24)/3600;
    //NSString *dateContent=[[NSString alloc] initWithFormat:@"%i天%i小时",days,hours];
    return days;
}

- (DeliveryModel *)deliveryModel {

    if (_deliveryModel == nil) {
        _deliveryModel = [[DeliveryModel alloc]init];
    }
    
    return _deliveryModel;
}

- (NSMutableDictionary *)contentDict {

    if (_contentDict == nil) {
        _contentDict = [NSMutableDictionary dictionary];
    }
    
    return _contentDict;
}

/*
//设置数据
- (void)setDataDict:(NSDictionary *)dataDict {
    _dataDict = dataDict;
    
    DeliveryModel *model = [DeliveryModel deliveryModelWithdict:dataDict];
    self.deliveryModel = model;
}
*/
@end
