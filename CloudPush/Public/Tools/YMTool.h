//
//  YMTool.h
//  CloudPush
//
//  Created by APPLE on 17/2/20.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMTool : NSObject<UIGestureRecognizerDelegate>
//过去的时间处理
+ (NSString *)distanceTimeWithBeforeTime:(double)beTime;

+ (void)labelColorWithLabel:(UILabel* )label  font:(id)font range:(NSRange)range color:(UIColor* )color;

//设置layer
+ (void)viewLayerWithView:(UIView* )view  cornerRadius:(CGFloat)cornerRadius boredColor:(UIColor* )boredColor borderWidth:(CGFloat)borderWidth;

//afn判断是否联网
+ (BOOL)connectedToNetwork;

+(NSInteger)getNetTypeByAFN;

//系统方法判断网络情况
+ (NSString *)getNetWorkStates;

//这个是用第三方RealReachability监听
+(BOOL)isNetConnect;

//是否开启了定位权限
+ (BOOL)isOnLocation;


//添加手势
+ (void)addTapGestureOnView:(UIView*)view target:(id)target selector:(SEL)selector viewController:(UIViewController* )viewController;


//将 时间秒数字符串 转成 date
+(NSDate* )getDateWithDateStr:(NSString* )otherDateStr formate:(NSString*)format;
//获取当前时间 格式化 如 yy-MM-dd HH:mm:ss
+(NSDate* )getCurrentDateWithFormat:(NSString* )format;


//以固定格式 比较时间的大小
+(int)compareCurrentDateWithOtherDateStr:(NSString* )otherDateStr format:(NSString* )format;
//格式化时间比较
+ (int)compareDateWithFormatDate:(NSDate*)date1 withDate:(NSDate*)date2;
//时间比较
+ (int)compareDate:(NSString*)date01 withDate:(NSString*)date02;


//时间格式化
+ (NSString *)timeForDateFormatted:(NSString*)totalSeconds format:(NSString* )format;

//将原来的时间格式化字符串  转化成 特定 格式的 时间字符串
+ (NSString* )timeForDateFormatStr:(NSString* )dateFormatStr format:(NSString* )format newFormat:(NSString* )newFormat;

+ (NSString* )getYearTimeWithFormatDateTime:(NSString* )dateTime format:(NSString* )format;

//判断大小写
+(BOOL)isEquailWithStr:(NSString* )str otherStr:(NSString* )otherStr;


@end
