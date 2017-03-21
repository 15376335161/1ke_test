//
//  YMSpecTitleCell.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/10.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMSpecTitleCell.h"

@implementation YMSpecTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)actionBtnClick:(id)sender {
    DDLog(@"点击啦按钮");
    if (self.actionBlock) {
        self.actionBlock(sender);
    }
}

//创建实例
+(instancetype)cellDequeueReusableCellWithTableView:(UITableView* )tableView{
    YMSpecTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
    }
    return cell;
}

@end
