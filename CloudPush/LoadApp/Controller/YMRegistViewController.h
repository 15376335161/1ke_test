//
//  YMRegistViewController.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/2.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "BaseViewController.h"

@interface YMRegistViewController : BaseViewController

//tag block
//@property(nonatomic,copy)void(^tagBlock)(NSInteger tag);

//注册的tag
@property(nonatomic,assign)NSInteger tag;
@end
