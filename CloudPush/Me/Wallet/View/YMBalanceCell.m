//
//  YMBalanceCell.m
//  CloudPush
//
//  Created by YouMeng on 2017/4/5.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMBalanceCell.h"

@interface YMBalanceCell ()
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation YMBalanceCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
+(instancetype)shareCellWithTableView:(UITableView* )tableView{
    YMBalanceCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
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
        _moneyLabel.text = model.money;
    }else{
       _moneyLabel.text = [NSString stringWithFormat:@"+%@",model.money];
    }
       //状态信息
    _statusDescLabel.text   = model.statusDesc;
    switch (model.status.integerValue) {
        case 1:
            _statusDescLabel.textColor = HEX(@"28A922");
            break;
        case 2:
            _statusDescLabel.textColor = HEX(@"3DA3F5");
            break;
        case 3:
            _statusDescLabel.textColor = HEX(@"EF5316");
            break;
        default:
            break;
    }
}

@end
