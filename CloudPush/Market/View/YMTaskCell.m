//
//  YMTaskCell.m
//  CloudPush
//
//  Created by YouMeng on 2017/2/23.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMTaskCell.h"


@interface YMTaskCell ()

//图片
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
//价格
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
//任务名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//剩余数量
@property (weak, nonatomic) IBOutlet UILabel *leftCountLabel;
//剩余时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//区域
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
//置顶label
@property (weak, nonatomic) IBOutlet UILabel *topLabel;

@end


@implementation YMTaskCell

+(instancetype)shareCell{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}

+(instancetype)cellDequeueReusableCellWithTableView:(UITableView* )tableView{
    YMTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    if (cell == nil) {
        cell = [YMTaskCell shareCell];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
-(void)layoutSubviews{
    _regionLabel.text = @"区域：全国";
    CGSize reginSize =  [_regionLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:7]}];
    _regionLabel.sd_layout.widthIs(reginSize.width + 6).heightIs(reginSize.height + 6);
    _regionLabel.layer.borderWidth = 0.5;
    _regionLabel.layer.borderColor = [UIColor  colorwithHexString:@"3DA3F5"].CGColor;
    _regionLabel.clipsToBounds = YES;
    
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setModel:(YMTaskModel *)model{
    _model = model;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.img_path] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _regionLabel.text = [NSString stringWithFormat:@" 区域:%@ ",model.city];
    _timeLabel.text  = model.task_title;
    if (model.zhiding) {
        _topLabel.hidden = NO;
    }else{
        _topLabel.hidden = YES;
    }
    _priceLabel.text = [NSString stringWithFormat:@"%@元",model.price];
    _leftCountLabel.text = [NSString stringWithFormat:@"剩余单数:%@",model.surplu_nums];
    _timeLabel.text = [NSString stringWithFormat:@"截止时间:%@",model.end_time];
    _nameLabel.text = model.task_title;
}

@end
