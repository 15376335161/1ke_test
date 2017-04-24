//
//  YMWithdrawDetailCell.m
//  CloudPush
//
//  Created by YouMeng on 2017/4/5.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMWithdrawDetailCell.h"

@interface YMWithdrawDetailCell ()

//日期
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//提现金额
@property (weak, nonatomic) IBOutlet UILabel *withdrawLabel;
//提现方式
@property (weak, nonatomic) IBOutlet UILabel *styleLabel;
//提现账户
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
//提现状态
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation YMWithdrawDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
+(instancetype)shareCellWithTableView:(UITableView* )tableView{
    YMWithdrawDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
    }
    return cell;
}

-(void)setModel:(YMWithdrawModel *)model{
    _model = model;
    NSArray* tmpStrArr = [model.date componentsSeparatedByString:@" "];
    NSString* dateStr  = tmpStrArr[0];
    NSString* timeStr  = tmpStrArr[1];
    
    _dateLabel.text = [dateStr substringFromIndex:dateStr.length - 5];
    _timeLabel.text = [timeStr substringToIndex:5];
    
    if ([model.money containsString:@"-"]) {
        _withdrawLabel.text = model.money;
    }else{
        _withdrawLabel.text = [NSString stringWithFormat:@"+%@",model.money];
    }
   
    //提现到支付宝 银行卡
    _styleLabel.text    = model.extractDesc;
    _accountLabel.text  = model.account;
    //状态信息
    _statusLabel.text   = model.statusDesc;
    switch (model.status.integerValue) {
        case 1:
            _statusLabel.textColor = HEX(@"28A922");
            break;
        case 2:
            _statusLabel.textColor = HEX(@"3DA3F5");
            break;
        case 3:
            _statusLabel.textColor = HEX(@"EF5316");
            break;
        default:
            break;
    }
}


@end
