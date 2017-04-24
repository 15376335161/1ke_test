//
//  YMMeWalletCell.m
//  CloudPush
//
//  Created by YouMeng on 2017/4/5.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMMeWalletCell.h"

@interface YMMeWalletCell ()<UIGestureRecognizerDelegate>

//views数组
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *tapViewsArr;
//余额
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
//待发金额
@property (weak, nonatomic) IBOutlet UILabel *waitIssueLabel;
//累积金额
@property (weak, nonatomic) IBOutlet UILabel *amassLabel;

@end

@implementation YMMeWalletCell

- (void)awakeFromNib {
    [super awakeFromNib];
    for (UIView* view in _tapViewsArr) {
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
        tap.delegate = self;
        view.userInteractionEnabled = YES;
        [view addGestureRecognizer:tap];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(instancetype)shareCellWithTapBlock:(void(^)(UITapGestureRecognizer* tap))tapViewBlock{
    YMMeWalletCell * cell = [[[NSBundle mainBundle]loadNibNamed:@"YMMeWalletCell" owner:nil options:nil] lastObject];
    self.tapViewBlock = tapViewBlock;
    return cell;
}
-(void)tapView:(UITapGestureRecognizer*)tap{
      DDLog(@"tag == %d",tap.view.tag);
     if (self.tapViewBlock) {
        self.tapViewBlock(tap);
     }
}
-(void)setUsrModel:(UserModel *)usrModel{
    _usrModel = usrModel;
    //余额
    _balanceLabel.text = usrModel.useMoeny.floatValue ? usrModel.useMoeny : @"0.00";
    //代发
    _waitIssueLabel.text = usrModel.readyMoney.floatValue ? usrModel.readyMoney : @"0.00";
    //累积金额
    _amassLabel.text = usrModel.grandTotalMoeny.floatValue ? usrModel.grandTotalMoeny : @"0.00";
}


@end
