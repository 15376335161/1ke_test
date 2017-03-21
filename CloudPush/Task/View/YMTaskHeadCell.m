//
//  YMTaskHeadCell.m
//  CloudPush
//
//  Created by YouMeng on 2017/2/28.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMTaskHeadCell.h"


@interface YMTaskHeadCell ()

//任务类型标签
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
//任务标题
@property (weak, nonatomic) IBOutlet UILabel *titlLabel;
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//价格
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
//区域范围
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
//目标人群
@property (weak, nonatomic) IBOutlet UILabel *crowdLabel;
//剩余单数
@property (weak, nonatomic) IBOutlet UILabel *leftCountLabel;
//状态
@property (weak, nonatomic) IBOutlet UIImageView *statusImgView;

@end

@implementation YMTaskHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.width = SCREEN_WIDTH;
    self.height = 104;
    
    // _tagLabel.sd_layout.widthIs(_tagLabel.width + 10);
    // _tagLabel.text
    
    _tagLabel.layer.cornerRadius = 2;
    _tagLabel.clipsToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+(instancetype)shareCell{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}
-(void)setModel:(YMTaskModel *)model{
    _model = model;
    _tagLabel.text  = model.billing_mode;
    _titlLabel.text = model.task_title;
   
     NSString* formatStr = @"yyyy-MM-dd HH:mm:ss";
    _timeLabel.text = [NSString stringWithFormat:@"至%@",[YMDateTool timeForDateFormatStr:model.end_time format:formatStr newFormat:@"yyyy-MM-dd"]];
    _priceLabel.text = [NSString stringWithFormat:@"%@元/单",model.price];
    _areaLabel.text  = model.spread_area;
    _crowdLabel.text = [NSString stringWithFormat:@"目标人群：%@",model.targetPeople];
    DDLog(@"target ==== %@",model.targetPeople);
    _leftCountLabel.text = [NSString stringWithFormat:@"剩余单数／总单数：%@／%@",model.surplu_nums,model.task_nums] ;
    
   
   NSDate* currentDate = [YMDateTool getCurrentDateWithFormat:formatStr];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:formatStr];
    NSDate *otherDate  = [formatter dateFromString:model.end_time];
    if ([YMDateTool compareDateWithFormatDate:currentDate withDate:otherDate]) {
        //已失效
        _statusImgView.image = [UIImage imageNamed:@"yishixiao"];
    }
    
}
@end
