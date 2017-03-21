//
//  YMWalletHeadCell.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/13.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMWalletHeadCell.h"

@interface YMWalletHeadCell ()
//余额账户
@property (weak, nonatomic) IBOutlet UILabel *useMoneyLabel;
//待发收入
@property (weak, nonatomic) IBOutlet UILabel *readMoneyLabel;
//已提现收入
@property (weak, nonatomic) IBOutlet UILabel *withdrawLabel;
//累积收入
@property (weak, nonatomic) IBOutlet UILabel *grandMoneyLabel;


@end

@implementation YMWalletHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = NavBarTintColor;
    self.contentView.width = SCREEN_WIDTH;
    self.contentView.height = 69 + 57;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
-(void)setModel:(UserModel *)model{
    _model = model;
    _useMoneyLabel.text = model.useMoeny.floatValue ? model.useMoeny : @"0.00";
    _grandMoneyLabel.text = model.grandTotalMoeny.floatValue ? model.grandTotalMoeny : @"0.00";
    _readMoneyLabel.text = model.readyMoney.floatValue ? model.readyMoney : @"0.00";
    _withdrawLabel.text = model.withdraw.floatValue ? model.withdraw : @"0.00";
    
}

//实例
+(instancetype)shareCell{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}
@end
