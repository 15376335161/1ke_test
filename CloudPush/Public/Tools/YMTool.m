//
//  YMTool.m
//  CloudPush
//
//  Created by APPLE on 17/2/20.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMTool.h"
#import "RealReachability.h"
#import <CoreLocation/CoreLocation.h>


@implementation YMTool
#pragma mark - 判断设备是否联网--- 基于AfnetWorking
+ (BOOL)connectedToNetwork{
    
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_storage zeroAddress;
    
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.ss_len = sizeof(zeroAddress);
    zeroAddress.ss_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags)
    {
        return NO;
    }
    //根据获得的连接标志进行判断
    BOOL isReachable = flags & kSCNetworkFlagsReachable;   //是否已经链接
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;  //是否需要连接
    return (isReachable&&!needsConnection) ? YES : NO;
}
//这个是用第三方RealReachability监听
+(BOOL)isNetConnect{
    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    if (status == RealStatusNotReachable)
    {
        return NO;
    }
    if (status == RealStatusViaWiFi)
    {
       return YES;
    }
    if (status == RealStatusViaWWAN)
    {
         return YES;
    }
    //可能会有未知网络情况
    else{
        return YES;
    }
}

+(NSInteger)getNetTypeByAFN{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    
    __block NSInteger status = 0;
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
                // 当网络状态改变了, 就会调用这个block
                switch (status) {
                    case AFNetworkReachabilityStatusUnknown: // 未知网络
                        NSLog(@"未知网络");
                        status = AFNetworkReachabilityStatusUnknown;
                        break;
        
                    case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                         status = AFNetworkReachabilityStatusNotReachable;
                        NSLog(@"没有网络(断网)");
                        
                        break;
        
                    case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                        status = AFNetworkReachabilityStatusReachableViaWWAN;
                        NSLog(@"手机自带网络");
                        break;
        
                    case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                        status = AFNetworkReachabilityStatusReachableViaWiFi;
                        NSLog(@"WIFI");
                        break;
                }
      

    }];
    // 3.开始监控
    [mgr startMonitoring];
    return status;
}
//（三）从状态栏中获取网络类型，
//基本原理是从UIApplication类型中通过valueForKey获取内部属性 statusBar。然后筛选一个内部类型
//（UIStatusBarDataNetworkItemView），最后返回他的 dataNetworkType属性，根据状态栏获取网络
//状态，可以区分2G、3G、4G、WIFI，系统的方法，比较快捷，不好的是万一连接的WIFI 没有联网的话，
//识别不到。
+ (NSString *)getNetWorkStates{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = [[NSString alloc]init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            DDLog(@"网络情况  netType === %d",netType);
            switch (netType) {
                case 0:
                    state = @"无网络";
                    //无网模式
                    break;
                case 1:
                    state =  @"2G";
                    break;
                case 2:
                    state =  @"3G";
                    break;
                case 3:
                    state =   @"4G";
                    break;
                case 5:
                {
                    state =  @"wifi";
                    break;
                default:
                    break;
                }
            }
        }
        //根据状态选择
    }
    DDLog(@"网络情况==== %@",state);
    return state;
}

//过去时间处理
+ (NSString *)distanceTimeWithBeforeTime:(double)beTime
{
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    
    double distanceTime = now - beTime;
    
    NSString * distanceStr;
    
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime];
    
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    
    [df setDateFormat:@"HH:mm"];
    
    NSString * timeStr = [df stringFromDate:beDate];
    
    [df setDateFormat:@"dd"];
    
    NSString * nowDay = [df stringFromDate:[NSDate date]];
    
    NSString * lastDay = [df stringFromDate:beDate];
    
    if (distanceTime < 60) {//小于一分钟
        
        distanceStr = @"刚刚";
        
    }
    
    else if (distanceTime < 60*60) {//时间小于一个小时
        
        distanceStr = [NSString stringWithFormat:@"%ld分钟前",(long)distanceTime/60];
        
    }
    
    else if(distanceTime < 24*60*60 && [nowDay integerValue] == [lastDay integerValue]){//时间小于一天
        
        distanceStr = [NSString stringWithFormat:@"今天 %@",timeStr];
        
    }
    
    else if(distanceTime< 24*60*60*2 && [nowDay integerValue] != [lastDay integerValue]){
        
        if ([nowDay integerValue] - [lastDay integerValue] == 1 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 1)) {
            
            distanceStr = [NSString stringWithFormat:@"昨天 %@",timeStr];
        }
        else{
            [df setDateFormat:@"MM-dd HH:mm"];
            distanceStr = [df stringFromDate:beDate];
        }
    }
    else if(distanceTime < 24*60*60*365){
        
        [df setDateFormat:@"MM-dd HH:mm"];
        
        distanceStr = [df stringFromDate:beDate];
        
    }
    else{
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        distanceStr = [df stringFromDate:beDate];
    }
    return distanceStr;
}
+ (void)labelColorWithLabel:(UILabel* )label  font:(id)font range:(NSRange)range color:(UIColor* )color{
    
    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:label.text];
    //设置字号
    [mutStr addAttribute:NSFontAttributeName value:font range:range];
    //设置文字颜色
    [mutStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    label.attributedText = mutStr;
    
}
//设置layer
+ (void)viewLayerWithView:(UIView* )view  cornerRadius:(CGFloat)cornerRadius boredColor:(UIColor* )boredColor borderWidth:(CGFloat)borderWidth{
    
    if (boredColor == nil) {
        boredColor = [UIColor clearColor];
    }
    view.layer.cornerRadius = cornerRadius;
    view.layer.borderColor = boredColor.CGColor;
    view.layer.borderWidth = borderWidth;
    view.clipsToBounds = cornerRadius;
    
}
//是否定位授权开启
+ (BOOL)isOnLocation
{
    BOOL isOn = false;
    if (([CLLocationManager locationServicesEnabled]) && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)) {
        DDLog(@"定位已经开启");
        isOn = YES;
    } else {
        DDLog(@"定位未开启");
        isOn = NO;
    }
    return isOn;
}

//添加手势
+ (void)addTapGestureOnView:(UIView*)view target:(id)target selector:(SEL)selector viewController:(UIViewController* )viewController{
    UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc]initWithTarget:target action:selector];
    gest.numberOfTapsRequired = 1;
    gest.numberOfTouchesRequired = 1;
    gest.delegate = viewController;
    [view addGestureRecognizer:gest];
}

//时间比较
+ (int)compareDate:(NSString*)date01 withDate:(NSString*)date02 {
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dt1 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    
    NSDate *dt2 = [[NSDate alloc] init];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending:
            ci = 1;
            break;
            //date02比date01小
        case NSOrderedDescending:
            ci= -1;
            break;
            //date02 = date01
        case NSOrderedSame:
            ci=0;
            break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1);
            break;
    }
    return ci;
}
//以固定格式 比较时间的大小
+(int)compareCurrentDateWithOtherDateStr:(NSString* )otherDateStr format:(NSString* )format{
    
     NSDate* currentDate = [self getCurrentDateWithFormat:format];//@"yyyy-MM-dd HH:mm:ss"
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    NSDate *otherDate  = [formatter dateFromString:otherDateStr];
    
    int flag =  [self compareDateWithFormatDate:currentDate withDate:otherDate];
    return flag;
}

//格式化时间比较
+ (int)compareDateWithFormatDate:(NSDate*)date1 withDate:(NSDate*)date2{
    int ci;
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *dt1 = [[NSDate alloc] init];
//    NSDate *dt2 = [[NSDate alloc] init];
//    dt1 = [df dateFromString:date01];
//    dt2 = [df dateFromString:date02];
    
    NSComparisonResult result = [date1 compare:date2];
    DDLog(@"result  === %ld",(long)result);
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending:
            ci = 1;
            break;
            //date02比date01小
        case NSOrderedDescending:
            ci= -1;
            break;
            //date02 = date01
        case NSOrderedSame:
            ci=0;
            break;
        default: NSLog(@"erorr dates %@, %@", date1, date2);
            break;
    }
    DDLog(@"ci ======= %d",ci);
    return ci;
}
//根据 date 字符串 和时间格式 获取 date
+(NSDate* )getDateWithDateStr:(NSString* )otherDateStr formate:(NSString*)format{
    DDLog(@"otherDateStr === %@",otherDateStr);
    NSDate  *tmpDate = [NSDate dateWithTimeIntervalSince1970:otherDateStr.longLongValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    NSString *formatDateStr = [formatter stringFromDate:tmpDate];

    NSDate *otherDate  = [formatter dateFromString:formatDateStr];
    
    DDLog(@"dateStr == %@  otherDate == %@",formatDateStr,otherDate);
    return otherDate;
}

//时间格式化
+ (NSString *)timeForDateFormatted:(NSString*)totalSeconds format:(NSString* )format{
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:totalSeconds.longLongValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString* datestring = [dateFormatter stringFromDate:date];
    return datestring;
}

//获取当前格式化时间
+(NSDate* )getCurrentDateWithFormat:(NSString* )format{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    NSDate *date       = [formatter dateFromString:dateTime];
    DDLog(@"---------- currentDate == %@",date);
    return date;
}

+ (NSString* )timeForDateFormatStr:(NSString* )dateFormatStr format:(NSString* )format newFormat:(NSString* )newFormat{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    NSDate * date      = [formatter dateFromString:dateFormatStr];
    NSString *dateTime = [formatter stringFromDate:date];
     DDLog(@"date === %@  dateTime == %@",date,dateTime);
    
    //切割字符串
    NSArray *dateArr = [dateFormatStr componentsSeparatedByString:@" "];
    DDLog(@"dateArr == %@",dateArr);
    if (dateArr.count > 0) {
        return dateArr[0];
    }else{
        return dateFormatStr;
    }
    
   // [formatter setDateStyle:NSDateFormatterMediumStyle];
    //[formatter setTimeStyle:NSDateFormatterShortStyle];
    
      // NSTimeZone* timeZone=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
      //  [formatter setTimeZone:timeZone];
    // NSLocale* local =[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]  ;
    //[formatter setLocale: local];
    // NSDate *
    // NSDateFormatter *nDateFormat = [[NSDateFormatter alloc]init];
  //  [nDateFormat setDateFormat:newFormat];
  //      [formatter setDateFormat:newFormat];
    
  //    NSDate*  date1  = [nDateFormat dateFromString:dateTime];
   
  //   dateTime = [nDateFormat stringFromDate:date1];
  //   DDLog(@"date === %@  dateTime == %@",date1,dateTime);
    
  //   DDLog(@"date == %@ dateFormatStr == %@  dateTime == %@",date,dateFormatStr,dateTime);
    return dateTime;
}

+(BOOL)isEquailWithStr:(NSString* )str otherStr:(NSString* )otherStr{
    BOOL flag = NO;
    if ([[str lowercaseString] isEqualToString:otherStr] ||
        [[str uppercaseString] isEqualToString:otherStr] ||
        [str isEqualToString:otherStr]) {
        flag = YES;
    }
    return flag;
}
@end
