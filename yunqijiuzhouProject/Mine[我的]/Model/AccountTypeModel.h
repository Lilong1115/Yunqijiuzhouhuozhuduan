//
//  AccountTypeModel.h
//  yunqijiuzhouProject
//
//  Created by 李龙 on 2017/5/9.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountTypeModel : NSObject

@property (nonatomic, copy) NSString *account;

@property (nonatomic, copy) NSString *accountID;

+ (NSArray *)getAccountType;

@end
