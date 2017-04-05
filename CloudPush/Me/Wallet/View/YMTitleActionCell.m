//
//  YMTitleActionCell.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/22.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMTitleActionCell.h"

@implementation YMTitleActionCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)actBtnClick:(UIButton *)sender {
    if (self.actionBlock) {
        self.actionBlock(sender);
    }
}

//创建实例
+(instancetype)cellDequeueReusableCellWithTableView:(UITableView* )tableView{
    
    YMTitleActionCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
    }
    return cell;
}

-(void)cellWithTitle:(NSString* )title icon:(NSString* )iconStr {
    
    _iconImgView.image = [UIImage imageNamed:iconStr];
    _titlLabel.text = title;
    
    // CGRect newRect = [_titlLabel convertRect:_titlLabel.bounds toView:self.contentView];
    // DDLog(@"newRect  width  == %f  x === %f y == %f",newRect.size.width,newRect.origin.x,newRect.origin.y);
//    UIView* newView = [[UIView alloc]init];
//    //  WithFrame: CGRectMake(CGRectGetMaxX(newRect),CGRectGetMinY(newRect),4, 4)];
//    newView.layer.cornerRadius = 2;
//    newView.backgroundColor = RedColor;
//    newView.clipsToBounds = YES;
//    [_titlLabel addSubview:newView];
//    
//    newView.sd_layout.rightSpaceToView(_titlLabel,-3 ).topSpaceToView(_titlLabel,-3).widthIs(4).heightIs(4);
    
}
@end
