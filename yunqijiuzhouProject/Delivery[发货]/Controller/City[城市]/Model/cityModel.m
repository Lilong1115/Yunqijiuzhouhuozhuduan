//
//  cityModel.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/13.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import "cityModel.h"

@implementation cityModel

+ (instancetype)cityModelWithDict:(NSDictionary *)dict {

    cityModel *model = [[cityModel alloc]init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

    
}

- (void)setNilValueForKey:(NSString *)key {
    
}

@end
