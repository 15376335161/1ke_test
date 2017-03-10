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
    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.imgPath] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _titlLabel.text = model.task_title;
    _priceLabel.text = [NSString stringWithFormat:@"¥%@元/单",model.price];
    NSString* reasonStr;
    if ([model.audit_status isEqualToString:@"3"]) {
        reasonStr = @"放弃任务";
    }

//    //时间过期
    if (![YMTool compareCurrentDateWithOtherDateStr:model.end_time format:@"yyyy-MM-dd HH:mm:ss"]) {
       reasonStr = @"已过期";
    }
    
    _reasonLabel.text = [NSString stringWithFormat:@"失效原因：%@",reasonStr];
}
@end
