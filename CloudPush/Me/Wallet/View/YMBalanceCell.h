//
//  YMBalanceCell.h
//  CloudPush
//
//  Created by YouMeng on 2017/4/5.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMWithdrawModel.h"

@interface YMBalanceCell : UITableViewCell


//模型
@property(nonatomic,strong)YMWithdrawModel* model;

+(instancetype)shareCellWithTableView:(UITableView* )tableView;
@end
