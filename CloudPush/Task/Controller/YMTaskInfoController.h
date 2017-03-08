//
//  YMTaskInfoController.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/1.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMTaskInfoController : UIViewController

//消息详情
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property(nonatomic,copy)NSString* info;

//标记
@property(nonatomic,assign)NSInteger tag;
@end
