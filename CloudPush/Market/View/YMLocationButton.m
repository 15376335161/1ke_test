//
//  YMLocationButton.m
//  CloudPush
//
//  Created by YouMeng on 2017/2/23.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMLocationButton.h"


@implementation YMLocationButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //待修改
        //_titlLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_imgView.frame)+2, y, 110, image.size.height)];
        _titlLabel = [[UILabel alloc]init];
        [self addSubview:_titlLabel];
        _titlLabel.textAlignment = NSTextAlignmentLeft;
        _titlLabel.font = [UIFont systemFontOfSize:13];
        _titlLabel.text = @"暂无位置信息";
        _titlLabel.textColor = WhiteColor;
        
        CGFloat width =  [_titlLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}].width;
        _titlLabel.sd_layout.leftSpaceToView(self,15).topEqualToView(self).bottomEqualToView(self).widthIs(width);
        
      
       // CGFloat y = (frame.size.height - image.size.height)/2;
        _imgView = [[UIImageView alloc]init];
         [self addSubview:_imgView];
        
        _imgView.sd_layout.leftSpaceToView(_titlLabel,2).widthIs(11).heightIs(11 * 13/22).centerYEqualToView(_titlLabel);
        
        UIImage *image = [UIImage imageNamed:@"city"];
        _imgView.image = image;
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        
    }

    return self;
}

-(void)layoutSubviews{
 
       CGFloat width =  [_titlLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}].width;
       _titlLabel.sd_layout.widthIs(width);

     _imgView.sd_layout.leftSpaceToView(_titlLabel,2).widthIs(11).heightIs(11 * 13/22).centerYEqualToView(_titlLabel);
    
    [super layoutSubviews];
}

@end
