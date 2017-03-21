//
//  YMWithdrawStyleCell.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/16.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleModel.h"

@interface YMWithdrawStyleCell : UITableViewCell

//存储数据模型
@property(nonatomic,strong)TitleModel* model;
//标题
@property (weak, nonatomic) IBOutlet UILabel *titlLabel;
//图标
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

//复用
+(instancetype)cellDequeueReusableCellWithTableView:(UITableView* )tableView;

@end
