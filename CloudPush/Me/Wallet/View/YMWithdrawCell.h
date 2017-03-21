//
//  YMWithdrawCell.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/16.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMWithdrawCell : UITableViewCell

@property(nonatomic,copy)void(^allWithdrawBlock)(UIButton* btn,UITextField* moneyTextFd,UILabel* warnLabel);

//提现金额
@property (weak, nonatomic) IBOutlet UITextField *withdrawCrashTextFd;

@property (weak, nonatomic) IBOutlet UILabel *warnLabel;

//全部提现
@property (weak, nonatomic) IBOutlet UIButton *allWithdrawBtn;

+(instancetype)shareCell;
- (void)handleWithdrawBlock:(void(^)(UIButton* btn,UITextField* moneyTextFd,UILabel* warnLabel))withdrawBlock;


@end
