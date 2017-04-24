//
//  YMTaskInvalidCell.m
//  CloudPush
//
//  Created by YouMeng on 2017/2/27.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMTaskInvalidCell.h"

@interface YMTaskInvalidCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titlLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;

@end

@implementation YMTaskInvalidCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+(instancetype)cellDequeueReusableCellWithTableView:(UITableView* )tableView{
    YMTaskInvalidCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
    }
    return cell;
}
-(void)setModel:(YMTaskStatusModel *)model{
    _model = model;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.logo_path] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _titlLabel.text = model.product_name;
    _priceLabel.text = [NSString stringWithFormat:@"¥%@元/单",model.reward_money];
    NSString* reasonStr;
    if ([model.status isEqualToString:@"3"]) {
        reasonStr = @"放弃任务";
    }

//    //时间过期
    if (![YMDateTool compareCurrentDateWithOtherDateStr:model.add_time format:@"yyyy-MM-dd HH:mm:ss"]) {
       reasonStr = @"已过期";
    }
    
    _reasonLabel.text = [NSString stringWithFormat:@"失效原因：%@",reasonStr];
}
@end
