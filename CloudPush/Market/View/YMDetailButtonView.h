//
//  YMDetailButtonView.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/1.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMDetailButtonView : UIView

@property(nonatomic,strong)UILabel* titlLabel;

@property(nonatomic,strong)UIImageView* imgView;

@property(nonatomic,copy)void (^actionBlock)(UITapGestureRecognizer* tap);

//自定义按钮
//- (instancetype)initWithFrame:(CGRect)frame title:(NSString* )title textColor:(UIColor* )textColor font:(UIFont*)font   imgStr:(NSString* )imgStr ;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString* )title textColor:(UIColor* )textColor font:(UIFont*)font   imgStr:(NSString* )imgStr actionBlock:(void (^)(UITapGestureRecognizer* tap))actionBlock;
@end
