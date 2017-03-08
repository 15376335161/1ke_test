//
//  BaseView.m
//  CloudPush
//
//  Created by APPLE on 17/2/20.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView
//添加手势
- (void)addTapGestureOnView:(UIView*)view target:(id)target selector:(SEL)selector viewController:(UIViewController* )viewController{
    UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc]initWithTarget:target action:selector];
    gest.numberOfTapsRequired = 1;
    gest.numberOfTouchesRequired = 1;
    gest.delegate = viewController;
    [view addGestureRecognizer:gest];
}

@end
