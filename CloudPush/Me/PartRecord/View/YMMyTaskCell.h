//
//  YMMyTaskCell.h
//  CloudPush
//
//  Created by YouMeng on 2017/2/27.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMTaskStatusModel.h"
#import "YMTaskNumModel.h"

@interface YMMyTaskCell : UITableViewCell

//原因
@property (weak, nonatomic) IBOutlet UILabel *resonLabel;
//任务
@property(nonatomic,strong)YMTaskStatusModel* model;

@property(nonatomic,copy)void(^actionBlock)(UIButton* btn);

+(instancetype)cellDequeueReusableCellWithTableView:(UITableView* )tableView;

@end
