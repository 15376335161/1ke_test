//
//  YMProductCell.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/30.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMProductModel.h"

@interface YMProductCell : UITableViewCell

//产品模型
@property(nonatomic,strong)YMProductModel* model;

@property(nonatomic,strong)void(^actionBlock)(UIButton* btn);

//创建cell
+ (instancetype)shareCellWithTableView:(UITableView* )tableView actionBlock:(void(^)(UIButton* btn))actionBlock;


@end
