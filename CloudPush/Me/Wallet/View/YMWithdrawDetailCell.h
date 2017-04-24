//
//  YMWithdrawDetailCell.h
//  CloudPush
//
//  Created by YouMeng on 2017/4/5.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMWithdrawModel.h"

@interface YMWithdrawDetailCell : UITableViewCell

//提现模型
@property(nonatomic,strong)YMWithdrawModel* model;
//实例化对象
+(instancetype)shareCellWithTableView:(UITableView* )tableView;

@end
