//
//  YMLocationButton.h
//  CloudPush
//
//  Created by YouMeng on 2017/2/23.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMLocationButton : UIButton

@property(nonatomic,strong)UILabel* titlLabel;

@property(nonatomic,strong)UIImageView* imgView;

//自定义按钮
- (instancetype)initWithFrame:(CGRect)frame title:(NSString* )title textColor:(UIColor* )textColor font:(UIFont*)font   imgStr:(NSString* )imgStr ;
@end
