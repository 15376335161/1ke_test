//
//  UIControl+Custom.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/21.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (Custom)


//利用runtime,解决多次点击相同button,导致重复跳转的问题
// 可以用这个给重复点击加间隔
@property (nonatomic, assign) NSTimeInterval custom_acceptEventInterval;
@end
