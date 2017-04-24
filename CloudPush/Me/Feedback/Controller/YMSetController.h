//
//  YMSetController.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/10.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "BaseViewController.h"

@interface YMSetController : BaseViewController

//返回到首页block
@property(nonatomic,copy)void(^backToMainBlock)();
@end
