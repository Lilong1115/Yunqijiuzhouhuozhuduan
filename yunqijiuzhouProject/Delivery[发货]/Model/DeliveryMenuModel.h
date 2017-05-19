//
//  DeliveryMenuModel.h
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/14.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeliveryMenuModel : NSObject

//标记cell "kFirstTableViewCellID" "kSecondTableViewCellID" "kThirdTableViewCellID"
@property (nonatomic, copy) NSString *cellID;
//标题
@property (nonatomic, copy) NSString *title;
//是否有单位
@property (nonatomic, assign) BOOL haveUnit;
//是否有含税选型
@property (nonatomic, assign) BOOL haveTax;
//keyboard YES-数字 NO-默认
@property (nonatomic, assign) BOOL keyboard;
//是否跳转地图
@property (nonatomic, assign) BOOL toMap;
//是否选择日期
@property (nonatomic, assign) BOOL toDate;

+ (NSArray *)deliveryMenuArray;

@end
