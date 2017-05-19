//
//  cityModel.h
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/13.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cityModel : NSObject

//城市id
@property (nonatomic, copy) NSString *csbh;
//城市名称
@property (nonatomic, copy) NSString *csmc;
//所属上级
@property (nonatomic, copy) NSString *sscs;
//城市下级
@property (nonatomic, assign) NSInteger numm;
//省市区 0-省 1-市 2-区
@property (nonatomic, copy) NSString *csxzdj;

//判断出发地或者目的地
@property (nonatomic, copy) NSString *tag;

+ (instancetype)cityModelWithDict:(NSDictionary *)dict;

@end
