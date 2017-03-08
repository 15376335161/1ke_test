//
//  YMDescContentCell.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/2.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMDescContentCell.h"

@implementation YMDescContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

+(instancetype)shareCell{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}
@end
