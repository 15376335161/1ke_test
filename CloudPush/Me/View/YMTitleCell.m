//
//  YMTitleCell.m
//  CloudPush
//
//  Created by YouMeng on 2017/2/24.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMTitleCell.h"


@implementation YMTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

//创建实例
+(instancetype)cellDequeueReusableCellWithTableView:(UITableView* )tableView{
    YMTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
    }
    return cell;
}
-(void)cellWithTitle:(NSString* )title icon:(NSString* )iconStr {

    _imgView.image = [UIImage imageNamed:iconStr];
    _titlLabel.text = title;
    
   // CGRect newRect = [_titlLabel convertRect:_titlLabel.bounds toView:self.contentView];
    
   // DDLog(@"newRect  width  == %f  x === %f y == %f",newRect.size.width,newRect.origin.x,newRect.origin.y);
    UIView* newView = [[UIView alloc]init];
                     //  WithFrame: CGRectMake(CGRectGetMaxX(newRect),CGRectGetMinY(newRect),4, 4)];
    newView.layer.cornerRadius = 2;
    newView.backgroundColor = RedColor;
    newView.clipsToBounds = YES;
    [_titlLabel addSubview:newView];
    
    newView.sd_layout.rightSpaceToView(_titlLabel,-3 ).topSpaceToView(_titlLabel,-3).widthIs(4).heightIs(4);
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
}
@end
