//
//  HKTabBar.m
//  百思不得姐--001
//
//  Created by H on 16/6/25.
//  Copyright © 2016年 TanZhou. All rights reserved.
//  alloc :分配内存空间  init:初始化属性

#import "HKTabBar.h"
//#import "QMYViewController.h"

@interface HKTabBar ()

/** 发布按钮  */
@property(nonatomic,weak)UIButton * publishBtn;
@end

@implementation HKTabBar

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //创建子控件
        UIButton * publish = [[UIButton alloc]init];
        [publish setBackgroundImage:[UIImage imageNamed:@"扫一扫"] forState:UIControlStateNormal];
        
//        self.clipsToBounds = YES;
//        [publish setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon_click"] forState:UIControlStateHighlighted];
        //添加按钮监听
        [publish addTarget:self action:@selector(publishClick) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self addSubview: publish];

        self.publishBtn = publish;
        
//         [[UITabBar appearance] setShadowImage:[UIImage new]]; [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
    }
    return self;
}


/** 发布按钮点击 */
-(void)publishClick
{
    DDLog(@"点击扫一扫");
    //控制器alloc init 创建的时候 会首先找有没有同名的XIB!!
//    QMYViewController * pVC = [[QMYViewController alloc]init];
//    DANavigationController* nav = [[DANavigationController alloc]initWithRootViewController:pVC];
//    
//    pVC.isPopToRoot = YES;
    //递归 找到app的根控制器
    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topRootViewController.presentedViewController)
    {
        topRootViewController = topRootViewController.presentedViewController;
    }
   // [topRootViewController presentViewController:nav animated:YES completion:nil];
     
}



//用来布局子控件
-(void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.layer.borderWidth = 0.01;
//    self.layer.borderColor = BackGroundColor.CGColor;
    
    //去除顶部的分割线
//    CGRect rect = CGRectMake(0, 0,SCREEN_WIDTH, 48);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [BackGroundColor CGColor]);
//    CGContextFillRect(context, rect);
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    [self setBackgroundImage:img];
//    [self setShadowImage:img];
    
  //  [self setBackgroundImage:[UIImage imageNamed:@"tabbarbg3.jpg"]];
   // 自定义顶部颜色
//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x-1, self.bounds.origin.y, self.bounds.size.width+2, self.bounds.size.height)];
////    bgView.backgroundColor = [UIColor redColor];
//    bgView.layer.borderColor = RGBA(227, 227, 227, 1).CGColor;
//    bgView.layer.borderWidth = 1;
//    [self insertSubview:bgView atIndex:0];
//    self.opaque = YES;
    
//    //连个属性的值 为某种颜色的图片 或其他图片 可以消除边缘线
//    UIImage* tabBarBackground = [UIImage imageNamed:@"tabbar_bg.png"]; //需要的图片
//    UIImage* tabBarShadow = [UIImage imageNamed:@"tabbar_shadow.png"]; //需要的图片
//    [[UITabBar appearance] setShadowImage:tabBarBackground];
//    [[UITabBar appearance] setBackgroundImage:tabBarShadow];
    
//    self.backgroundImage = [UIImage new];
//    self.shadowImage = [UIImage new];
    //拿出子控件布局  UITabBarButton
    //注意点:UITabBarButton 是系统没有提供出来的一个类!!
    //
    int index = 0;
    CGFloat W = self.width * 0.2;
    CGFloat H = self.height;
    CGFloat Y = 0;
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
           //能来到这里面都是我想要的
            CGFloat X = W * ((index == 2)? ++index:index);//是为了让第2个跳一下
            view.frame = CGRectMake(X, Y, W, H);
            index++;
        }
    }
    
    //布局子控件!!
    self.publishBtn.bounds = CGRectMake(0, 0, self.publishBtn.currentBackgroundImage.size.width, self.publishBtn.currentBackgroundImage.size.height);
    self.publishBtn.center = CGPointMake(self.width * 0.5 , self.height * 0.5 - 15);
    
    [self.publishBtn bringSubviewToFront:self];
    
    for (UIView* view in self.subviews) {
        DDLog(@"view === %@ ///////",[view class]);
        if ([view isKindOfClass:[UIButton class]]) {
            [self bringSubviewToFront:view];
            break;
        }
       // DDLog(@"view === %@ --------",[view class]);
    }
    
     for (UIView* view in self.subviews) {
         if ([view isKindOfClass:NSClassFromString(@"_UITabBarBackgroundView")]) {
             [self sendSubviewToBack:view];
             break;
         }
         DDLog(@"view === %@ **************",[view class]);
     }
}


@end
