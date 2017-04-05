//
//  YMHeadItemCell.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/30.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMHeadItemCell.h"
#import "CateButton.h"

@implementation YMHeadItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(instancetype)initWithFrame:(CGRect)frame itemsTitlArr:(NSArray* )itemsTitlArr  imgsArr:(NSArray*)imgsArr{
    if (self == [super initWithFrame:frame]) {
        
        NSInteger count = itemsTitlArr.count;
        
        CGFloat MarGin = 10 ;
        CGFloat Width = (SCREEN_WIDTH - (count + 1) * MarGin)/count ;
        CGFloat Hight = Width + 5 ;
        
        CGFloat spaceX = MarGin;
        CGFloat spaceY = 0;

        for ( int i = 0 ; i < itemsTitlArr.count ; i ++ ) {
           
            CateButton * btn = [[CateButton alloc]initWithFrame:CGRectMake((i%count)*(Width+spaceX) + spaceX, spaceY+ (MarGin + Hight )*(i/count), Width, Hight) itemTitle:itemsTitlArr[i] icon:imgsArr[i]];
            btn.tag = i ;
            [btn addTarget:self action:@selector(itemsClick:) forControlEvents:UIControlEventTouchUpInside];
            //设置button的内容横向居中。。设置content是title和image一起变化
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self addSubview:btn];
        }
    }
    return self;
}

-(void)itemsClick:(CateButton* )btn{
    DDLog(@"按钮点击啦");
    if (self.tapBlock) {
        self.tapBlock(btn);
    }
}


@end
