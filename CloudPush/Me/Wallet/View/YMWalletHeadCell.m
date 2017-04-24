//
//  YMWalletHeadCell.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/13.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMWalletHeadCell.h"

@interface YMWalletHeadCell ()<UIGestureRecognizerDelegate>
//余额账户  103
@property (weak, nonatomic) IBOutlet UILabel *useMoneyLabel;
//待发收入  100
@property (weak, nonatomic) IBOutlet UILabel *readMoneyLabel;
//已提现收入 101
@property (weak, nonatomic) IBOutlet UILabel *withdrawLabel;
//累积收入。 102
@property (weak, nonatomic) IBOutlet UILabel *grandMoneyLabel;
//数据
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *tapViewsArr;
@end

@implementation YMWalletHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = DefaultNavBarColor;
    self.contentView.width = SCREEN_WIDTH;
    self.contentView.height = 69 + 57;
    
    for (UIView* view in _tapViewsArr) {
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
        tap.delegate = self;
        view.userInteractionEnabled = YES;
        [view addGestureRecognizer:tap];
    }
}
-(void)tapView:(UITapGestureRecognizer*)tap{
    DDLog(@"tag == %ld",tap.view.tag);
    if (self.tapViewBlock) {
        self.tapViewBlock(tap);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setModel:(UserModel *)model{
    _model = model;
    _useMoneyLabel.text = model.useMoeny.floatValue ? [NSString stringWithFormat:@"%@元",model.useMoeny] : @"0.00元";
    //修改文字
    [YMTool labelColorWithLabel:_useMoneyLabel font:Font(13) range:NSMakeRange(_useMoneyLabel.text.length - 1, 1) color:WhiteColor];
    _grandMoneyLabel.text = model.grandTotalMoeny.floatValue ? model.grandTotalMoeny : @"0.00";
    _readMoneyLabel.text = model.readyMoney.floatValue ? model.readyMoney : @"0.00";
    _withdrawLabel.text = model.withdraw.floatValue ? model.withdraw : @"0.00";
    
}
//实例
+(instancetype)shareCell{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}
@end
