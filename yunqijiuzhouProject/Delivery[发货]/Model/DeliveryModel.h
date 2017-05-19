//
//  DeliveryModel.h
//  yunqijiuzhouProject
//
//  Created by 李龙 on 17/4/18.
//  Copyright © 2017年 yunqijiuzhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeliveryModel : NSObject
/* 订单创建时间 */
@property (nonatomic, copy) NSString *creationTime;
/* 发货备注 */
@property (nonatomic, copy) NSString *fhdbz;
/* 货物类型 1 2 3 4 */
@property (nonatomic, copy) NSString *fhdhwlx;
/* 货物重量 0 or float 必选 */
@property (nonatomic, copy) NSString *fhdhwzl;
/* 目的地城市id 必选 */
@property (nonatomic, copy) NSString *fhdjscs;
/* 出发地城市id 必选 */
@property (nonatomic, copy) NSString *fhdkscs;
/* 亏吨赔偿 0 or float 必选 */
@property (nonatomic, copy) NSString *fhdkspc;
/* 装货日期 "20170413" */
@property (nonatomic, copy) NSString *fhdthrq;
/* 目的地详细地址 */
@property (nonatomic, copy) NSString *fhdxhcsxx;
/* 目的地经纬度 0-0 or float-float 必选 */
@property (nonatomic, copy) NSString *fhdxhzb;
/* 运输单价 0 or float 必选 */
@property (nonatomic, copy) NSString *fhdydj;
/* 预付定金 0 or float 必选 */
@property (nonatomic, copy) NSString *fhdyfdj;
/* 允许亏吨量 0 or float 必选 */
@property (nonatomic, copy) NSString *fhdyskdl;
/* 出发地详细地址 */
@property (nonatomic, copy) NSString *fhdzhcsxx;
/* 出发地经纬度 0-0 or float-float 必选 */
@property (nonatomic, copy) NSString *fhdzhzb;
/* 目的地城市 必选 */
@property (nonatomic, copy) NSString *jscs;
/* 出发地城市 必选 */
@property (nonatomic, copy) NSString *kscs;
/* 是否含税（1是0否）*/
@property (nonatomic, copy) NSString *sfhs;
/* 用户id 必选 */
@property (nonatomic, copy) NSString *uuid;
/* 卸货联系人 */
@property (nonatomic, copy) NSString *xhlxrmc;
/* 中转地址 */
@property (nonatomic, copy) NSString *zzdz;
/* 中转经纬度 0-0 or float-float 必选 */
@property (nonatomic, copy) NSString *zzjwd;
/* 卸货联系方式 */
@property (nonatomic, copy) NSString *xhlxrsjh;
/* 装货联系人 */
@property (nonatomic, copy) NSString *zhlxrmc;
/* 装货联系方式 */
@property (nonatomic, copy) NSString *zhlxrsjh;

//提交数据
- (void)submitDataWithSuccessBlock:(SucessBlock)sucess failBlock:(FailBlock)fail;

+ (instancetype)deliveryModelWithdict:(NSDictionary *)dict;

@end

