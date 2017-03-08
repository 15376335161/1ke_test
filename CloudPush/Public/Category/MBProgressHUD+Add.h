//
//  MBProgressHUD+Add.h
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Add)

#pragma mark 显示失败/成功/警告信息
+ (void)showFail:(NSString *)tip view:(UIView *)view;
+ (void)showSuccess:(NSString *)tip view:(UIView *)view;
+ (void)showWarn:(NSString *)tip view:(UIView *)view;

+ (void)showNetErrorInView:(UIView* )view;
#pragma mark 显示消息
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view;

@end
