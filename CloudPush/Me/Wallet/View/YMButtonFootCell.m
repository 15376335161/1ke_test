//
//  YMButtonFootCell.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/16.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMButtonFootCell.h"

@implementation YMButtonFootCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // self.contentView.height = 30;
    //self.contentView.width  = SCREEN_WIDTH;
    //按钮颜色
    [YMTool viewLayerWithView:_sureBtn cornerRadius:4 boredColor:ClearColor borderWidth:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
+(instancetype)shareCell{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}

- (IBAction)actionBtnClick:(UIButton*)sender {
    self.actionBlock(sender);
}

@end
