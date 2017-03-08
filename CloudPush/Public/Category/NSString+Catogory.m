//
//  NSString+Catogory.m
//  挑食
//
//  Created by duyong_july on 16/3/24.
//  Copyright © 2016年 youmeng. All rights reserved.
//

#import "NSString+Catogory.h"
#import <UIKit/UIKit.h>


@implementation NSString (Catogory)

+ (NSString *)showDistance:(NSString *)str
{
    NSString *distanceStr=nil;
    float distance=[str floatValue];
    if (distance > 0 && distance < 1000) {
        distanceStr=[NSString stringWithFormat:@"%d%@",(int)distance,@"m"];
    }
    else if( distance > 1000 && distance < 1000 * 100){
        
        NSMutableString *muterStr=[NSMutableString stringWithString:str];
        CGFloat distance = [muterStr floatValue] / 1000;
        
        if (distance > 1 && distance < 100) {
            distanceStr=[NSString stringWithFormat:@"%.2f%@",distance,@"Km"];
        }else{
            NSString *str=[NSString stringWithFormat:@"%d",(int)distance];
            distanceStr=[NSString stringWithFormat:@"%@%@",str,@"Km"];
        }
    }else if(distance == 0){
        distanceStr = @"0 m";
    }else {
        
        distanceStr = [NSString stringWithFormat:@"%.0fkm",(distance/1000)];
    }
    return distanceStr;
}



+ (NSString *)timeChineseFormatFromSeconds:(long long)seconds{
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日"];
    
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    comps =[calendar components:(NSCalendarUnitWeekday | NSCalendarUnitWeekday |NSCalendarUnitWeekdayOrdinal)  fromDate:date];
    NSLog(@"comps == %d",[comps weekday]);
    ;
    
    NSString* datestring = [dateFormatter stringFromDate:date];
    return [NSString stringWithFormat:@"%@ %@",datestring,[NSString starsNumberByNumber:[comps weekday]]];
}
+ (NSString *)starsNumberByNumber:(NSUInteger)number{
    switch (number) {
        case 1:
            return @"周日";
            break;
        case 2:
            return @"周一";
            break;
        case 3:
            return @"周二";
            break;
        case 4:
            return @"周三";
            break;
        case 5:
            return @"周四";
            break;
        case 6:
            return @"周五";
            break;
        case 7:
            return @"周六";
            break;
        default:
            return nil;
            break;
    }
}

+(BOOL)isEmptyString:(NSString*)string{
    if ([string isEqual:[NSNull null]]  ||
        [string isEqual:[NSNull class]] ||
        [string isEqualToString:@""]    ||
        [string isEqualToString:@"#"]   ||
        [string isEqualToString:@" "]   ||
        [string isEqualToString:@"\n"]  ||
        string == nil                   ||
        string == NULL                  ||
        [string isEqualToString:@"(null)"]
        ) {
        return YES;
    }else{
        
        return NO;
    }}

+(BOOL)isNull:(id)obj{
    if ([obj isKindOfClass:[NSNull class]]) {
        return YES;
    }else if ([obj isEqual:[NSNull null]]){
        return YES;
    }else if (obj == nil){
        return YES;
    }else{
        return NO;
    }
}

+(NSString*)convertNull:(id)object{
    if ([object isEqual:[NSNull null]]) {
        return @" ";
    }else if ([object isKindOfClass:[NSNull class]]){
        return @" ";
    }else if (object == nil){
        return @" ";
    }else{
        return object;
    }
}

+(NSString*)numberStringWithnumberString:(NSString*)numberStr{
    NSArray *strArr = [numberStr componentsSeparatedByString:@"."];
    if (strArr.count > 1) {
        NSMutableString * mutStr;
        if ([strArr[1] length] > 2) {
            mutStr = [[NSString stringWithFormat:@"%.2f",numberStr.floatValue]mutableCopy];
            numberStr = mutStr;
            DDLog(@"numberStr == %@",numberStr);
        }
    }
    return numberStr;
}


+ (BOOL)isMobileNum:(NSString *)num{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10 * 中国移动：China Mobile
     11 * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12 */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15 * 中国联通：China Unicom
     16 * 130,131,132,152,155,156,185,186
     17 */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20 * 中国电信：China Telecom
     21 * 133,1349,153,180,189,177
     22 */
    NSString * CT = @"^1((33|53|8[09]|7[0-9])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:num] == YES)
        || ([regextestcm evaluateWithObject:num] == YES)
        || ([regextestct evaluateWithObject:num] == YES)
        || ([regextestcu evaluateWithObject:num] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
#pragma mark - 身份证号码验证
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

#pragma mark - 姓名正则表达式
+ (BOOL)validatePeopleName:(NSString *)peopleName
{
    BOOL flag;
    if (peopleName.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^([\u4e00-\u9fa5]+|([a-zA-Z]+\\s?)+)$";
    NSPredicate *peopleNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [peopleNamePredicate evaluateWithObject:peopleName];
}

#pragma mark - 家庭地址正则表达式
+ (BOOL)validateAddress:(NSString *)address
{
    BOOL flag;
    if (address.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"([^\x00-\xff]|[A-Za-z0-9_])+";
    NSPredicate *addressPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    
    return [addressPredicate evaluateWithObject:addressPredicate];
}

// Original
//    value 1.2  1.21  1.25  1.35  1.27
// Plain    1.2  1.2   1.3   1.4   1.3
// Down     1.2  1.2   1.2   1.3   1.2
// Up       1.2  1.3   1.3   1.4   1.3
// Bankers  1.2  1.2   1.2 ？ 1.4   1.3
//处理 四舍五入  只舍不入
+ (NSString *)notRounding:(float)orginalNum afterPoint:(int)position{
    //NSRoundPlain  -- 四舍五入
    //NSRoundDown   -- 舍弃最后一位
    //NSRoundUp     -- 最后一位有值 向前进一位
    //NSRoundBankers --类似 四舍五入
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    NSDecimalNumber *ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:orginalNum];
    NSDecimalNumber *roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    //    [ouncesDecimal release];
    
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

+ (NSString* )prefixStrByBaseUrlStr:(NSString* )baseUrlStr{
    if ([baseUrlStr containsString:@"api"]) {
        return @"API";
    }else if([baseUrlStr containsString:@"demo"]) {
        return @"DEMO";
    }else if ([baseUrlStr containsString:@"test"]) {
        return @"TEST";
    }else{
        return @"API";
    }
}

//根据类型 返回 中文名
+ (NSString* )couponTypeByType:(NSString* )type{
    if ([type isEqualToString:@"CASH"]) {
        return @"代金券";
    }
    else if ([type isEqualToString:@"DISCOUNT"]) {
        return @"折扣券"; // 打几折
    }
    else if ([type isEqualToString:@"GIFT"]) {
        return @"兑换券";
    }
    else if ([type isEqualToString:@"GROUPON"]) {
        return @"团购券";
    }
    else if ([type isEqualToString:@"GENERAL_COUPON"]) {
        return @"优惠券";
    }
    else {
        return @"优惠券";
    }
}

@end
