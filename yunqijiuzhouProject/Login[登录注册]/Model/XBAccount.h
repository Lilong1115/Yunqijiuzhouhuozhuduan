//
//  XBBarAccount.h
//  ZTRadida
//
//  Created by zhangtong on 16/6/12.
//  Copyright © 2016年 zhangtong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface  XBAccount: NSObject
/*
 gzye = "<null>";
 gzzh = 0;
 phone = 15201133912;
 photo = "/antufile/2b0e99d2b96847b5ac3ab10336b61dad/20170408164103.png";
 szye = 100000;
 szzh = 1;
 token = 100d855909740c9b749;
 userName = "\U59da\U8000\U8f89";
 uuid = 2b0e99d2b96847b5ac3ab10336b61dad;
 yglx1 = 1;
 yhjyzt = 1;
 yhlx = 2;
 */

/**
 *  用户名称
 */
@property (nonatomic, copy) NSString *userName;

/**
 *  uuid
 */
@property (nonatomic ,copy) NSString *uuid;

/**
 *  手机号码
 */
@property (nonatomic, copy) NSString *phone;

/**
 *  私帐绑定状态 0 未绑 1 已绑
 */
@property (nonatomic, copy) NSString *szzh;

/**
 *  公帐绑定状态 0 未绑 1 已绑
 */
@property (nonatomic, copy) NSString *gzzh;

/**
 *  用户类型 1 货主 2 员工
 */
@property (nonatomic, copy) NSString *yglx1;

/**
 *  货主端 2
 */
@property (nonatomic, copy) NSString *yhlx;

/**
 *  头像路径 -- http://222.35.27.155:8888 图片基础url 
 */
//@property (nonatomic, copy) NSString *photo;

- (instancetype)initWithDic: (NSDictionary *)dic;
+ (instancetype)accountWithDic: (NSDictionary *)dic;

@end
