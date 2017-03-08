//
//  MBProgressHUD+Add.m
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+Add.h"


@implementation MBProgressHUD (Add)

#pragma mark 显示信息
//+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
//{
//    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
//    // 快速显示一个提示信息
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.labelText = text;
//    // 设置图片
//    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
//    // 再设置模式
//    hud.mode = MBProgressHUDModeCustomView;
//    
//    // 隐藏时候从父控件中移除
//    hud.removeFromSuperViewOnHide = YES;
//    
//    // 1秒之后再消失
//    [hud hide:YES afterDelay:0.7];
//}

+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    
    if (text == nil || [text length] == 0) {
        return;
    }
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabelText = text;
    hud.detailsLabelFont = [UIFont systemFontOfSize:15];
    
//    UIView *tipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 100)];
//    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];//48X48
//    iv.image = [UIImage imageNamed:icon];
//    iv.center = CGPointMake(tipView.center.x, iv.center.y);
    //    [tipView addSubview:iv];
//    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 56, CGRectGetWidth(tipView.bounds), CGRectGetHeight(tipView.bounds) - 48)];
//    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(tipView.bounds), CGRectGetHeight(tipView.bounds) - 20)];
//    tipLab.text = text;
//    tipLab.textColor = [UIColor whiteColor];
//    tipLab.textAlignment = NSTextAlignmentCenter;
//    tipLab.font = [UIFont systemFontOfSize:15];
//    tipLab.numberOfLines = 0;
//    tipLab.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
//    [tipView addSubview:tipLab];
    
    // 设置图片
//    hud.customView = tipView;
    // 再设置模式
//    hud.mode = MBProgressHUDModeCustomView;
    
    hud.mode = MBProgressHUDModeText;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:1.2];
}


#pragma mark 显示失败/成功/警告信息

+ (void)showNetErrorInView:(UIView* )view{
    [self show:@"网络连接失败，请稍候重试！" icon:@"HUD_warn" view:view];
}
+ (void)showFail:(NSString *)tip view:(UIView *)view {
    [self show:tip icon:@"HUD_fail" view:view];
}

+ (void)showSuccess:(NSString *)tip view:(UIView *)view {
    [self show:tip icon:@"HUD_success" view:view];
}

+ (void)showWarn:(NSString *)tip view:(UIView *)view {
    [self show:tip icon:@"HUD_warn" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view {
    
    if (view == nil)
        view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    hud.labelFont = [UIFont systemFontOfSize:15];
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = NO;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    return hud;
}

@end
