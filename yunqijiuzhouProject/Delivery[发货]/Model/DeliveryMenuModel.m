//
//  DeliveryMenuModel.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/14.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import "DeliveryMenuModel.h"

@implementation DeliveryMenuModel

+ (instancetype)deliveryMenuModelWithDict:(NSDictionary *)dict {

    DeliveryMenuModel *model = [[DeliveryMenuModel alloc]init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

}

+ (NSArray *)deliveryMenuArray {

    NSString *path = [[NSBundle mainBundle]pathForResource:@"Delivery.plist" ofType:nil];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray *arrayM = [NSMutableArray array];
    
    [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DeliveryMenuModel *model = [DeliveryMenuModel deliveryMenuModelWithDict:obj];
        [arrayM addObject:model];
    }];
    
    return arrayM.copy;
}

@end
