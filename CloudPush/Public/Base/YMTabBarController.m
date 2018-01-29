//
//  YMTabBarController.m
//  CloudPush
//
//  Created by APPLE on 17/2/21.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMTabBarController.h"
#import "YMMarketController.h"
#import "YMMeViewController.h"

#import "YMTaskBaseController.h"
#import "UIImage+Extension.h"

#import "YMMainController.h"
#import "YMPartnerController.h"
//imyWebView
#import "YMWKWebViewController.h"
//wkwebView
#import "WKWebViewController.h"

@interface YMTabBarController ()

@end

@implementation YMTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor = TabBarTintColor;
    // 添加所有的子控制器
    [self addChildVCs];
}
/**
 *  添加所有的子控制器
 */
- (void)addChildVCs{
    //市场
    [self setUpChildViewController:[[YMMainController alloc]init] title:@"首页" imageNamed:@"市场"];
    //任务
    [self setUpChildViewController:[[YMPartnerController alloc]init] title:@"合伙人" imageNamed:@"合伙人"];
    //我的
    [self setUpChildViewController:[[YMMeViewController alloc]init] title:@"我的" imageNamed:@"我的"];
}

//创建子控制的方法
-(void)setUpChildViewController:(UIViewController *)vc title:(NSString *)title imageNamed:(NSString *)imageName{
    //精华
    YMNavigationController * naVc = [[YMNavigationController alloc]initWithRootViewController:vc];
    vc.title = title;//相当于上面两句
    if ([title isEqualToString:@"首页"]) {
        vc.title = @"赏多多";
        vc.tabBarItem.title = title;
    }
    if ([title isEqualToString:@"合伙人"]) {
        vc.title = @"我的合伙人";
        vc.tabBarItem.title = title;
    }
    vc.tabBarItem.image = [UIImage imageNamed:imageName];
    NSString * selectImageName = [imageName stringByAppendingString:@"选中"];
    vc.tabBarItem.selectedImage = [UIImage originarImageNamed:selectImageName];
    //给TabBarController 添加子控制器
    [self addChildViewController:naVc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
