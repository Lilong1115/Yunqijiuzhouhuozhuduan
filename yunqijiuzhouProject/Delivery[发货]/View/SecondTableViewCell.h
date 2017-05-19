//
//  SecondTableViewCell.h
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/14.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DeliveryMenuModel;
@class OilModel;

@interface SecondTableViewCell : UITableViewCell

@property (nonatomic, strong) DeliveryMenuModel *menuModel;

@property (nonatomic, strong) OilModel *oilModel;

@property (nonatomic, strong) NSString *date;

@property (nonatomic, strong) NSString *address;

//消除数据
@property (nonatomic, copy) NSString *dismissData;

@end
