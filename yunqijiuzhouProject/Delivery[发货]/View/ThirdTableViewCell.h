//
//  ThirdTableViewCell.h
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/14.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DeliveryMenuModel;



@interface ThirdTableViewCell : UITableViewCell

@property (nonatomic, strong) DeliveryMenuModel *menuModel;

@property (nonatomic, copy) void(^contentBlock)(NSString *content);

@property (nonatomic, copy) void(^tickBlock)(NSString *tick);

//消除数据
@property (nonatomic, copy) NSString *dismissData;

@end
