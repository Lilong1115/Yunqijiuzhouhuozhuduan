//
//  FirstTableViewCell.h
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/13.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class cityModel;

@interface FirstTableViewCell : UITableViewCell

//按钮回调
@property (nonatomic, copy) void(^clickButtonBlock)(NSInteger tag);
//城市模型
@property (nonatomic, strong) cityModel *model;

//出发地颜色
@property (nonatomic, strong) UIColor *startColor;
//目的地颜色
@property (nonatomic, strong) UIColor *endColor;

@end
