//
//  YMMyTaskCell.h
//  CloudPush
//
//  Created by YouMeng on 2017/2/27.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMTaskModel.h"
#import "YMTaskNumModel.h"

@interface YMMyTaskCell : UITableViewCell

//任务
@property(nonatomic,strong)YMTaskModel* model;
@property(nonatomic,strong)YMTaskNumModel* countModel;

@property(nonatomic,copy)void(^actionBlock)(UIButton* btn);

+(instancetype)cellDequeueReusableCellWithTableView:(UITableView* )tableView;

@end
