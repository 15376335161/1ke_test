//
//  YMRedBagController.h
//  CloudPush
//
//  Created by YouMeng on 2017/4/10.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMWebViewController.h"

@interface YMRedBagController : YMWebViewController


@property(nonatomic,assign)BOOL isToTabBar;

//执行back
@property(nonatomic,copy)void(^backBlock)();

@end
