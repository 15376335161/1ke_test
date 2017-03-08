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
+ (void)addTapGestureOnView:(UIView*)view target:(id)target selector:(SEL)selector viewController:(UIViewController* )viewController ;

@end
