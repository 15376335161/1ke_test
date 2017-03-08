//
//  YMTitleView.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/1.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMTitleView : UIView

@property(nonatomic,copy)void(^clickBtnBlock)(UIButton* btn);
//滚动标签view
@property(nonatomic,strong)UIScrollView* tagScrollView;
//标记
@property(nonatomic,assign)NSInteger flag;

- (instancetype)initWithFrame:(CGRect)frame  titlesArr:(NSArray* )titlsArr selectColor:(UIColor *)selectColor normalColor:(UIColor* )normalColor clickBtnBlock:(void(^)(UIButton* btn))clickBtnBlock;


-(void)titleClick:(UIButton* )button;
@end
