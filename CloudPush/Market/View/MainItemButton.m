//
//  MainItemButton.m
//  CloudPush
//
//  Created by YouMeng on 2017/2/23.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "MainItemButton.h"

@interface MainItemButton ()


@property(nonatomic,strong)UIImageView* imgView;

@end

@implementation MainItemButton

-(instancetype)initWithFrame:(CGRect)frame title:(NSString* )title imgStr:(NSString* )imgStr titleColor:(UIColor* )titleColor {
    if (self = [super initWithFrame:frame]) {
        _titlLabel = [[UILabel alloc]init];
        [self addSubview:_titlLabel];
        
        _titlLabel.textAlignment = NSTextAlignmentLeft;
        _titlLabel.font = [UIFont systemFontOfSize:15];
        _titlLabel.text = title;
        _titlLabel.textColor = titleColor;
        
        CGFloat width =  [_titlLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}].width;
        _titlLabel.sd_layout.leftSpaceToView(self,25 * kWidthRate).centerYEqualToView(self).widthIs(width).heightIs(20);
        
        //图片
        _imgView = [[UIImageView alloc]init];
        [self addSubview:_imgView];
        
        _imgView.sd_layout.rightSpaceToView(self,25 * kWidthRate).widthIs(45 * kWidthRate).heightIs(45 * kWidthRate).centerYEqualToView(_titlLabel);
        
        UIImage *image = [UIImage imageNamed:imgStr];
        _imgView.image = image;
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
       
    }
    return self;
}

-(void)layoutSubviews{

    CGFloat width =  [_titlLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}].width;
    _titlLabel.sd_layout.leftSpaceToView(self,25 * kWidthRate).centerYEqualToView(self).widthIs(width).heightIs(20);
    
   _imgView.sd_layout.rightSpaceToView(self,25 * kWidthRate).widthIs(45 * kWidthRate).heightIs(45 * kWidthRate).centerYEqualToView(_titlLabel);
    
    [super layoutSubviews];
}

@end
