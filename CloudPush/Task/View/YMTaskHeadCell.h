//
//  YMTaskHeadCell.h
//  CloudPush
//
//  Created by YouMeng on 2017/2/28.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMTaskModel.h"

@interface YMTaskHeadCell : UITableViewCell


//数据模型
@property(nonatomic,strong)YMTaskModel* model;
//创建实例
+(instancetype)shareCell;
@end
