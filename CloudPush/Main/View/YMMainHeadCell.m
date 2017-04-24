//
//  YMMainHeadCell.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/31.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMMainHeadCell.h"

@interface YMMainHeadCell ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *actionBtnArr;

@end
@implementation YMMainHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //消除分隔
    self.layoutMargins = UIEdgeInsetsZero;
    self.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+(instancetype)shareCell{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}
- (IBAction)actBtnClick:(id)sender {
    if (self.tapBlock) {
        self.tapBlock(sender);
    }
}


@end
