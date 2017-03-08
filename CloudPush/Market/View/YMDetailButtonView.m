//
//  YMDetailButtonView.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/1.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMDetailButtonView.h"

@interface YMDetailButtonView ()<UIGestureRecognizerDelegate>

@end

@implementation YMDetailButtonView
//自定义按钮
- (instancetype)initWithFrame:(CGRect)frame title:(NSString* )title textColor:(UIColor* )textColor font:(UIFont*)font   imgStr:(NSString* )imgStr actionBlock:(void (^)(UITapGestureRecognizer* tap))actionBlock{
    self = [super initWithFrame:frame];
    if (self) {
        
        // CGFloat y = (frame.size.height - image.size.height)/2;
        _imgView = [[UIImageView alloc]init];
        [self addSubview:_imgView];
        UIImage *image = [UIImage imageNamed:imgStr];
        _imgView.image = image;
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        
        //宽高比
        CGFloat widthHeightRate = image.size.height/image.size.width;
        _imgView.sd_layout.rightSpaceToView(self,0).widthIs(11).heightIs(11 * widthHeightRate).centerYEqualToView(self);
        
        //待修改
        //_titlLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_imgView.frame)+2, y, 110, image.size.height)];
        _titlLabel = [[UILabel alloc]init];
        [self addSubview:_titlLabel];
        _titlLabel.textAlignment = NSTextAlignmentRight;
        _titlLabel.font = font;
        _titlLabel.text = title;
        _titlLabel.textColor = textColor;
        
        CGFloat width =  [_titlLabel.text sizeWithAttributes:@{NSFontAttributeName:font}].width;
        _titlLabel.sd_layout.rightSpaceToView(_imgView,2).topEqualToView(self).bottomEqualToView(self).widthIs(width);
        
        self.sd_layout.widthIs( ( 15 + _titlLabel.width + 2 )+ (_imgView.width));
        
        self.actionBlock = actionBlock;
        //添加手势
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moreClick:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
    }
    return self;
}
-(void)moreClick:(UITapGestureRecognizer* )tap{
    
    if (self.actionBlock) {
        self.actionBlock(tap);
    }
}

@end
