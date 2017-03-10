//
//  YMMyTaskCell.m
//  CloudPush
//
//  Created by YouMeng on 2017/2/27.
//  Copyright © 2017年 YouMeng. All rights reserved.


#import "YMMyTaskCell.h"

@interface YMMyTaskCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
//右边按钮
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
//左边按钮
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

@end

@implementation YMMyTaskCell

- (void)awakeFromNib {
    _rightBtn.sd_layout.widthIs(_rightBtn.width + 10).rightSpaceToView(self.contentView,15);
    _rightBtn.layer.borderColor = [UIColor colorwithHexString:@"3da3f5"].CGColor;
    _rightBtn.layer. borderWidth = 1;
    
    _leftBtn.sd_layout.widthIs(_leftBtn.width + 10).rightSpaceToView(_rightBtn,10);
    _leftBtn.layer.borderColor = [UIColor colorwithHexString:@"fab531"].CGColor;
    _leftBtn.layer.borderWidth = 1;
    
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

-(void)setModel:(YMTaskModel *)model{
    _model = model;

    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.del_status] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _titleLabel.text = model.task_title;
    _timeLabel.text = [NSString stringWithFormat:@"剩余时间:5天"];
    _priceLabel.text = [NSString stringWithFormat:@"¥%@元/单",model.price];
    
}

-(void)setCountModel:(YMTaskNumModel *)countModel{
    _countModel = countModel;
     _leftCountLabel.text = [NSString stringWithFormat:@"剩余单数：%d",([self.model.task_nums intValue] - [countModel.count_num intValue])];
    
}
- (IBAction)btnClick:(id)sender {

    if (self.actionBlock) {
        self.actionBlock(sender);
    }
}

@end
