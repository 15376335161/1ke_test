//
//  YMSignUpController.h
//  CloudPush
//
//  Created by YouMeng on 2017/5/18.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMWebViewController.h"

@interface YMSignUpController : YMWebViewController

@property(nonatomic,assign)BOOL isToTabBar;

//执行back
@property(nonatomic,copy)void(^backBlock)();


@end
