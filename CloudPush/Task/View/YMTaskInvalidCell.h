//
//  YMTaskInvalidCell.h
//  CloudPush
//
//  Created by YouMeng on 2017/2/27.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMTaskStatusModel.h"


@interface YMTaskInvalidCell : UITableViewCell

@property(nonatomic,strong)YMTaskStatusModel* model;

+(instancetype)cellDequeueReusableCellWithTableView:(UITableView* )tableView;
@end
