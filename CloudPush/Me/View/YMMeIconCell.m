//
//  YMMeIconCell.m
//  CloudPush
//
//  Created by YouMeng on 2017/2/24.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMMeIconCell.h"

@implementation YMMeIconCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = NavBarTintColor;
    self.contentView.backgroundColor = NavBarTintColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


+(instancetype)shareCell{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}
@end
