//
//  CateButton.m
//  挑食
//
//  Created by Lucky on 17/1/18.
//  Copyright © 2017年 赵振龙. All rights reserved.
//

#import "CateButton.h"
#import "SDAutoLayout.h"

@implementation CateButton

- (instancetype)initWithFrame:(CGRect)frame itemTitle:(NSString* )title icon:(NSString* )icon
{
    self = [super initWithFrame:frame];
    if (self) {
        // 27 * 35
        CGFloat width = frame.size.width;
       // CGFloat height = frame.size.height;
        
        _imagView = [[UIImageView alloc]initWithFrame:CGRectMake((width - 40)/2,15,40,40)];
        [_imagView sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage imageNamed:icon]];
        _imagView.contentMode = UIViewContentModeScaleAspectFit;
        //待修改
        _titlLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(_imagView.frame) + 10,width,20)];
        _titlLabel.textAlignment = NSTextAlignmentCenter;
        _titlLabel.font = [UIFont systemFontOfSize:14];
        _titlLabel.text = title;
        
        _titlLabel.textColor = BlackColor ;

    }
        [self addSubview:_imagView];
        [self addSubview:_titlLabel];
    
    return self;

}
-(void)layoutSubviews{
    [super layoutSubviews];
   // _imagView.sd_layout.centerYEqualToView(self);
    
}
@end
