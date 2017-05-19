//
//  OilModel.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/14.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import "OilModel.h"

@implementation OilModel

+ (instancetype)oilModelWithDict:(NSDictionary *)dict {

    OilModel *model = [[OilModel alloc]init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

    
}


@end
