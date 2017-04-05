//
//  YMMeIconCell.m
//  CloudPush
//
//  Created by YouMeng on 2017/2/24.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMMeIconCell.h"

@interface YMMeIconCell ()<UIGestureRecognizerDelegate>

@end

@implementation YMMeIconCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = NavBarTintColor;
    self.contentView.backgroundColor = NavBarTintColor;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeUserIconClick:)];
    tap.delegate = self;
    self.iconImgView.userInteractionEnabled = YES;
    [self.iconImgView addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


-(instancetype)shareCellWithChangeIconBlock:(void(^)())changeIconBlock{
  
    YMMeIconCell * cell = [[[NSBundle mainBundle]loadNibNamed:@"YMMeIconCell" owner:nil options:nil]lastObject];
    cell.iconImgView.userInteractionEnabled = YES;
    self.changeIconBlock = changeIconBlock;
    
    

    return cell;
}
-(void)changeUserIconClick:(UITapGestureRecognizer* )tap{
    DDLog(@"点击啦头像");
    if (self.changeIconBlock) {
        self.changeIconBlock();
    }
}
@end
