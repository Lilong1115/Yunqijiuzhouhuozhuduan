//
//  DeliveryTableViewController.h
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/13.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DeliveryModel;

@interface DeliveryTableViewController : UITableViewController

//网络数据
@property (nonatomic, strong) DeliveryModel *model;

@end
