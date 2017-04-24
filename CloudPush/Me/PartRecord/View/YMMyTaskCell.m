//
//  YMMyTaskCell.m
//  CloudPush
//
//  Created by YouMeng on 2017/2/27.
//  Copyright © 2017年 YouMeng. All rights reserved.


#import "YMMyTaskCell.h"
#import "YMDateTool.h"
#import "YMStringTool.h"


@interface YMMyTaskCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
//状态label
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
//返利
@property (weak, nonatomic) IBOutlet UILabel *profitLabel;
//投资金额
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *platmNameLabel;

@end

@implementation YMMyTaskCell

- (void)awakeFromNib {
//    _rightBtn.sd_layout.widthIs(_rightBtn.width + 10).rightSpaceToView(self.contentView,15);
//    _rightBtn.layer.borderColor = [UIColor colorwithHexString:@"3da3f5"].CGColor;
//    _rightBtn.layer. borderWidth = 1;
//    
//    _leftBtn.sd_layout.widthIs(_leftBtn.width + 10).rightSpaceToView(_rightBtn,10);
//    _leftBtn.layer.borderColor = [UIColor colorwithHexString:@"fab531"].CGColor;
//    _leftBtn.layer.borderWidth = 1;
     [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setFrame:(CGRect)frame{
   // frame.origin.y    += 7;
   // frame.size.height -= 7;
    [super setFrame:frame];
}

+(instancetype)cellDequeueReusableCellWithTableView:(UITableView* )tableView{
    YMMyTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
    }
    return cell;
}

-(void)setModel:(YMTaskStatusModel *)model{
    _model = model;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseApi,model.logo_path]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    //产品名称
    _productNameLabel.text = model.product_name;
    _platmNameLabel.text   = model.platform_name;
    _timeLabel.text = [NSString stringWithFormat:@"参与时间:%@",[YMDateTool timeForDateFormatted:model.add_time  format:@"yyyy.MM.dd HH:mm"]];
    _profitLabel.text = [NSString stringWithFormat:@"赏多多返利:%@元",model.reward_money];
    _statusLabel.text = [YMStringTool getStatusByNumStatus:model.status];

    if (_resonLabel.hidden == NO) {//SCREEN_WIDTH
        _resonLabel.text = [NSString stringWithFormat:@"不通过原因：%@",[NSString isEmptyString:model.waiting_desc] ? @" ":model.waiting_desc];
    }
    _moneyLabel.text  = [NSString stringWithFormat:@"投资金额:%@元",model.start_money];

}

- (IBAction)btnClick:(id)sender {
    if (self.actionBlock) {
        self.actionBlock(sender);
    }
}

@end
