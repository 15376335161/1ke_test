//
//  NSString+Catogory.h
//  挑食
//
//  Created by duyong_july on 16/3/24.
//  Copyright © 2016年 youmeng. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Catogory)

//传递一个单位 M 距离
+ (NSString *)showDistance:(NSString *)str;
//返回中文的 时间
+ (NSString *)timeChineseFormatFromSeconds:(long long)seconds;

//判断空字符串
+(BOOL)isEmptyString:(NSString*)string;

//重写model  get方法 防止出现null  nil 等字眼
+(BOOL)isNull:(id)obj;

//转化空的字符等
+(NSString*)convertNull:(id)object;

//将字符串数字 转换成保留两位小数的字符串数字
+(NSString*)numberStringWithnumberString:(NSString*)numberStr;

//是否是手机号码
+ (BOOL)isMobileNum:(NSString *)num;
//是否是有效身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard;

//家庭地址正则表达式
+ (BOOL)validateAddress:(NSString *)address;
//姓名正则表达式
+ (BOOL)validatePeopleName:(NSString *)peopleName;

//处理四舍五入  只舍不入
+ (NSString *)notRounding:(float)orginalNum afterPoint:(int)position;

//根据 url 获取 推送 的前缀
+ (NSString* )prefixStrByBaseUrlStr:(NSString* )baseUrlStr;
//根据类型 返回 中文名
+ (NSString* )couponTypeByType:(NSString* )type;

//替换字符串例如用 *** 代替 数字
+(NSString* )string:(NSString *)str replaceStrInRange:(NSRange)range withString:(NSString*)placeStr;

@end
