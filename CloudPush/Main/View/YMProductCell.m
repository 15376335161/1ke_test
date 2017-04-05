//
//  YMProductCell.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/30.
//  Copyright © 2017年 YouMeng. All rights reserved.

#import "YMProductCell.h"
#import "YMDateTool.h"


@interface YMProductCell ()
//产品图标
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
//产品标记
@property (weak, nonatomic) IBOutlet UIImageView *tagImgView;
//平台描述
@property (weak, nonatomic) IBOutlet UILabel *titlDescLabel;
//剩余时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//收益label
@property (weak, nonatomic) IBOutlet UILabel *interestLbel;
//收益标题
@property (weak, nonatomic) IBOutlet UILabel *interestTitlLabel;
//返利
@property (weak, nonatomic) IBOutlet UILabel *profitLabel;
//返利标题
@property (weak, nonatomic) IBOutlet UILabel *profitTitlLabel;
//起投金额
@property (weak, nonatomic) IBOutlet UILabel *minInvestLabel;
//投资
@property (weak, nonatomic) IBOutlet UIButton *investBtn;
//收益左边约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *interestLabelLeft;
//收益右边约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *interestLabelRight;
//返现左边约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profitLabelLeft;

@end

@implementation YMProductCell
- (void)awakeFromNib {
    [super awakeFromNib];
    if (SCREEN_WIDTH == 320) {
        self.interestLabelLeft.constant = self.interestLabelRight.constant = self.profitLabelLeft.constant = 20;
    }else if (SCREEN_WIDTH == 375){
        self.interestLabelLeft.constant = self.interestLabelRight.constant = self.profitLabelLeft.constant = 30;
    }else{
        self.interestLabelLeft.constant = self.interestLabelRight.constant = self.profitLabelLeft.constant = 40;
    }
    //起投金额
    [YMTool viewLayerWithView:_minInvestLabel cornerRadius:4 boredColor:TabBarTintColor borderWidth:1];
    [YMTool viewLayerWithView:_investBtn cornerRadius:4 boredColor:TabBarTintColor borderWidth:1];
    
}

+ (instancetype)shareCellWithTableView:(UITableView* )tableView actionBlock:(void(^)(UIButton* btn))actionBlock{
    YMProductCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        cell.actionBlock = actionBlock;
    }
    return cell;
}
- (IBAction)investBtnClick:(UIButton *)sender {
    DDLog(@"点击啦 立即投资");
    if (self.actionBlock) {
        self.actionBlock(sender);
    }
}
-(void)setModel:(YMProductModel *)model{
    _model = model;
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:model.logo_path] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    if (model.tag.integerValue == 1) { //1热门 2 置顶
        _tagImgView.image = [UIImage imageNamed:@"hot"];
    }else if (model.tag.integerValue == 2) {
        _tagImgView.image = [UIImage imageNamed:@"zhiding"];
    }else{
        _tagImgView.hidden = YES;
    }
    _titlDescLabel.text = model.slogan;//平台描述
    _timeLabel.text     = [NSString stringWithFormat:@"还剩%@",[YMDateTool futureTimeWithfutureTime:model.end_time format:@"yyyy-MM-dd HH:mm:ss"]];
    _interestLbel.text  = model.expect_annual_rate;//预计年化收益
    _profitLabel.text   = [NSString stringWithFormat:@"最高%@元",model.max_rebate];//返利
    
    _minInvestLabel.text = [NSString stringWithFormat:@" %@元起投",model.start_money];//起投
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
