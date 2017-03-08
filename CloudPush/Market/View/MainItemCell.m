//
//  MainItemCell.m
//  CloudPush
//
//  Created by YouMeng on 2017/2/23.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "MainItemCell.h"
#import "MainItemButton.h"

@interface MainItemCell ()

//标题数组
@property(nonatomic,strong)NSArray* itemTitleArr;
@end

@implementation MainItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
//创建实例对象
-(instancetype)initWithFrame:(CGRect)frame itemTitleArr:(NSArray* )titleArr imgsArr:(NSArray* )imgsArr{
    if (self = [super initWithFrame:frame]) {
        self.itemTitleArr = [titleArr copy];
       // CGFloat margin = 25 * kWidthRate;
       // CGFloat width  = 45 * kWidthRate;
        CGFloat  width  = SCREEN_WIDTH/2;
        CGFloat heigh   = 173/2 * kWidthRate;
        
        UIColor* textColor = [[UIColor alloc]init];
        for (int i = 0 ; i < titleArr.count ; i ++) {
            if (i == 0) {
                textColor = [UIColor colorwithHexString:@"3cc0d3"];
            }
            if (i == 1) {
                textColor = [UIColor colorwithHexString:@"2bc075"];
            }
            if (i == 2) {
                textColor = [UIColor colorwithHexString:@"f05e5e"];
            }
            if (i == 3) {
                textColor = [UIColor colorwithHexString:@"996abf"];
            }
            
            MainItemButton * btn = [[MainItemButton alloc]initWithFrame:CGRectMake((i % 2) * width ,  (i/2) * heigh , width, heigh) title:titleArr[i] imgStr:imgsArr[i] titleColor:textColor];
            btn.tag = 23 + i;
            
           // [btn setBackgroundImage:[UIImage imageNamed:@"news"] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(itemsClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
        }
        UIView* xView = [[UIView alloc]init];
        [self addSubview:xView];
        xView.backgroundColor = BackGroundColor;
        
        xView.sd_layout.leftSpaceToView(self,10).rightSpaceToView(self,10).yIs(heigh).heightIs(1);
        
        UIView* yView = [[UIView alloc]init];
        [self addSubview:yView];
        yView.backgroundColor = BackGroundColor;
        
        yView.sd_layout.xIs(SCREEN_WIDTH/2).topEqualToView(self).bottomEqualToView(self).widthIs(1);

        
    }
    return self;
}
-(void)itemsClick:(MainItemButton* )btn{
  //  DDLog(@"点击了按钮  btn tag == %ld",(long)btn.tag);
    if (self.tapHandler) {
        self.tapHandler(btn);
    }
    
}
@end
