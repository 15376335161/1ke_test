//
//  YMPaySecrectController.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/6.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "BaseViewController.h"

@interface YMPaySecrectController : BaseViewController

//设置修改的类型
@property(nonatomic,assign)SetType setType;

@property(nonatomic,copy)void(^refreshDataBlock)();
@end
