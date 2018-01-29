//
//  NSString+Catogory.h
//  挑食
//
//  Created by duyong_july on 16/3/24.
//  Copyright © 2016年 挑食科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderModel.h"

@interface NSString (Catogory)

//订单状态
//+ (NSString *)judgeOrderStatus:(NSInteger)status;

////配送方式
//+(NSString*)getdelivery_wayStateByStatus:(NSInteger)status;


//用户性别
+ (NSString* )getUserSexByString:(NSString*)sexStr;

//传递一个单位 M 距离
+ (NSString *)showDistance:(NSString *)str;


//传递一个中文 code 返回对应code 参数
+ (NSString *)getCatogoryCodeByCode:(NSString* )code;


//新增配送方式  订单状态
+(NSString* )judgeOrderStatusByString:(NSString*)status;

+(NSString*)getdelivery_wayStateByStatusString:(NSString* )status;

// 检索条件
+(NSString*)customStatusByStatus:(NSString*)status;

//包月套餐订单状态
+(NSString* )packageOrderStatusByStartStatus:(NSString*)startStatus;

//包月套餐 配送状态
+(NSString* )packOrderStatusByShopStatus:(NSString*)shopStatus;

//订单显示状态 最终版
//+(NSString *)orderStatusByOrderModel:(OrderModel* )orderModel;
+(NSString* )orderStatusByStatus:(NSString*)status cancelStatus:(NSString*)cancelStatus deliveryStatus:(NSString*)deliveryStatus evaluateStatus:(NSString*)evaluateStatus refundStatus:(NSString* )refundStatus;
//分享订单状态
+(NSString* )orderStatusByStatus:(NSString*)status shareStatus:(NSString* )shareStatus cancelStatus:(NSString*)cancelStatus deliveryStatus:(NSString*)deliveryStatus evaluateStatus:(NSString*)evaluateStatus refundStatus:(NSString* )refundStatus ;
//分享订单状态
+(NSString* )shareOrderStatus:(NSString* )shareStatus;

+ (NSString *)timeChineseFormatFromSeconds:(long long)seconds;
@end
