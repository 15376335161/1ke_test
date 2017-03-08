//
//  YMReceSuccessController.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/1.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMTaskStatusModel.h"


@interface YMReceSuccessController : UIViewController


@property(nonatomic,strong)YMTaskStatusModel* model;

@property(nonatomic,strong)NSDictionary* dicData;
@end
