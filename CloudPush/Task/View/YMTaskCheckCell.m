//
//  YMTaskCheckCell.m
//  CloudPush
//
//  Created by YouMeng on 2017/2/27.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMTaskCheckCell.h"

@interface YMTaskCheckCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *leftTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titlLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation YMTaskCheckCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+(instancetype)cellDequeueReusableCellWithTableView:(UITableView* )tableView {
    YMTaskCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
    }
    return cell;
}

-(void)setModel:(YMTaskModel *)model{
    _model = model;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.img_path] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    _titlLabel.text = model.task_title;
    
    _leftTimeLabel.text = [NSString stringWithFormat:@"剩余时间:5天"];
   
    _priceLabel.text = [NSString stringWithFormat:@"¥%@元/单",model.price];
     _statusLabel.text = @"通过审核";
    _timeLabel.text = [NSString stringWithFormat:@"审核时间:%@",model.end_time];
}
-(void)setCountModel:(YMTaskNumModel *)countModel{
    _countModel = countModel;
    _leftCountLabel.text = [NSString stringWithFormat:@"剩余单数：%d",([self.model.task_nums intValue] - [countModel.count_num intValue])];
}
@end
