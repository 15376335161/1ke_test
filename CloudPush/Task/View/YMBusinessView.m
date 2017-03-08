//
//  YMBusinessView.m
//  CloudPush
//
//  Created by YouMeng on 2017/2/28.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMBusinessView.h"
#import "StepView.h"



@interface YMBusinessView ()

@property(nonatomic,strong)StepView* stepView;

@property(nonatomic,strong)UILabel* contentLabel;
@end

@implementation YMBusinessView


-(instancetype)initWithFrame:(CGRect)frame title:(NSString* )titile content:(NSString* )content{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = WhiteColor;
        // title 业务概况
        StepView* stepView1 = [[StepView alloc]initWithFrame:CGRectMake(15, 5, 50, 20) title:titile];
        [self addSubview:stepView1];
         //content
        _contentLabel = [[UILabel alloc]init];
        [self addSubview:_contentLabel];
        _contentLabel.text = content;
        _contentLabel.font = [UIFont systemFontOfSize:11];
        _contentLabel.textColor = [UIColor colorwithHexString:@"333333"];
        
        _contentLabel.sd_layout.leftEqualToView(stepView1).topSpaceToView(stepView1,5).rightSpaceToView(self,15).autoHeightRatio(0);
        CGFloat contentHeight = [YMHeightTools heightForText:content fontSize:11 width:SCREEN_WIDTH - 2 * 15];
        DDLog(@"contentHeight == %f",contentHeight);
        
        self.height = 20 + 5 * 2 + contentHeight + 5;
        
        DDLog(@"total height == %f",self.height);
        
    }
    return self;
}


@end
