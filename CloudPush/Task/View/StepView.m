//
//  StepView.m
//  CloudPush
//
//  Created by YouMeng on 2017/2/28.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "StepView.h"

@interface StepView ( )

@property(nonatomic,strong)UILabel* titlLabel;
@property(nonatomic,strong)UIView * tagView;

@end

@implementation StepView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString* )title{
    if (self = [super initWithFrame:frame]) {
       
        self.tagView = [[UIView alloc]init];
        [self addSubview:self.tagView];
        self.tagView.backgroundColor = NavBarTintColor;
        self.tagView.layer.cornerRadius = 2;
        self.tagView.clipsToBounds = YES;
        //标题
        self.titlLabel = [[UILabel alloc]init];
        [self addSubview:self.titlLabel];
       
        self.titlLabel.textColor =  [UIColor colorwithHexString:@"333333"];//BlackColor;//
        self.titlLabel.textAlignment = NSTextAlignmentLeft;
        self.titlLabel.text = title;
        self.titlLabel.font = [UIFont systemFontOfSize:10];
        

        self.tagView.sd_layout.leftEqualToView(self).centerYEqualToView(self).widthIs(3.5).heightIs(11);
        
         CGFloat width =  [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}].width;
         self.titlLabel.sd_layout.leftSpaceToView(_tagView,5).centerYEqualToView(_tagView).widthIs(width).heightIs(13);
        
    }
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
}
@end
