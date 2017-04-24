//
//  YMReceHeadCell.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/1.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMReceHeadCell.h"

@interface YMReceHeadCell ()
@property (weak, nonatomic) IBOutlet UIImageView *statusImgView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@end


@implementation YMReceHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.width = SCREEN_WIDTH;
    self.height = 216;
    
    _leftBtn.layer.borderColor = NavBarTintColor.CGColor;
    _leftBtn.layer.borderWidth = 1;
    _leftBtn.clipsToBounds = YES;
    _leftBtn.layer.cornerRadius = 4;
    
//    _rightBtn.layer.borderColor = NavBarTintColor.CGColor;
//    _rightBtn.layer.borderWidth = 1;
     _rightBtn.clipsToBounds = YES;
     _rightBtn.layer.cornerRadius = 4;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+(instancetype)shareCell{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}
-(void)setModel:(YMTaskStatusModel *)model{
    _model = model;
//    _outTimeLabel.text = [NSString stringWithFormat:@"截止日期：%@",model.myTaskList[@"end_time"]];
//    _leftCountLabel.text = [NSString stringWithFormat:@"剩余单数：%d",([model.myTaskList[@"task_nums"] intValue] - [model.myTaskCounts[@"COUNT(id)"] intValue] )];
    
    
}
@end
