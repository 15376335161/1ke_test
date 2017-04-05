//
//  YMSectionCell.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/31.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMSectionCell.h"

@implementation YMSectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+(instancetype)cellDequeueReusableCellWithTableView:(UITableView* )tableView {
    YMSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
    }
    return cell;
}

@end
