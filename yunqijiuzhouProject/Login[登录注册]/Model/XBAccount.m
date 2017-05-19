//
//  XBBarAccount.m
//  ZTRadida
//
//  Created by zhangtong on 16/6/12.
//  Copyright © 2016年 zhangtong. All rights reserved.
//

#import "XBAccount.h"
#import <objc/runtime.h>

@implementation XBAccount
- (instancetype)initWithDic: (NSDictionary *) dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
+ (instancetype)accountWithDic:(NSDictionary *)dic{
    return [[self alloc] initWithDic:dic];
}
//没用的属性不用转,防止出错
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
//告诉系统怎么去归档
- (void)encodeWithCoder:(NSCoder *)encoder
{
    unsigned int count = 0;
    //  利用runtime获取实例变量的列表
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i ++) {
        //  取出i位置对应的实例变量
        Ivar ivar = ivars[i];
        //  查看实例变量的名字
        const char *name = ivar_getName(ivar);
        //  C语言字符串转化为NSString
        NSString *nameStr = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        //  利用KVC取出属性对应的值
        id value = [self valueForKey:nameStr];
        //  归档
        [encoder encodeObject:value forKey:nameStr];
    }
    
    //  记住C语言中copy出来的要进行释放
    free(ivars);
    
}

//告诉系统怎么去解档
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([self class], &count);
        for (int i = 0; i < count; i ++) {
            Ivar ivar = ivars[i];
            const char *name = ivar_getName(ivar);
            
            //
            NSString *key = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            id value = [decoder decodeObjectForKey:key];
            //  设置到成员变量身上
            [self setValue:value forKey:key];
        }
        
        free(ivars);
    }
    return self;
}




@end
