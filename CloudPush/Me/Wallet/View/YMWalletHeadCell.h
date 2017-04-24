//
//  YMWalletHeadCell.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/13.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"


@interface YMWalletHeadCell : UITableViewCell


@property(nonatomic,strong)UserModel* model;

@property(nonatomic,copy)void(^tapViewBlock)(UITapGestureRecognizer* tap);
//实例
+(instancetype)shareCell;
@end
