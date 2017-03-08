//
//  YMTitleCell.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/1.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMTaskTitleCell.h"
#import "YMTaskModel.h"


@interface YMTaskTitleCell ()

//@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
//@property (weak, nonatomic) IBOutlet UILabel *titlLabel;

@end

@implementation YMTaskTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
+(instancetype)shareCell{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}
-(void)setModel:(YMTaskStatusModel *)model{
    _model = model;
    //YMTaskModel* model = model.myTaskList;
    _titlLabel.text = [model.myTaskList valueForKey:@"task_title"];
    
    
}
@end
