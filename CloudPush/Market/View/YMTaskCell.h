//
//  YMTaskCell.h
//  CloudPush
//
//  Created by YouMeng on 2017/2/23.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMTaskModel.h"

@interface YMTaskCell : UITableViewCell

@property(nonatomic,strong)YMTaskModel* model;
//创建实例
+(instancetype)shareCell;

//复用cell
+(instancetype)cellDequeueReusableCellWithTableView:(UITableView* )tableView;
@end
