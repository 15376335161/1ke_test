//
//  YMWithdrawStyleCell.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/16.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleModel.h"
#import "UserModel.h"


@interface YMWithdrawStyleCell : UITableViewCell

//存储数据模型
@property(nonatomic,strong)TitleModel* model;
//标题
@property (weak, nonatomic) IBOutlet UILabel *titlLabel;
//图标
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

//选中图标
@property (weak, nonatomic) IBOutlet UIImageView *selectImgView;

//用户类型
@property(nonatomic,strong)UserModel* usrModel;

//复用
+(instancetype)cellDequeueReusableCellWithTableView:(UITableView* )tableView;

@end
