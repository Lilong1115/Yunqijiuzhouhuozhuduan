//
//  AccountTypeModel.m
//  yunqijiuzhouProject
//
//  Created by 李龙 on 2017/5/9.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import "AccountTypeModel.h"

@implementation AccountTypeModel

+ (instancetype)accountTypeModelWithDict:(NSDictionary *)dict {

    AccountTypeModel *model = [[AccountTypeModel alloc]init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

}

+ (NSArray *)getAccountType {

    NSArray *array = @[@{@"account": @"对公账户", @"accountID": @"0"}, @{@"account": @"个人账户", @"accountID": @"1"}];
    
    NSMutableArray *arrayM = [NSMutableArray array];
    
    [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AccountTypeModel *model = [AccountTypeModel accountTypeModelWithDict:obj];
        [arrayM addObject:model];
    }];
    
    return arrayM.copy;
    
    
}

@end
