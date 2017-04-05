//
//  YMWithdrawStyleCell.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/16.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMWithdrawStyleCell.h"

@implementation YMWithdrawStyleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _selectImgView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+(instancetype)cellDequeueReusableCellWithTableView:(UITableView* )tableView{
    YMWithdrawStyleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
    }
    return cell;
}

-(void)setModel:(TitleModel *)model{
    _model = model;
    _selectImgView.hidden = YES;
    
    _titlLabel.text = model.title;
    _iconImgView.image = [UIImage imageNamed:model.icon];
    if (model.isZfb.integerValue == 1 && model.withdrawStyle == WithDrawCrashStyleZfb) {
        
        _selectImgView.hidden = NO;
    }
    if (model.isCard.integerValue == 1 && model.withdrawStyle == WithDrawCrashStyleBankCard) {
        _selectImgView.hidden = NO;
        
    }
}

-(void)setUsrModel:(UserModel *)usrModel{
    _usrModel = usrModel;
//    if (usrModel.isZfb.integerValue == 1 && usrModel.withdrawStyle == WithDrawCrashStyleZfb) {
//        _selectImgView.hidden = NO;
//    }
//    if (usrModel.isCard.integerValue == 1 && usrModel.withdrawStyle == WithDrawCrashStyleBankCard) {
//        _selectImgView.hidden = NO;
//    }

     _titlLabel.text = [NSString stringWithFormat:@"银联(尾号%@)",[self.usrModel.isCard_accountName substringFromIndex:self.usrModel.isCard_accountName.length - 4]];
    
      _titlLabel.text = [NSString stringWithFormat:@"支付宝(%@)",[NSString string:self.usrModel.isZfb_accountName replaceStrInRange:NSMakeRange(3, self.usrModel.isZfb_accountName.length - 4) withString:@"****"]];
    
 }
@end
