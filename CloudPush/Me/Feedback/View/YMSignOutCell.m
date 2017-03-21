//
//  YMSignOutCell.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/10.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMSignOutCell.h"

@implementation YMSignOutCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (IBAction)signOutBtnClick:(id)sender {
    
    if (self.signOutBlock) {
        self.signOutBlock(sender);
    }
}

+(instancetype)cellDequeueReusableCellWithTableView:(UITableView* )tableView{
    
    YMSignOutCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
    }
    return cell;
}

@end
