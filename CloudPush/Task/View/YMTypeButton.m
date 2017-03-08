//
//  YMTypeButton.m
//  CloudPush
//
//  Created by YouMeng on 2017/2/24.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMTypeButton.h"

@interface YMTypeButton ()

@end
@implementation YMTypeButton

-(instancetype)initWithFrame:(CGRect)frame title:(NSString* )title imgStr:(NSString* )imgStr{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = WhiteColor;
        
        UIView* tmpView = [[UIView alloc]init];
        [self addSubview:tmpView];
        
        CGFloat width =  [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}].width;
        tmpView.sd_layout.widthIs(width + 11 + 2).topEqualToView(self).bottomEqualToView(self).centerXEqualToView(self);
        
        //标题
        _titlLabel = [[UILabel alloc]init];
        [tmpView addSubview:_titlLabel];
        _titlLabel.textAlignment = NSTextAlignmentLeft;
        _titlLabel.font = [UIFont systemFontOfSize:13];
        _titlLabel.text = title;
        _titlLabel.textColor = LightGrayColor;
        
       // CGFloat width =  [_titlLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}].width;
        _titlLabel.sd_layout.leftEqualToView(tmpView).topEqualToView(tmpView).bottomEqualToView(tmpView).widthIs(width);
        
        // CGFloat y = (frame.size.height - image.size.height)/2;
        _imgView = [[UIImageView alloc]init];
        [tmpView addSubview:_imgView];
        
        _imgView.sd_layout.leftSpaceToView(_titlLabel,2).widthIs(11).heightIs(11 * 13/22).centerYEqualToView(_titlLabel);
        
        
        UIImage *image = [UIImage imageNamed:imgStr];
        _imgView.image = image;
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        
        //自定义状态
        self.typeStatus = CustomTypeStatusUP;
        
    }
    return self;
}
//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
//{
//    
//    CGRect bounds = self.bounds;
//    //若原热区小于44x44，则放大热区，否则保持原大小不变
//    CGFloat widthDelta = MAX(44.0 - bounds.size.width, 0);
//    CGFloat heightDelta = MAX(44.0 - bounds.size.height, 0);
//    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
//    
//    return CGRectContainsPoint(bounds, point);
//}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    // _imgView.sd_layout.leftSpaceToView(_titlLabel,2).widthIs(11).heightIs(11 * 13/22).centerYEqualToView(tmpView);
}
@end
