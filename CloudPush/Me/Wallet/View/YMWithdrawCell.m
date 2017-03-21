//
//  YMWithdrawCell.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/16.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMWithdrawCell.h"

@implementation YMWithdrawCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


+(instancetype)shareCell{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}

-(void)handleWithdrawBlock:(void(^)(UIButton* btn,UITextField* moneyTextFd,UILabel* warnLabel))withdrawBlock{
    
    self.allWithdrawBlock = withdrawBlock;
    
}
- (IBAction)allWithdrawBtnClick:(UIButton*)sender {
    if (self.allWithdrawBlock) {
        self.allWithdrawBlock(sender,_withdrawCrashTextFd,_warnLabel);
    }
}
@end
