//
//  YMTitleView.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/1.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMTitleView.h"


@interface YMTitleView ()


//显示器
@property(nonatomic,strong)UIView* indicatorView;

@property(nonatomic,strong)NSMutableArray* allBtnsArr;

@property(nonatomic,strong)UIButton* selectedBtn;
@end

@implementation YMTitleView

- (instancetype)initWithFrame:(CGRect)frame  titlesArr:(NSArray* )titlsArr selectColor:(UIColor *)selectColor normalColor:(UIColor* )normalColor clickBtnBlock:(void(^)(UIButton* btn))clickBtnBlock{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = WhiteColor;
        self.clickBtnBlock = clickBtnBlock;
        
        CGFloat  width = SCREEN_WIDTH / titlsArr.count;
        CGFloat  heigh = frame.size.height;
        CGFloat  lineHeight = 2;
        CGFloat  strWidth = 0;
        //滚动标签
        self.tagScrollView = [[UIScrollView alloc]init];
        _tagScrollView.width = SCREEN_WIDTH;
        _tagScrollView.height = heigh - lineHeight;
        _tagScrollView.y = 0;
        _tagScrollView.contentSize = CGSizeMake((SCREEN_WIDTH / 4) * titlsArr.count, heigh);
        _tagScrollView.showsHorizontalScrollIndicator = NO;
        _tagScrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_tagScrollView];

        //底部指示器
        self.indicatorView = [[UIView alloc] init];
        _indicatorView.backgroundColor = selectColor;
        _indicatorView.height = lineHeight;
       // _indicatorView.tag = -1;
        _indicatorView.y = _tagScrollView.height - _indicatorView.height;
        
        for (int i = 0 ;i < titlsArr.count ; i ++) {
            strWidth = [YMHeightTools widthForText:titlsArr[i] fontSize:11];
            UIButton* btn = [[UIButton alloc]init];
            btn.tag    = i;
            btn.height = heigh;
            btn.width  = width;
            btn.x      = i * width;

#warning todo - 颜色bug
            //按钮颜色有个bug
            [btn setTitle:titlsArr[i] forState:UIControlStateNormal];
            [btn setTitleColor:selectColor forState:UIControlStateNormal];
            btn.selected = YES;
            //选中状态
            [btn setTitleColor:normalColor  forState:UIControlStateSelected];
            btn.titleLabel.font = Font(11);
            [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.tagScrollView addSubview:btn];
            
            [self.allBtnsArr addObject:btn];
            if (i == 0) {
                btn.enabled = NO;
                self.selectedBtn = btn;
                btn.selected = YES;
                //根据button内部的文字宽度计算尺寸
                self.indicatorView.width   = strWidth;
                self.indicatorView.centerX = btn.centerX;
                DDLog(@"按钮的宽度 == %f",strWidth);
            }
        }
        [self.tagScrollView addSubview:_indicatorView];
        
        //默认执行一次
       // [self titleClick:self.allBtnsArr[0]];
    }
    return self;
}

-(void)titleClick:(UIButton* )button{
    if (self.clickBtnBlock) {
        self.clickBtnBlock(button);
    }
    for (UIButton* btn in self.allBtnsArr) {
        btn.selected = YES;
    }
    //标记
    self.flag = button.tag;
    
    //标签栏scrollView的滚动
    CGPoint offset_tag = self.tagScrollView.contentOffset;
    if (button.tag == 4) {
        offset_tag.x = (SCREEN_WIDTH / 4) * button.tag;
        [self.tagScrollView setContentOffset:offset_tag];
    }else if (button.tag < 4){
        offset_tag.x = 0;
        [self.tagScrollView setContentOffset:offset_tag];
    }
    
    //修改
    self.selectedBtn.enabled = YES;
    button.enabled = NO;
    button.selected = YES;
    self.selectedBtn = button;
    //self.selectedBtn.selected = YES;
    
    //动画
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.width = button.titleLabel.width;
        self.indicatorView.centerX = button.centerX;
    }];
    
//    //滚动
//    CGPoint offset = self.conScrollView.contentOffset;
//    offset.x = button.tag * self.conScrollView.width;
//    [self.conScrollView setContentOffset:offset animated:YES];
//    
//    [self scrollViewDidEndScrollingAnimation:self.conScrollView];

}
-(NSMutableArray *)allBtnsArr{
    if (!_allBtnsArr) {
        _allBtnsArr = [[NSMutableArray alloc]init];
    }
    return _allBtnsArr;
}
@end
